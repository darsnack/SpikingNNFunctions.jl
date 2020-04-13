"""
    lif!(I, V; R, vreset, tau)

Evaluate a leaky integrate-and-fire neuron.
Use `CuVector` instead of `Vector` to evaluate on GPU.

# Fields
- `I::Vector{<:Real}`: external current
- `V::Vector{<:Real}`: membrane potential
- `R::Vector{<:Real}`: resistance constant
- `vreset::Vector{<:Real}`: reset potential
- `tau::Vector{<:Real}`: time constant
"""
function lif(t::Real, I, V; R, tau)
    V *= exp(-t / tau)
    V += I * (R / tau)

    return V
end
function lif!(t::AbstractArray{<:Real}, I::AbstractArray{<:Real}, V::AbstractArray{<:Real}; R::AbstractArray{<:Real}, tau::AbstractArray{<:Real})
    # account for leakage
    @. V *= exp(-t / tau)

    # apply update step
    @. V += I * (R / tau)

    return V
end
function lif!(t::CuVector{<:Real}, I::CuVector{<:Real}, V::CuVector{<:Real}; R::CuVector{<:Real}, tau::CuVector{<:Real})
    # account for leakage
    @. V *= exp(-t / tau)

    # apply update step
    @. V += I * (R / tau)

    return V
end