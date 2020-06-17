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
function srm0!(t::Real, I::AbstractArray{<:Real}, V::AbstractArray{<:Real}; lastspike::AbstractArray{<:Real}, eta)
    V .= map.(eta, (t .- lastspike))
    V .+= I
end
srm0!(t::Real, I::CuVector{<:Real}, V::CuVector{<:Real}; lastspike::CuVector{<:Real}, eta) =
    V .= map.(eta, t .- lastspike) .+ I