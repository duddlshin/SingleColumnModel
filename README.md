# SingleColumnModel

Single-column model (SCM) for testing turbulence parameterizations in atmospheric boundary layer (ABL) flows.

ABL cases: 
- Truly neutral boundary layer (TNBL)
- Conventionally neutral boundary layer (CNBL)
- Stable boundary layer (SBL)
- Channel flow

Numerical methods
- Time integration: Runge-Kutta 4
- Spatial differencing: 2nd order central difference

Wall treatment: shear stress formulation based on Monin-Obhukov Similarity Theory

Turbulence models:
- Standard k-epsilon model (Launder & Spalding, 1974)
- ABL k-epsilon model (Detering & Etling, 1985)
- Renormalization group k-epsilon model (Yakhot & Orszag, 1986)
- MOST k-epsilon model (van der Laan et al., 2017)

Color scheme used: https://www.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap

