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

    return (Δ >= 0 && Δ < Inf && taus != taum) * q / (1 - taus / taum) * (exp(-Δ / taum) - exp(-Δ / taus))
end
function epsp(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real}, taum::AbstractArray{<:Real}, taus::AbstractArray{<:Real})
    Δ = t .- lastspike
    I = @. q / (1 - taus / taum) * (exp(-Δ / taum) - exp(-Δ / taus))

    return @. (Δ >= 0) * (Δ < Inf) * (taus != taum) * I
end
function epsp(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real}, taum::CuVecOrMat{<:Real}, taus::CuVecOrMat{<:Real})
    Δ = t .- lastspike

    return @. (Δ >= 0) * (Δ < Inf) * (taus != taum) * q / (1 - taus / taum) * (exp(-Δ / taum) - exp(-Δ / taus))
end