"""
    alpha(t::Real, lastspike, q, tau)
    alpha(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real}, tau::AbstractArray{<:Real})
    alpha(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real}, tau::CuVecOrMat{<:Real})

Evaluate an alpha synapse. Modeled as `(t - lastspike) * (q / τ) * exp(-(t - lastspike - τ) / τ) Θ(t - lastspike)`
  (where `Θ` is the Heaviside function).
Use `CuVector` instead of `Vector` for GPU support.

# Fields
- `t`: current time
- `lastspike`: last pre-synaptic spike time
- `q`: amplitude
- `tau`: time constant
"""
function alpha(t::Real, lastspike, q, tau)
    Δ = t - lastspike

    return (Δ >= 0 && Δ < Inf) * Δ * (q / tau) * exp(-(Δ - tau) / tau)
end
function alpha(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real}, tau::AbstractArray{<:Real})
    Δ = t .- lastspike
    I = @. Δ * (q / tau) * exp(-(Δ - tau) / tau)

    return map((δ, i) -> (δ >= 0) && (δ < Inf) ? δ * i : zero(i), Δ, I)
end
function alpha(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real}, tau::CuVecOrMat{<:Real})
    Δ = t .- lastspike

    return @. (Δ >= 0) * (Δ < Inf) * Δ * (q / tau) * exp(-(Δ - tau) / tau)
end