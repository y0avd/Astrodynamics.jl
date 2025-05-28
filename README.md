# Astrodynamics.jl

A Julia package for astrodynamics calculations using SPICE kernels. This package provides tools for:
- Celestial body properties and calculations
- Orbital elements computation
- Solar system body information

## Installation

```julia
using Pkg
Pkg.add("Astrodynamics")
```

### SPICE Kernels Setup
Before using the package, you need to download the required SPICE kernels from NASA's NAIF server:

1. Create a `kernels` directory in your working directory
2. Download the following files from https://naif.jpl.nasa.gov/pub/naif/generic_kernels/:
   - [naif0012.tls](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls) (timekeeping)
   - [de442.bsp](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de442.bsp) (position and velocity data)
   - [gm_de440.tpc](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/gm_de440.tpc) (mass parameters)
   - [pck00011.tpc](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/pck00011.tpc) (physical properties)
3. Place all downloaded files in the `kernels` directory

## Usage

```julia
using Astrodynamics

# The package will look for SPICE kernels in the ./kernels directory
# Create celestial objects and perform calculations
sun = SolarSystem_Sun
earth = create_celestial_object("earth", sun, "ECLIPJ2000")
```

## Dependencies
- SPICE.jl: Interface to NASA's SPICE toolkit

## License
MIT License 