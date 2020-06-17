"""
    delta(t::Real, lastspike, q)
    delta(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real})
    delta(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real})

Evaluate a Dirac-delta synapse.
Use `CuVector` instead of `Vector` for GPU support.

# Fields
- `t`: current time
- `lastspike`: last pre-synaptic spike time
- `q`: amplitude
"""
delta(t::Real, lastspike, q) = (t ≈ lastspike) * q
delta(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real}) = (t .≈ lastspike) .* q
delta(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real}) = (t .≈ lastspike) .* q