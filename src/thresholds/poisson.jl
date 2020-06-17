"""
    poisson(baserate, theta, deltav, v; dt::Real)
    poisson(baserate::AbstractArray{<:Real}, theta::AbstractArray{<:Real}, deltav::AbstractArray{<:Real}, v::AbstractArray{<:Real}; dt::Real)
    poisson(baserate::CuVector{<:Real}, theta::CuVector{<:Real}, deltav::CuVector{<:Real}, v::CuVector{<:Real}; dt::Real)

Evaluate inhomogeneous Poisson process threshold functions.
Modeled as

``X < \\mathrm{d}t \\rho_0 \\exp\\left(\\frac{v - \\Theta}{\\Delta_u}\\right)``

where ``X \\sim \\mathrm{Unif}([0, 1])``.

Use `CuVector` instead of `Vector` to evaluate on GPU.

# Fields
- `baserate`: base line firing rate
- `theta`: threshold potential
- `deltav`: potential resolution
- `v`: current membrane potential
- `dt`: simulation timestep
"""
function poisson(baserate, theta, deltav, v; dt::Real)
    rho = baserate * exp((v - theta) / deltav)

    return rand() < rho * dt
end
function poisson(baserate::AbstractArray{<:Real}, theta::AbstractArray{<:Real}, deltav::AbstractArray{<:Real}, v::AbstractArray{<:Real}; dt::Real)
    rho = baserate .* exp.((v .- theta) ./ deltav)

    return rand(length(rho)) .< rho .* dt
end
function poisson(baserate::CuVector{<:Real}, theta::CuVector{<:Real}, deltav::CuVector{<:Real}, v::CuVector{<:Real}; dt::Real)
    rho = baserate .* exp.((v .- theta) ./ deltav)

    return CuArrays.rand(length(rho)) .< rho .* dt
end