using Documenter, SpikingNNFunctions

makedocs(;
    modules=[SpikingNNFunctions],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
        "API" => [
            "Neurons" => "neurons.md",
            "Synapses" => "synapses.md",
            "Thresholds" => "thresholds.md",
        ],
    ],
    repo="https://github.com/darsnack/SpikingNNFunctions.jl/blob/{commit}{path}#L{line}",
    sitename="SpikingNNFunctions.jl",
    authors="Kyle Daruwalla",
    assets=String[],
)

deploydocs(;
    repo="github.com/darsnack/SpikingNNFunctions.jl",
)