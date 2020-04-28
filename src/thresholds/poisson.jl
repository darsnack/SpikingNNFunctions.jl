"""
    poisson(baserate, theta, deltav, v; dt)

Evaluate an array of inhomogeneous Poisson threshold functions.
Use `CuVector` instead of `Vector` to evaluate on GPU.

# Fields
- `baserate::Vector{<:Real}`: base line firing rate
- `theta::Vector{<:Real}`: nominal potential
- `deltav::Vector{<:Real}`: potential deviation
- `v::Vector{<:Real}`: membrane potential
- `dt::Real`: simulation timestep
"""
function poisson(baserate, theta, deltav, v; dt::Real)
    rho = baserate * exp((v - theta) / deltav)

    return rand() < rho * dt
end
function poisson(baserate::AbstractArray{<:Real}, theta::AbstractArray{<:Real}, deltav::AbstractArray{<:Real}, v::AbstractArray{<:Real}; dt::Real)
    @avx rho = baserate .* exp.((v .- theta) ./ deltav)

    return rand(length(rho)) .< rho .* dt
end
function poisson(baserate::CuVector{<:Real}, theta::CuVector{<:Real}, deltav::CuVector{<:Real}, v::CuVector{<:Real}; dt::Real)
    rho = baserate .* exp.((v .- theta) ./ deltav)

    return CuArrays.rand(length(rho)) .< rho .* dt
end