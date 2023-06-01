# Initializes useful astrodynamic constants as global variables

struct Body
    μ::Float64 # gravitional parameter [km^3/s^2]
    R::Float64 # equatorial radius [km]
    J₂::Float64 # J2 perturbation constant
    sma::Float64 # semi-major axis of heliocentric orbit [au]
    ecc::Float64 # eccentricity of heliocentric orbit
    inc::Float64 # inclination to J2000 [rad]
end

const au = 149597870.7 # astronomical unit [km]
const yr = 365.24219 # sidereal year [days]
const ω⨁ = 2pi/(24*3600) # [rad/sec] Earth angular rotation

# data from NASA fact sheets 'https://nssdc.gsfc.nasa.gov/planetary/factsheet/'
sun = Body(132712440041.279419, 695700, 0, 0, 0, 0)
mercury = Body(22031.86855, 2440.5, 0.0000503, 0.38709893, 0.20563069, deg2rad(7.00487))
venus = Body(324858.592, 6051.8, 0.000004458, 0.72333199, 0.00677323, deg2rad(3.39471))
# const earth = Planet(398600.4355, 6378.137, 0.001082635, )
# const mars = Planet(42828.37582, 3396.2, 0.00196045, )
# const jupiter = Planet(126712764.1, 71492, 0.014736, )
# const saturn = Planet(37940584.84, 60268, 0.016298, )
# const uranus = Planet(5794556.4, 25558, 0.00334343, )
# const nepture = Planet(6836527.101, 24764, 0.003411, )