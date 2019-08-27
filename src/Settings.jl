"""
# module Settings



# Examples

```jldoctest
julia>
```
"""
module Settings

using CSV
using EquationsOfState
using EquationsOfState.Collections
using EquationsOfState.NonlinearFitting
import JSON
using MLStyle
import YAML

export load_settings, parse_settings

function load_settings(file::AbstractString)
    open(file, "r") do io
        ext = lowercase(splitext(file)[2])
        dict = if ext == ".json"
            JSON.parse(io)
        elseif ext in (".yaml", ".yml")
            YAML.load(io)
        else
            error("Invalid extension!")
        end
        return dict
    end
end  # function load_settings

parse_settings(file::AbstractString) = parse_settings(load_settings(file))
function parse_settings(d::AbstractDict)
    dict = deepcopy(d)
    eos = dict["eos"]
    eos isa AbstractDict || error("The parameter 'eos' must be a YAML dict!")
    length(eos) == length(dict["output"]) || throw(DimensionMismatch("The number of outputs is not equal to the number of equations of state given!"))
    for (key, value) in eos
        dict["eos"][key] = eval(Symbol(key))(value...)
    end
    return dict
end  # function parse_settings

run_settings(file::AbstractString) = (run_settings ∘ parse_settings ∘ load_settings)(file)
function run_settings(dict::AbstractDict)
    eos = dict["eos"]
    eos isa AbstractDict || error("The parameter 'eos' must be a YAML dict!")
    any(!isa(e, EquationOfState) for e in values(eos)) && error("The equation of state is not an `EquationsOfState`!")
    dataframe = CSV.read(dict["input"])
    xdata, ydata = dataframe[1], dataframe[2]
    relation = @match dict["relation"] begin
        "e" => EnergyRelation
        "p" => PressureRelation
        "b" => BulkModulusRelation
    end
    for (i, (key, value)) in enumerate(eos)
        fitted = lsqfit(relation, value, collect(xdata), collect(ydata))
        println("The fitted equation of state is: ", fitted)
        output = dict["output"][i]
        isfile(output) || touch(output)
        open(output, "r+") do io
            JSON.print(io, Dict(key => fitted))
        end
    end
end  # function run_settings

end
