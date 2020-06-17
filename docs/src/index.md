# SpikingNNFunctions.jl

Fast spiking neural network primitive functions for use in other packages. The primary purpose of the package is to act as a dependency for [SpikingNN.jl](https://github.com/darsnack/SpikingNN.jl). Exctracting these primitives into their own package allows users to easily extend SpikingNN.jl (similar to NNlib.jl's role to Flux.jl).

Functions are designed to dispatch on scalar arguments, array arguments, and `CuArray` arguments. So, the function should be available no matter what device you intend to run on.

For testing, refer to the [SpikingNN.jl](https://github.com/darsnack/SpikingNN.jl) repo where these primitives are covered as part of testing.

## Future Work

- Using [LoopVectorization.jl](https://github.com/chriselrod/LoopVectorization.jl) to speed up CPU implementations (currently this causes issues for AMD CPUs)
- Exploring dispatch on sparse arrays