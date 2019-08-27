"""
# module Settings



# Examples

```jldoctest
julia>
```
"""
module Settings

import JSON
import YAML

export load_settings

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
    end
    return dict
end

end
