using Documenter, CommandLineEquationsOfState

makedocs(;
    modules=[CommandLineEquationsOfState],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/singularitti/CommandLineEquationsOfState.jl/blob/{commit}{path}#L{line}",
    sitename="CommandLineEquationsOfState.jl",
    authors="Qi Zhang <singularitti@outlook.com>",
    assets=String[],
)

deploydocs(;
    repo="github.com/singularitti/CommandLineEquationsOfState.jl",
)
