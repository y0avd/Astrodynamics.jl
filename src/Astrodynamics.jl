module Astrodynamics

using SPICE

# Export types
export CelestialObject

# Export main functions
export create_celestial_object, load_spice_kernels
export create_solar_system, create_solar_system_sun

# Export constants and data structures
export CELESTIAL_OBJECTS, SolarSystem_Sun

# Export useful SPICE functions for convenience
export utc2et, et2utc, spkezr, oscltx, bodvrd, furnsh

# Include other source files
include("Constants.jl")

mutable struct CelestialObject
    # Object identification
    name::String
    primary_body::Union{Nothing, CelestialObject}
    et::Float64
    
    # Body properties
    μ::Float64      # gravitional parameter [km^3/s^2]
    Rv::Vector{Float64} # vector of radii [km]
    R::Float64      # average equatorial radius [km]
    
    # Orbital elements
    rp::Float64     # Perifocal distance
    ecc::Float64    # Eccentricity
    i::Float64      # Inclination [rad]
    Ω::Float64      # Longitude of ascending node [rad]
    ω::Float64      # Argument of periapsis [rad]
    M0::Float64     # Mean anomaly at epoch
    ν::Float64      # True anomaly at epoch
    a::Float64      # Semi-major axis (0 if not computable)
    T::Float64      # Orbital period (0 if not elliptical)
end

# Global dictionary to store all celestial objects
const CELESTIAL_OBJECTS = Dict{String, CelestialObject}()

"""
Load all SPICE kernels from the specified directory.
This should be called by the user's project after adding required kernels.
"""
function load_spice_kernels(kernel_dir=joinpath(pwd(), "kernels"))
    if !isdir(kernel_dir)
        error("Kernels directory not found at $kernel_dir. Please create a 'kernels' directory in your project root and download the required SPICE kernels.")
    end
    
    # Common SPICE kernel extensions
    kernel_extensions = [".tls", ".bsp", ".tpc", ".tf", ".ti", ".tsc", ".ik", ".tk", ".pck", ".bc", ".bpc", ".tsp"]
    
    # Load all kernel files in the directory
    loaded = false
    for file in readdir(kernel_dir)
        # Check if file has a known SPICE kernel extension
        if any(endswith.(file, kernel_extensions))
            @info "Loading kernel: $file"
            furnsh(joinpath(kernel_dir, file))
            loaded = true
        end
    end
    
    if !loaded
        error("No SPICE kernel files found in $kernel_dir. Kernel files should have extensions: $(join(kernel_extensions, ", "))")
    end
end

function create_solar_system_sun()
    if !haskey(CELESTIAL_OBJECTS, "sun")
        sun_μ = bodvrd("sun", "GM")[1]
        sun_Rv = bodvrd("sun", "RADII")
        sun_R = sum(sun_Rv) / 3
        CELESTIAL_OBJECTS["sun"] = CelestialObject("sun", nothing, 0.0, sun_μ, sun_Rv, sun_R, 
                                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    end
    return CELESTIAL_OBJECTS["sun"]
end

function create_solar_system(frame = "J2000", et = 0.0)
    sun = create_solar_system_sun()
    
    planets = ["mercury", "venus", "earth", "mars", "jupiter", "saturn", "uranus", "neptune"]
    for planet in planets
        if !haskey(CELESTIAL_OBJECTS, planet)
            @info "Creating celestial object for $planet..."
            CELESTIAL_OBJECTS[planet] = create_celestial_object(planet * "_barycenter", sun, frame, et)
        end
    end
    
    return CELESTIAL_OBJECTS
end

function create_celestial_object(name, primary_body, frame = "J2000", et = 0.0)
    # Check if object already exists
    base_name = replace(name, "_barycenter" => "")
    if haskey(CELESTIAL_OBJECTS, base_name)
        return CELESTIAL_OBJECTS[base_name]
    end
    
    # Get body properties
    μ = bodvrd(name, "GM")[1]
    Rv = bodvrd(name, "RADII")
    R = sum(Rv) / 3
    
    # Get orbital elements
    state = spkezr(name, et, frame, "NONE", primary_body.name)
    orb = oscltx(state[1], et, primary_body.μ)
    
    # Create the object
    obj = CelestialObject(
        base_name, primary_body, et, # Object identification
        μ, Rv, R,               # Body properties
        orb[1:6]...,            # Orbital elements
        orb[9:11]...            # Orbital elements
    )
    
    # Store in global dictionary
    CELESTIAL_OBJECTS[base_name] = obj
    return obj
end

end # module 