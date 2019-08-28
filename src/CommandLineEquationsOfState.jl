module CommandLineEquationsOfState

__precompile__()

include("Settings.jl")
include("argparse.jl")

# See [doc](https://docs.julialang.org/en/v1/manual/modules/#Module-initialization-and-precompilation-1)
function __init__()
    parsed_args = parse_commandline()
    command = parsed_args["%COMMAND%"]
    Settings.run_settings(parsed_args[command]["settings"])
end

end # module
