module Astrodynamics

using SPICE

# Export types and functions
export CelestialObject, create_celestial_object
export SolarSystem_Sun

# Include other source files
include("Constants.jl")

end # module 