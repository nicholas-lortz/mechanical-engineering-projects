# Water Distribution System Design and Analysis

## Overview

Designed and analytically validated a multi-segment residential water distribution system supplying an upstairs shower, incorporating elevation changes, abrupt contractions, fittings, and terminal discharge losses.

The project required solving a coupled, nonlinear fluid system in which friction factors depend on Reynolds number and velocity, precluding a closed-form solution. A custom iterative numerical solver was developed to determine steady-state velocities and volumetric flow rate with high accuracy.

This work emphasizes engineering judgment, defensible assumptions, and verification through convergence rather than theoretical idealization.

---

## System Description

The system consists of three pipe segments operating under steady, incompressible flow conditions:

- **Steel main line**
  - Diameter: 2.54 cm
  - Length: 10 m
  - Supply pressure: 550 kPa

- **Drawn copper riser**
  - Diameter: 1.27 cm
  - Length: 8 m
  - Elevation rise: 6 m
  - Components: two short-radius 90° elbows, two inline T-joints, one fully open globe valve

- **Terminal copper discharge**
  - Diameter: 0.95 cm
  - Length: 1 m
  - Elevation rise: 1 m
  - Discharge to atmosphere through a showerhead (K = 1.5)

Abrupt contractions occur between each pipe segment. Water properties correspond to 20 °C operation.

---

## Mechanical Engineering Concepts Applied

- Bernoulli’s equation with major and minor losses  
- Darcy–Weisbach friction modeling  
- Reynolds-number–dependent friction factor calculation (Haaland correlation)  
- Conservation of mass across changing diameters  
- System head curve formulation  
- Fixed-point iterative numerical methods  
- Engineering convergence criteria and error analysis  

---

## Engineering Approach

Bernoulli’s equation was formulated between the system inlet and outlet, explicitly accounting for:

- Pressure head
- Velocity head
- Elevation changes
- Major losses for each pipe segment
- Minor losses from fittings, contractions, and terminal discharge

Because friction factors depend on Reynolds number—and therefore velocity—the governing equations are coupled and nonlinear. A fixed-point iteration scheme was implemented in MATLAB to solve for inlet velocity.

The algorithm:
1. Accepts an initial velocity guess  
2. Computes downstream velocities via continuity  
3. Updates Reynolds numbers and friction factors per segment  
4. Solves a modified Bernoulli equation for a new inlet velocity  
5. Iterates until percent difference between successive solutions falls below 1%

---

## Validation and Convergence

The numerical solution converged rapidly, typically within three to four iterations. Convergence was verified numerically and graphically by tracking inlet velocity stabilization.

Key assumptions were explicitly documented, including steady-state operation, incompressible flow, constant fluid properties, and idealized component loss coefficients. Final results were interpreted within the bounds of these assumptions.

---

## Results

| Quantity | Value |
|------|------|
| Inlet Velocity (Pipe 1) | **1.0339 m/s** |
| Pipe 2 Velocity | 4.1355 m/s |
| Pipe 3 Velocity | 7.3907 m/s |
| Volumetric Flow Rate | **31.432 L/min** |
| Friction Factor (Pipe 1) | 0.0285 |
| Friction Factor (Pipe 2) | 0.0211 |
| Friction Factor (Pipe 3) | 0.0200 |
| Final Percent Error | **0.000667%** |

The final solution exceeded the required accuracy threshold by several orders of magnitude, demonstrating numerical stability and internal consistency.

---

## Deliverables

- Full technical memo documenting problem definition, methodology, assumptions, and results  
- MATLAB implementation of iterative solver with convergence checking  
- Professional piping system diagram drafted in CAD  
- Tabulated results and convergence verification  

---

## What This Project Demonstrates

- Ability to analyze real-world fluid systems with non-ideal losses  
- Engineering judgment in solving coupled nonlinear equations  
- Practical application of fluid mechanics beyond textbook examples  
- Development of custom numerical tools for engineering analysis  
- Clear technical documentation suitable for peer review  

---

## Notes

Originally completed as part of an undergraduate mechanical engineering curriculum and curated to reflect professional engineering analysis and documentation standards.
