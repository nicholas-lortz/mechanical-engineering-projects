%% Residential Water Distribution System Solver
% Solves a three-segment residential piping network supplying an upstairs shower
% using Bernoulli’s equation with major/minor losses.
%
% Why iteration?
%   The Darcy friction factor f depends on Reynolds number Re, which depends on
%   velocity. This couples the governing equations and requires a numerical solve.
%
% Method:
%   Fixed-point iteration on inlet velocity V1 until percent change < 1%.
%
% Primary outputs:
%   V1, V2, V3 : segment velocities (m/s)
%   Q_L_min    : volumetric flow rate (L/min)
%   f1, f2, f3 : Darcy friction factors
%   err_pct    : final iteration percent change (%)
%
% Notes:
%   - Assumes steady, incompressible, single-phase flow at 20°C.
%   - Pressures treated as absolute (consistent with project statement/report).

clc;
clear;

%% ------------------------
%  User Controls / Settings
%  ------------------------
V1_init_mps   = 10.0;      % Initial inlet velocity guess (m/s)
tol_pct       = 1.0;       % Convergence tolerance (% change)
max_iters     = 200;       % Iteration safety limit
print_summary = true;      % Set false to suppress console output

%% -----------------------------
%  Fluid Properties (Water @20°C)
%  -----------------------------
rho_kg_m3 = 998.2;         % Density (kg/m^3)
nu_m2_s   = 1.004e-6;      % Kinematic viscosity (m^2/s)
g_m_s2    = 9.81;          % Gravitational acceleration (m/s^2)

%% -------------------------
%  Boundary Conditions
%  -------------------------
p_in_Pa  = 550000;         % Inlet pressure (Pa, absolute)
p_out_Pa = 101325;         % Outlet pressure (Pa, atmospheric)
z_in_m   = 0.0;            % Inlet elevation datum (m)
z_out_m  = 7.0;            % Outlet elevation (m) = 6 m + 1 m rise

%% -------------------------
%  Pipe Geometry
%  -------------------------
% Segment 1: commercial steel
D1_m = 2.54e-2;            % Diameter (m)
L1_m = 10.0;               % Length (m)
eps1_m = 0.045e-3;         % Roughness (m)

% Segment 2: drawn copper
D2_m = 1.27e-2;
L2_m = 8.0;
eps2_m = 0.0015e-3;

% Segment 3: drawn copper
D3_m = 0.95e-2;
L3_m = 1.0;
eps3_m = 0.0015e-3;

A1_m2 = pi*(D1_m^2)/4;     % Cross-sectional area (m^2)
A2_m2 = pi*(D2_m^2)/4;
A3_m2 = pi*(D3_m^2)/4;

% Precompute area ratios used repeatedly
AR12 = (A1_m2/A2_m2);      % V2 = AR12 * V1
AR13 = (A1_m2/A3_m2);      % V3 = AR13 * V1
AR12_sq = AR12^2;
AR13_sq = AR13^2;

%% -------------------------
%  Minor Loss Coefficients
%  -------------------------
% Segment 2 components
K_elbow_90_short = 1.5;
K_tee_inline     = 0.9;
K_globe_open     = 10.0;

% Abrupt contractions
K_contr_12 = 0.41;
K_contr_23 = 0.22;

% Terminal discharge
K_shower = 1.5;

% Aggregate minor-loss K's by segment (referenced to local segment velocity)
K_minor_seg2 = 2*K_elbow_90_short + 2*K_tee_inline + K_globe_open + K_contr_12;
K_minor_seg3 = K_shower + K_contr_23;

%% -------------------------
%  Solve Setup
%  -------------------------
% Bernoulli driving term in "head" form (m^2/s^2) expressed as energy per mass
% Numerator here is (Δp/ρ + gΔz). (Velocity head terms handled in denominator.)
drive_term = (p_in_Pa - p_out_Pa)/rho_kg_m3 + g_m_s2*(z_in_m - z_out_m);

if drive_term <= 0
    error('Non-positive driving term: check pressures/elevations; flow cannot be solved as written.');
end

V1_mps = V1_init_mps;
err_pct = inf;
iter = 0;

