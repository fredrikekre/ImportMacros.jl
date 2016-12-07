__precompile__()

module ImportMacros

export @import, @using

"""
```julia
@import MyLongModuleName as m
```

Load the module `MyLongModuleName` with `import` and binds it to `m`.
Equivalent to

```julia
import MyLongModuleName
const m = MyLongModuleName
```
"""
:(@import)

"""
```julia
@using MyLongModuleName as m
```

Load the module `MyLongModuleName` with `using` and binds it to `m`.
Equivalent to

```julia
using MyLongModuleName
const m = MyLongModuleName
```
"""
:(@using)

# generate the macros
for macroname in ("import", "using")
    @eval begin
        macro $(Symbol(macroname))(M::Union{Symbol, Expr}, kw::Symbol, m::Symbol)
            # input check
            kw == :as || throw(ArgumentError("syntax error: expected `as`, got `$kw`"))
            isdefined(m) && throw(ArgumentError("alias `$m` already defined"))

            # create operator expression
            names = get_names(M)
            ex = Expr(Symbol($macroname))
            for n in names
                push!(ex.args, n)
            end

            return quote
                $(esc(ex))
                const $(esc(m)) = $(esc(M))
                nothing
            end
        end
    end
end

# utility function to extract names from expression
function get_names(x)
    isa(x, Symbol)   && return (x, )
    x.head == :quote && return (x.args[1], )
    x.head == :.     && return (get_names(x.args[1])..., get_names(x.args[2])...)
    throw(ArgumentError("invalid module name"))
end

end # module
