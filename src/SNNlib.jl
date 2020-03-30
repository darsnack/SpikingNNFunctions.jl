module SNNlib

using CuArrays
const use_cuda = Ref(false)

include("neurons/Neuron.jl")
include("synapses/Synapse.jl")
include("thresholds/Threshold.jl")

function __init__()
    use_cuda[] = CuArrays.functional() # Can be overridden after load with `Flux.use_cuda[] = false`
    if CuArrays.functional()
        if !CuArrays.has_cudnn()
            @warn "CuArrays.jl found cuda, but did not find libcudnn. Some functionality will not be available."
        end
    end
end

end