# Export types
export CelestialObject

# Export functions
export create_celestial_object

# Export constants
export CELESTIAL_OBJECTS

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

function create_celestial_object(name, primary_body, et = 0.0; frame = "J2000", update_existing = false)
    # Check if object already exists
    if haskey(CELESTIAL_OBJECTS, name)
        if update_existing
            @info "Updating existing celestial object: $name"
            # Continue to recreate the object with new parameters
        else
            @info "Returning existing celestial object: $name"
            return CELESTIAL_OBJECTS[name]
        end
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
        name, primary_body, et, # Object identification
        μ, Rv, R,               # Body properties
        orb[1:6]...,            # Orbital elements
        orb[9:11]...
    )
    
    # Store in global dictionary
    CELESTIAL_OBJECTS[name] = obj
    return obj
end