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

    return (Δ >= 0 && Δ < Inf) * Δ * (q / tau) * exp(-(Δ - tau) / tau)
end
function alpha(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real}, tau::AbstractArray{<:Real})
    @avx Δ = t .- lastspike
    @avx I = @. Δ * (q / tau) * exp(-(Δ - tau) / tau)

    return map((δ, i) -> (δ >= 0) && (δ < Inf) ? δ * i : zero(i), Δ, I)
end
function alpha(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real}, tau::CuVecOrMat{<:Real})
    Δ = t .- lastspike

    return @. (Δ >= 0) * (Δ < Inf) * Δ * (q / tau) * exp(-(Δ - tau) / tau)
end