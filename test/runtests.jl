using Test
using Astrodynamics

@testset "Astrodynamics.jl" begin
    # Test Sun object
    @test SolarSystem_Sun.name == "sun"
    @test SolarSystem_Sun.primary_body === nothing
    @test SolarSystem_Sun.μ > 0

    # Test creating Earth object
    earth = create_celestial_object("earth", SolarSystem_Sun, "ECLIPJ2000")
    @test earth.name == "earth"
    @test earth.primary_body === SolarSystem_Sun
    @test earth.μ > 0
    @test earth.a > 0  # Semi-major axis should be positive for Earth's orbit
    @test 0 ≤ earth.ecc < 1  # Earth's orbit is nearly circular
end 