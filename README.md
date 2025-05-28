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

## SPICE Kernels Setup

This package requires SPICE kernels for accurate calculations. You'll need to set up the kernels in your project:

### Option 1: Automatic Download (Recommended)

```julia
using Astrodynamics
using Downloads

# Create kernels directory in your project
kernel_dir = joinpath(pwd(), "kernels")
mkpath(kernel_dir)

# Download required kernels
const KERNELS = Dict(
    "naif0012.tls" => "https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls",
    "de442.bsp" => "https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de442.bsp",
    "gm_de440.tpc" => "https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/gm_de440.tpc",
    "pck00011.tpc" => "https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/pck00011.tpc"
)

for (file, url) in KERNELS
    dest = joinpath(kernel_dir, file)
    if !isfile(dest)
        @info "Downloading $file..."
        Downloads.download(url, dest)
    end
end

# Load the kernels
load_spice_kernels(kernel_dir)
```

### Option 2: Manual Download

1. Create a `kernels` directory in your project
2. Download the following files from https://naif.jpl.nasa.gov/pub/naif/generic_kernels/:
   - [naif0012.tls](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/lsk/naif0012.tls) (timekeeping)
   - [de442.bsp](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/de442.bsp) (position and velocity data)
   - [gm_de440.tpc](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/gm_de440.tpc) (mass parameters)
   - [pck00011.tpc](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/pck/pck00011.tpc) (physical properties)
3. Place all downloaded files in your project's `kernels` directory
4. Load the kernels in your code:
   ```julia
   using Astrodynamics
   load_spice_kernels()  # Will look in ./kernels by default
   ```

## Usage

```julia
using Astrodynamics

# First, load the SPICE kernels (required before any calculations)
load_spice_kernels()  # Uses ./kernels directory by default
# Or specify a custom kernel directory:
# load_spice_kernels("/path/to/my/kernels")

# Create celestial objects and perform calculations
sun = SolarSystem_Sun
earth = create_celestial_object("earth", sun, "ECLIPJ2000")
mars = create_celestial_object("mars", sun)

# Access object properties
println("Earth's gravitational parameter: $(earth.μ) km³/s²")
println("Mars's average radius: $(mars.R) km")
println("Earth's orbital eccentricity: $(earth.ecc)")
```

## Kernel Management Tips

1. **Project-Specific Kernels**: Each project using Astrodynamics.jl should maintain its own kernel directory. This allows different projects to use different kernel versions if needed.

2. **Version Control**: Consider whether to:
   - Add kernels to version control (increases repository size)
   - Add to .gitignore and document download steps
   - Use a shared kernel directory for multiple projects (specify path in `load_spice_kernels`)

3. **Kernel Updates**: NASA periodically releases updated kernels. Check the [NAIF website](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/) for updates.

## Dependencies
- SPICE.jl: Interface to NASA's SPICE toolkit

## License
MIT License 