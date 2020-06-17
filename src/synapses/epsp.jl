"""
    epsp(t::Real, lastspike, q, taum, taus)
    epsp(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real}, taum::AbstractArray{<:Real}, taus::AbstractArray{<:Real})
    epsp(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real}, taum::CuVecOrMat{<:Real}, taus::CuVecOrMat{<:Real})

Evaluate an EPSP synapse. Modeled as `(ϵ₀ / τm - τs) * (exp(-Δ / τm) - exp(-Δ / τs)) Θ(Δ)`
  (where `Θ` is the Heaviside function and `Δ = t - lastspike`).
Specifically, this is the EPSP time course for the SRM0 model introduced by Gerstner.
Details: [Spiking Neuron Models: Single Neurons, Populations, Plasticity]
         (https://icwww.epfl.ch/~gerstner/SPNM/node27.html#SECTION02323400000000000000)

Use `CuVector` instead of `Vector` for GPU support.

# Fields
- `t`: current time
- `lastspike`: last pre-synaptic spike time
- `q`: amplitude
- `taum`: rise time constant
- `taus`: fall time constant
"""
function epsp(t::Real, lastspike, q, taum, taus)
    Δ = t - lastspike

    return (Δ >= 0 && Δ < Inf && taus != taum) * q / (1 - taus / taum) * (exp(-Δ / taum) - exp(-Δ / taus))
end
function epsp(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real}, taum::AbstractArray{<:Real}, taus::AbstractArray{<:Real})
    Δ = t .- lastspike
    I = @. q / (1 - taus / taum) * (exp(-Δ / taum) - exp(-Δ / taus))

    return map((ts, tm, δ, i) -> (δ >= 0) && (δ < Inf) && (ts != tm) ? i : zero(i), taus, taum, Δ, I)
end
function epsp(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real}, taum::CuVecOrMat{<:Real}, taus::CuVecOrMat{<:Real})
    Δ = t .- lastspike

    return @. (Δ >= 0) * (Δ < Inf) * (taus != taum) * q / (1 - taus / taum) * (exp(-Δ / taum) - exp(-Δ / taus))
end