# Astrodynamics.jl

A Julia package for astrodynamics calculations using SPICE kernels. This package provides tools for:
- Celestial body properties and calculations
- Orbital elements computation
- Solar system body information
- Easy access to cached celestial objects
- Interactive 3D visualization of celestial objects and orbits

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/y0avd/Astrodynamics.jl")
```

### Visualization Backend

This package uses Makie.jl for visualization. You'll need to install one of the Makie backends:

```julia
# Choose one of the following:
Pkg.add("GLMakie")    # OpenGL-based interactive backend (recommended for desktop)
Pkg.add("CairoMakie") # Cairo-based static vector graphics
Pkg.add("WGLMakie")   # WebGL-based, displays plots in the browser
Pkg.add("RPRMakie")   # Experimental ray-tracing backend
```

Then, in your code, import the desired backend:

```julia
using GLMakie   # or any other backend
using Astrodynamics
```

## SPICE Kernels Setup

This package requires SPICE kernels for accurate calculations. 

**Kernel Updates**: NASA periodically releases updated kernels. Check the [NAIF website](https://naif.jpl.nasa.
gov/pub/naif/generic_kernels/) for updates.

You'll need to set up the kernels in your project:

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

### Basic Setup and Solar System Creation

```julia
using GLMakie  # Choose your preferred Makie backend
using Astrodynamics

# First, load the SPICE kernels
load_spice_kernels()

# Initialize the entire solar system (creates Sun and all planets)
create_solar_system()
```

### Accessing Celestial Objects

All celestial objects are cached in the `CELESTIAL_OBJECTS` dictionary for easy access:

```julia
# Access objects directly from the dictionary
earth = CELESTIAL_OBJECTS["earth"]
mars = CELESTIAL_OBJECTS["mars"]
jupiter = CELESTIAL_OBJECTS["jupiter"]

# The Sun is also available as a constant
sun = SolarSystem_Sun  # or CELESTIAL_OBJECTS["sun"]

# Create new objects (they'll be automatically cached)
moon = create_celestial_object("moon", earth)  # moon orbiting Earth
phobos = create_celestial_object("phobos", mars)  # Phobos orbiting Mars

# Access the newly created objects from the cache
cached_moon = CELESTIAL_OBJECTS["moon"]
```

### Accessing Object Properties

Each celestial object contains detailed information about its physical properties and orbit:

```julia
# Physical properties
println("Earth's gravitational parameter: $(earth.μ) km³/s²")
println("Mars's average radius: $(mars.R) km")
println("Jupiter's radii vector: $(jupiter.Rv) km")  # [equatorial, equatorial, polar]

# Orbital elements
println("Earth's orbital eccentricity: $(earth.ecc)")
println("Mars's semi-major axis: $(mars.a) km")
println("Moon's inclination: $(moon.i) radians")
println("Phobos's orbital period: $(phobos.T) seconds")
```

### Available Properties

Each `CelestialObject` includes:

- **Physical Properties**
  - `μ`: Gravitational parameter (GM) [km³/s²]
  - `R`: Average equatorial radius [km]
  - `Rv`: Vector of radii [equatorial, equatorial, polar] [km]

- **Orbital Elements**
  - `rp`: Perifocal distance [km]
  - `ecc`: Eccentricity
  - `i`: Inclination [rad]
  - `Ω`: Longitude of ascending node [rad]
  - `ω`: Argument of periapsis [rad]
  - `M0`: Mean anomaly at epoch [rad]
  - `ν`: True anomaly at epoch [rad]
  - `a`: Semi-major axis [km]
  - `T`: Orbital period [s]

### Object Caching

- Objects are created only once and cached in `CELESTIAL_OBJECTS`
- Subsequent requests return the cached object
- Thread-safe (using constant dictionary)
- Memory efficient (no duplicate objects)

## Dependencies

This package requires the following Julia packages:

- **SPICE.jl**: Interface to NASA's SPICE toolkit for spacecraft navigation and planetary science
- **Makie.jl**: High-performance interactive visualization package for scientific data and 3D graphics
  - *Note*: You'll need to install one of the Makie backends (GLMakie, CairoMakie, WGLMakie, or RPRMakie)
- **LinearAlgebra**: Standard library for linear algebra operations (vectors, matrices, etc.)
- **Rotations.jl**: 3D rotation parameterizations and transformations (used for handling rotation matrices, quaternions, and related operations)

For more information about Makie backends, see the [Makie documentation](https://docs.makie.org/stable/).

## License
MIT License 
