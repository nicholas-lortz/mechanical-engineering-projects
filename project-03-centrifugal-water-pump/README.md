# Centrifugal Water Pump — Design & Performance Analysis

Designed and analyzed a centrifugal water pump to meet a specified operating point, using classical turbomachinery relationships, Cordier diagram selection, and a MATLAB-based sizing/verification script.

## Target Operating Point (Given)
- Flow rate: **1500 gpm**
- Speed: **2500 rpm**
- Head rise: **500 ft**

## Key Results (Design Outputs)
- Impeller type: **Radial flow** (selected via specific speed + Cordier diagram)
- Estimated hydraulic efficiency: **~78%**
- Non-dimensional specific speed (Ωs): **0.3349**
- Non-dimensional specific diameter (Ds): **~8.2**
- Exit diameter (D2): **15.96 in**
- Shaft power (Psh): **133,680 ft·lbf/s ≈ 243 HP**

### Inlet Conditions (Computed)
- Shaft diameter: **3.17 in**
- Inlet diameter (D1): **6.40 in**
- Inlet area: **25 in²**
- Blade height at inlet (B1): **1.24 in**
- Velocities:
  - V1: **19.19 ft/s**
  - U1: **69.8 ft/s**
  - W1: **72.4 ft/s**
- Inlet flow angle: **15.37°**

### Outlet Conditions (Initial)
- U2: **174.2 ft/s**
- Initial blade count (rounded): **5**
- Slip coefficient: **0.7596**
- W2: **69.63 ft/s**
- Diffusion factor: **0.96**
- Outlet area: **33.6 in²**
- Blade height at outlet (B2): **0.71 in**

## Method Summary
1. Converted inputs into consistent units and computed **dimensional/non-dimensional specific speed**.
2. Used the **Cordier diagram** to select an appropriate impeller family and estimate efficiency.
3. Sized the impeller exit diameter (D2), then solved inlet/outlet velocity triangles and passage geometry.
4. Generated an **impeller blade profile** via incremental radial steps (10-step discretization from r1 → r2).
5. Verified design health using:
   - **Solidity factor** check (prompted blade count refinement when out of target range)
   - **Diffusion factor** re-check to confirm acceptable flow deceleration behavior

## MATLAB Script
The full sizing + verification workflow is implemented in:
- `analysis/Script.m`

Notable controls in the script:
- `overrideBladeCount` — used to manually enforce a blade count when the solidity check fails the target band (the design converged to a higher blade count than the initial rounded estimate).

## Files
- `report/EGME452Project_REDACTED.pdf` — report version safe for public sharing
- `analysis/Script.m` — MATLAB analysis script

## Visuals (Add)
Recommended images to include in `/images`:
- Cordier diagram selection snapshot (with your plotted operating point)
- Inlet/outlet velocity triangles
- Blade profile plot (r–θ, or planform)

## Notes
This project demonstrates end-to-end mechanical design reasoning: converting requirements into turbomachinery selection, geometry sizing, and verification against stability/quality metrics (solidity, diffusion).
