# This file holds functions and data for useful celestial bodies in our solar system
# Pulls from planetdata.csv for all planetary data, from NASA fact sheets 'https://nssdc.gsfc.nasa.gov/planetary/factsheet/'

struct Planet
    μ::Float64 # gravitional parameter [km^3/s^2]
    R::Float64 # equatorial radius [km]
    J₂::Float64 # J2 perturbation constant
    sma::Float64 # semi-major axis of heliocentric orbit [au]
    ecc::Float64 # eccentricity of heliocentric orbit
    inc::Float64 # inclination to J2000 [rad]
end

# note 6 constants in a planet struct

function CreatePlanet(planetKey::Int)
    # using planetdata.csv, we can build a dictionary containing useful planetary constants
    # planetKey is an integer from 0-8 corresponding to the Sun plus the 8 planets
    data::Vector{Float64} = []

    if planetKey >=0 && planetKey <= 8
        for idx in 1:6
            push!(data,10.0)
        end
    end

    return Planet(data[1],data[2],data[3],data[4],data[5],data[6])
end

p = CreatePlanet(1)

print(p)