%% -------------------------
%  Fixed-Point Iteration
%  -------------------------
while (err_pct > tol_pct) && (iter < max_iters)
    iter = iter + 1;

    % Continuity: velocities in downstream segments
    V2_mps = AR12 * V1_mps;
    V3_mps = AR13 * V1_mps;

    % Reynolds numbers (Re = V*D/nu)
    Re1 = (V1_mps * D1_m) / nu_m2_s;
    Re2 = (V2_mps * D2_m) / nu_m2_s;
    Re3 = (V3_mps * D3_m) / nu_m2_s;

    % Friction factors (Darcy) via Haaland correlation
    f1 = haalandDarcyF(Re1, eps1_m, D1_m);
    f2 = haalandDarcyF(Re2, eps2_m, D2_m);
    f3 = haalandDarcyF(Re3, eps3_m, D3_m);

    % -------------------------
    % Build denominator terms
    % -------------------------
    % Start from the velocity head difference term expressed in V1^2 form.
    %
    % Using:
    %   V2 = (A1/A2)*V1, V3 = (A1/A3)*V1
    %
    % The following formulation mirrors the project’s rearranged Bernoulli
    % form used to compute V1 = sqrt(drive_term / denom).
    %
    % denom includes:
    %   - velocity head contribution
    %   - major losses (f L/D)
    %   - minor losses (K)
    %
    % All expressed as coefficients multiplying V1^2.

    % Velocity head contribution (as used in the project formulation)
    vel_head_coeff = (AR13_sq/2) - 0.5;

    % Major loss coefficients (Darcy–Weisbach): f*(L/D)*(1/2)*(V_local^2), mapped to V1^2
    major_coeff_1 = (f1 * (L1_m/D1_m)) * 0.5;
    major_coeff_2 = (f2 * (L2_m/D2_m)) * 0.5 * AR12_sq;
    major_coeff_3 = (f3 * (L3_m/D3_m)) * 0.5 * AR13_sq;

    % Minor loss coefficients: K*(1/2)*(V_local^2), mapped to V1^2
    minor_coeff_2 = K_minor_seg2 * 0.5 * AR12_sq;
    minor_coeff_3 = K_minor_seg3 * 0.5 * AR13_sq;

    denom = vel_head_coeff + major_coeff_1 + major_coeff_2 + major_coeff_3 + minor_coeff_2 + minor_coeff_3;

    if denom <= 0
        error('Non-positive denominator encountered. Check K values, geometry, or formulation.');
    end

    % Update inlet velocity from rearranged Bernoulli expression
    V1_new_mps = sqrt(drive_term / denom);

    % Percent change for convergence check
    err_pct = abs(V1_mps - V1_new_mps) / V1_new_mps * 100;

    % Iterate
    V1_mps = V1_new_mps;
end

if iter >= max_iters && err_pct > tol_pct
    warning('Did not converge within max_iters=%d. Final err=%.4f%%', max_iters, err_pct);
end

%% -------------------------
%  Final Calculations
%  -------------------------
V2_mps = AR12 * V1_mps;
V3_mps = AR13 * V1_mps;

Q_m3_s   = V1_mps * A1_m2;
Q_L_min  = Q_m3_s * 1e3 * 60;

%% -------------------------
%  Report
%  -------------------------
if print_summary
    fprintf('\n--- Residential Water System: Final Results ---\n');
    fprintf('Iterations:                 %d\n', iter);
    fprintf('Inlet velocity, V1:         %.4f m/s\n', V1_mps);
    fprintf('Segment 2 velocity, V2:     %.4f m/s\n', V2_mps);
    fprintf('Segment 3 velocity, V3:     %.4f m/s\n', V3_mps);
    fprintf('Volumetric flow rate, Q:    %.3f L/min\n', Q_L_min);
    fprintf('Friction factors (Darcy):   f1=%.4f, f2=%.4f, f3=%.4f\n', f1, f2, f3);
    fprintf('Final percent change:       %.6f %%\n', err_pct);
end

%% -------------------------
%  Local Function
%  -------------------------
function f = haalandDarcyF(Re, eps_m, D_m)
% haalandDarcyF  Darcy friction factor from Haaland correlation.
% Valid for turbulent/transition regimes; used here as specified by assignment.
%
% Inputs:
%   Re    - Reynolds number (dimensionless)
%   eps_m - Absolute roughness (m)
%   D_m   - Pipe diameter (m)

    if Re <= 0
        error('Invalid Reynolds number: Re must be > 0.');
    end

    % Correlation form used in the project statement
    theta1 = (-2.457 * log((7/Re)^0.9 + 0.27*(eps_m/D_m)))^16;
    theta2 = (37530/Re)^16;
    f = 8 * ( (8/Re)^12 + 1/((theta1 + theta2)^1.5) )^(1/12);
end
