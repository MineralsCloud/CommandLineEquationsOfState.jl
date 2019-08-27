using ArgParse

using CommandLineEquationsOfState.Settings

function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--version", "-v"
            help = "print the version of this package"
        "fit"
            help = "fit (an) equation(s) of state"
            action = :command
        "calc"
            help = "calculate energy/pressure/bulk modulus of (an) equation(s) of state"
            action = :command
    end

    @add_arg_table s["fit"] begin
        "settings"
            help = "the settings file location"
            action = :store_arg
    end

    @add_arg_table s["calc"] begin
        "settings"
            help = "the settings file location"
            action = :store_arg
    end

    return parse_args(s)
end
