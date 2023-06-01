# This file holds functions and data for useful celestial bodies in our solar system
# Pulls from planetdata.csv for all planetary data

function CreatePlanet(planetKey::Int)
    # using planetdata.csv, we can build a dictionary containing useful planetary constants
    # planetKey is an integer from 0-8 corresponding to the Sun plus the 8 planets
    Planet = Dict()

    if planetKey >=0 && planetKey <= 8

        Planet[]
    end

    return Planet
end
struct Body
    μ::Float64 # gravitional parameter [km^3/s^2]
    R::Float64 # equatorial radius [km]
    J₂::Float64 # J2 perturbation constant
    ω::Float64 # angular rotation [rad/s]
    sma::Float64 # semi-major axis of heliocentric orbit [km]
    ecc::Float64 # eccentricity of heliocentric orbit [km]
    inc::Float64 # inclination to J2000 [km]
end