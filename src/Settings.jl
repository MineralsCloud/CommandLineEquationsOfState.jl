"""
# module Settings



# Examples

```jldoctest
julia>
```
"""
module Settings

using EquationsOfState.Collections
import JSON
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
end

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

end
