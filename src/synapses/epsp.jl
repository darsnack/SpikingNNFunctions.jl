"""
    epsp(t, lastspike, q, tau)

Evaluate an EPSP synapse.
Use `CuVector` instead of `Vector` for GPU support.

# Fields
- `t::Real`: current time
- `lastspike::Vector{<:Real}`: last pre-synaptic spike time
- `q::Vector{<:Real}`: amplitude
- `taum::Vector{<:Real}`: rise time constant
- `taus::Vector{<:Real}`: fall time constant
"""
function epsp(t::Real, lastspike, q, taum, taus)
    Δ = t - lastspike

    return (Δ >= 0) * q / (taum - taus) * (exp(-Δ / taum) - exp(-Δ / taus))
end
function epsp(t::Real, lastspike::Vector{<:Real}, q::Vector{<:Real}, taum::Vector{<:Real}, taus::Vector{<:Real})
    Δ = t .- lastspike

    return @. (Δ >= 0) * q / (taum - taus) * (exp(-Δ / taum) - exp(-Δ / taus))
end
function epsp(t::Real, lastspike::CuVector{<:Real}, q::CuVector{<:Real}, taum::CuVector{<:Real}, taus::CuVector{<:Real})
    Δ = t .- lastspike

    return @. (Δ >= 0) * q / (taum - taus) * (exp(-Δ / taum) - exp(-Δ / taus))
end