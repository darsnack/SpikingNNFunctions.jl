"""
    srm0(t::Real, I, V; lastspike, eta)
    srm0!(t::Real, I::AbstractArray{<:Real}, V::AbstractArray{<:Real}; lastspike::AbstractArray{<:Real}, eta)
    srm0!(t::Real, I::CuVector{<:Real}, V::CuVector{<:Real}; lastspike::CuVector{<:Real}, eta)

Evaluate a SRM0 neuron.
Use `CuVector` instead of `Vector` to evaluate on GPU.

# Fields
- `t`: current time in seconds
- `I`: external current
- `V`: current membrane potential
- `lastspike`: time of last output spike in seconds
- `eta`: post-synaptic response function
"""
srm0(t::Real, I, V; lastspike, eta) = eta(t - lastspike) + I
function srm0!(t::Real, I::AbstractArray{<:Real}, V::AbstractArray{<:Real}; lastspike::AbstractArray{<:Real}, eta)
    V .= map.(eta, (t .- lastspike))
    V .+= I
end
srm0!(t::Real, I::CuVector{<:Real}, V::CuVector{<:Real}; lastspike::CuVector{<:Real}, eta) =
    V .= map.(eta, t .- lastspike) .+ I