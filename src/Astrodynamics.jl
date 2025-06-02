module Astrodynamics

using SPICE, Makie, LinearAlgebra, Rotations

# Include other source files
include("Constants.jl")
include("SpiceUtils.jl")
include("CelestialObjects.jl")
include("GraphingUtils.jl")

# Export functions
export create_solar_system_sun, create_solar_system, set_et!, set_frame!

# global variables
export et, frame

const et = Ref(0.0)
const frame = Ref("J2000")

function set_et!(et_value)
    et[] = et_value
end

function set_frame!(frame_value)
    frame[] = frame_value
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

function create_solar_system()
    sun = create_solar_system_sun()
    
    planets = ["mercury", "venus", "earth", "mars", "jupiter", "saturn", "uranus", "neptune"]
    for planet in planets
        if !haskey(CELESTIAL_OBJECTS, planet)
            @info "Creating celestial object for $planet..."
            CELESTIAL_OBJECTS[planet] = create_celestial_object(planet, sun, barycenter = true)
        end
    end
    
    return CELESTIAL_OBJECTS
end

end # module 