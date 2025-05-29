# Export functions
export create_ellipsoid, create_axis3, graph_celestial_object

function create_ellipsoid(center, R; n = 100)
    # Handle R input - can be either a single float or any array with 3 elements
    if isa(R, Real)
        # If R is a single number, create Rv as [R, R, R]
        Rv = [R, R, R]
    elseif isa(R, AbstractArray) && length(R) == 3
        # If R is any array with exactly 3 elements (vector or matrix), convert to a vector
        Rv = [R[i] for i in 1:3]
    else
        error("R must be either a single number or an array with exactly 3 elements representing radii [rx, ry, rz]")
    end
  
    # Generate ellipsoid coordinates
    θ = LinRange(0, π, n)
    ϕ = LinRange(0, 2π, 2 * n)
    x = [center[1] + Rv[1] * cos(ϕ) * sin(θ) for θ in θ, ϕ in ϕ]
    y = [center[2] + Rv[2] * sin(ϕ) * sin(θ) for θ in θ, ϕ in ϕ]
    z = [center[3] + Rv[3] * cos(θ) for θ in θ, ϕ in ϕ]
    
    return x, y, z
end

function create_axis3(fig, x=1, y=1)
    ax = Axis3(
        fig[x,y],
        title = "Earth Plot",
        xlabel = "x [km]",
        ylabel = "y [km]",
        zlabel = "z [km]",
        aspect = :data,
        azimuth = pi/4,
        elevation = pi/4
    );
end

function graph_celestial_object(ax, o::CelestialObject, c=(0,0,0); sphere = true, img = :blue)
    surface!(ax, create_ellipsoid(c, sphere ? o.R : o.Rv)..., color = img)
end