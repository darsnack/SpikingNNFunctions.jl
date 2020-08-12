"""
    lif(t::Real, I, V; R, tau)
    lif!(t::AbstractArray{<:Real}, I::AbstractArray{<:Real}, V::AbstractArray{<:Real}; R::AbstractArray{<:Real}, tau::AbstractArray{<:Real})
    lif!(t::CuVector{<:Real}, I::CuVector{<:Real}, V::CuVector{<:Real}; R::CuVector{<:Real}, tau::CuVector{<:Real})

Evaluate a leaky integrate-and-fire neuron.
Use `CuVector` instead of `Vector` to evaluate on GPU.

# Fields
- `t`: time since last evaluation in seconds
- `I`: external current
- `V`: current membrane potential
- `vrest`: resting membrane potential
- `R`: resistance constant
- `tau`: time constant
"""
function lif(t::Real, I, V; vrest, R, tau)
    V = V * exp(-t / tau) + vrest
    V += I * (R / tau)

    return V
end
function lif!(t::AbstractArray{<:Real}, I::AbstractArray{<:Real}, V::AbstractArray{<:Real}; vrest::AbstractArray{<:Real}, R::AbstractArray{<:Real}, tau::AbstractArray{<:Real})
    # account for leakage
    @. V = V * exp(-t / tau) + vrest

    # apply update step
    @. V += I * (R / tau)

    return V
end
function lif!(t::CuVector{<:Real}, I::CuVector{<:Real}, V::CuVector{<:Real}; vrest::CuVector{<:Real}, R::CuVector{<:Real}, tau::CuVector{<:Real})
    # account for leakage
    @. V = V * exp(-t / tau) + vrest

    # apply update step
    @. V += I * (R / tau)

    return V
end