module Astrodynamics

using SPICE

# Export types and functions
export CelestialObject, create_celestial_object
export SolarSystem_Sun
export load_spice_kernels

# Include other source files
include("Constants.jl")

end # module 