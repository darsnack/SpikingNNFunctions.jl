"""
    srm0!(I, lastspike; eta)

Evaluate a SRM0 neuron.
Use `CuVector` instead of `Vector` to evaluate on GPU.

# Fields
- `I::Vector{<:Real}`: external current
- `lastspike::Vector{<:Real}`: time of last output spike
- `eta::Vector{Function}`: post-synaptic response function
"""
srm0(t::Real, I, V; lastspike, eta) = eta(t - lastspike) + I
srm0!(t::Real, I::Vector{<:Real}, V::Vector{<:Real}; lastspike::Vector{<:Real}, eta::Vector{<:Function}) =
    (V .= map.(x -> eta(t - x), lastspike) .+ I)
srm0!(t::Real, I::CuVector{<:Real}, V::CuVector{<:Real}; lastspike::CuVector{<:Real}, eta::Vector{<:Function}) =
    (V .= map.(x -> eta(t - x), lastspike) .+ I)