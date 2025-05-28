using SPICE

# Load SPICE kernels from the kernels directory
const KERNEL_DIR = joinpath(".", "kernels")
isdir(KERNEL_DIR) || error("Kernels directory not found. Please create a 'kernels' directory and download the required SPICE kernels as described in the README.")

# Load SPICE kernels - https://naif.jpl.nasa.gov/pub/naif/generic_kernels/
furnsh(joinpath(KERNEL_DIR, "naif0012.tls")) # timekeeping
furnsh(joinpath(KERNEL_DIR, "de442.bsp")) # position and velocity data for major solar system bodies
furnsh(joinpath(KERNEL_DIR, "gm_de440.tpc")) # mass parameters for major solar system bodies
furnsh(joinpath(KERNEL_DIR, "pck00011.tpc")) # physical properties of major solar system bodies

# Initializes useful astrodynamic constants as global variables
const au = 149597870.7 # astronomical unit [km]
const yr = 365.24219 # sidereal year [days]

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

if !@isdefined(SolarSystem_Sun)
    sun_μ = bodvrd("sun", "GM")[1]
    sun_Rv = bodvrd("sun", "RADII")
    sun_R = sum(sun_Rv) / 3
    const SolarSystem_Sun = CelestialObject("sun", nothing, 0.0, sun_μ, sun_Rv, sun_R, 
                               0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
end

function create_celestial_object(name, primary_body, frame = "J2000", et = 0.0)
    # Get body properties
    μ = bodvrd(name, "GM")[1]
    Rv = bodvrd(name, "RADII")
    R = sum(Rv) / 3
    
    # Get orbital elements
    state = spkezr(name, et, frame, "NONE", primary_body.name)
    orb = oscltx(state[1], et, primary_body.μ)
    
    return CelestialObject(
        name, primary_body, et, # Object identification
        μ, Rv, R,               # Body properties
        orb[1:6]...,            # Orbital elements
        orb[9:11]...            # Orbital elements
    )
end