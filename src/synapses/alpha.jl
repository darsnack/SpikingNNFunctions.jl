"""
    alpha(t, lastspike, q, tau)

Evaluate an alpha synapse.
Use `CuVector` instead of `Vector` for GPU support.

# Fields
- `t::Real`: current time
- `lastspike::Vector{<:Real}`: last pre-synaptic spike time
- `q::Vector{<:Real}`: amplitude
- `tau::Vector{<:Real}`: time constant
"""
function alpha(t::Real, lastspike, q, tau)
    Δ = t - lastspike

    return (Δ >= 0) * Δ * (q / tau) * exp(-(Δ - tau) / tau)
end
function alpha(t::Real, lastspike::Vector{<:Real}, q::Vector{<:Real}, tau::Vector{<:Real})
    Δ = t .- lastspike

    return @. (Δ >= 0) * Δ * (q / tau) * exp(-(Δ - tau) / tau)
end
function alpha(t::Real, lastspike::CuVector{<:Real}, q::CuVector{<:Real}, tau::CuVector{<:Real})
    Δ = t .- lastspike

    return @. (Δ >= 0) * Δ * (q / tau) * exp(-(Δ - tau) / tau)
end