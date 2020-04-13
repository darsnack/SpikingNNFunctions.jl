"""
    delta(t, lastspike, q)

Evaluate a Dirac-delta synapse.
Use `CuVector` instead of `Vector` for GPU support.

# Fields
- `t::Real`: current time
- `lastspike::Vector{<:Real}`: last pre-synaptic spike time
- `q::Vector{<:Real}`: amplitude
"""
delta(t::Real, lastspike, q) = (t ≈ lastspike) * q
delta(t::Real, lastspike::AbstractArray{<:Real}, q::AbstractArray{<:Real}) = (t .≈ lastspike) .* q
delta(t::Real, lastspike::CuVecOrMat{<:Real}, q::CuVecOrMat{<:Real}) = (t .≈ lastspike) .* q