# Results — Centrifugal Water Pump Design

This document summarizes the final computed results from the centrifugal pump sizing and verification workflow implemented in `analysis/Script.m`. All values are based on the specified operating point and validated against accepted turbomachinery design heuristics.

---

## Design Requirements

| Parameter | Value |
|--------|------|
| Volumetric flow rate | **1500 gpm** |
| Head rise | **500 ft** |
| Rotational speed | **2500 rpm** |
| Working fluid | Water |

---

## Performance Results

| Quantity | Result |
|-------|--------|
| Hydraulic efficiency (estimated) | **0.78** |
| Shaft power | **≈ 243 HP** |
| Shaft torque | **≈ 510 ft·lbf** |
| Non-dimensional specific speed (Ωs) | **0.3349** |

---

## Inlet (Eye) Geometry & Velocities

| Parameter | Result |
|--------|--------|
| Eye diameter (De) | **≈ 6.40 in** |
| Inlet diameter (D1) | **6.40 in** |
| Inlet blade height (b1) | **≈ 1.24 in** |
| Inlet absolute velocity (V1) | **≈ 19.2 ft/s** |
| Inlet blade speed (U1) | **≈ 69.8 ft/s** |
| Inlet relative velocity (W1) | **≈ 72.4 ft/s** |
| Inlet flow angle (βf1) | **≈ 15.4°** |

---

## Impeller Outlet Geometry & Velocities

| Parameter | Result |
|--------|--------|
| Impeller exit diameter (D2) | **≈ 15.96 in** |
| Outlet blade speed (U2) | **≈ 174.2 ft/s** |
| Tangential velocity component (Vu2) | **Computed via Euler head relation** |
| Radial velocity component (Vr2) | **Computed from outlet triangle** |
| Outlet blade height (b2) | **≈ 0.71 in** |

---

## Blade Design

| Parameter | Result |
|--------|--------|
| Inlet blade angle (βb1) | **17°** |
| Outlet blade angle (βb2) | **22.5°** |
| Final blade count | **9 (forced to satisfy solidity)** |
| Blade profile method | **Linear angle interpolation, r₁ → r₂** |
| Discretization steps | **10 radial increments** |

A blade count override was applied after the initial rounded estimate failed the solidity constraint. Recomputing slip and outlet velocities with the enforced blade count yielded an acceptable design.

---

## Design Quality Checks

| Metric | Result | Acceptable Range | Status |
|------|------|----------------|------|
| Solidity factor (σ) | **≈ 2.8** | 2.5 – 3.0 | ✅ Pass |
| Diffusion factor (W₂/W₁) | **≈ 0.96** | 0.7 – 1.0 | ✅ Pass |

Both solidity and diffusion factor fall within recommended limits, indicating acceptable blade loading and flow deceleration behavior.

---

## Volute / Diffuser Results

| Parameter | Result |
|--------|--------|
| Volute throat velocity (Vt) | **Computed via K₃ correlation** |
| Throat area (At) | **Derived from continuity** |
| Exit diameter (D3) | **1.08 × D2** |
| Volute centroid radius (rc) | **Converged via iteration** |

The volute sizing loop converged to a stable centroid radius, consistent with angular momentum conservation and assumed loss coefficient.

---

## Summary

The final design satisfies:
- Target flow rate, head, and speed
- Acceptable hydraulic efficiency
- Valid inlet and outlet velocity triangles
- Industry-standard solidity and diffusion constraints

This project demonstrates a complete centrifugal pump design workflow, integrating turbomachinery theory, empirical selection methods, and computational verification using MATLAB.

---

## Reproducibility

All results in this document are reproducible using:
- `analysis/Script.m`

Key parameters (blade angles, blade count, discretization) can be adjusted directly in the script input section to explore alternate design configurations.
