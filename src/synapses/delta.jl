"""
    delta(t, lastspike, q)

Evaluate a Dirac-delta synapse.
Use `CuVector` instead of `Vector` for GPU support.

# Fields
- `t::Real`: current time
- `lastspike::Vector{<:Real}`: last pre-synaptic spike time
- `q::Vector{<:Real}`: amplitude
"""
delta(t::Real, lastspike, q) = (t == lastspike) * q
delta(t::Real, lastspike::Vector{<:Real}, q::Vector{<:Real}) = (t .== lastspike) .* q
delta(t::Real, lastspike::CuVector{<:Real}, q::CuVector{<:Real}) = (t .== lastspike) .* q