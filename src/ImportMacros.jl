module ImportMacros

using MacroTools: @capture

export @import, @using, @from


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

"""
```julia
@from Module use object as alias
@from Module use @object as @alias
```

Load the module `Module` with `import` and bind `object` to `alias`,
or `@object` to `@alias` in the case of macros.

Equivalent to:

```julia
import Module
const alias = Module.object
@eval const \$(Symbol("@alias")) = Module.\$(Symbol("@object"))    # macros
```
"""
:(@from)

# generate the macros
for macroname in ("import", "using")
    @eval begin
        macro $(Symbol(macroname))(M::Union{Symbol, Expr}, kw::Symbol, m::Symbol)
            # input check
            kw == :as || throw(ArgumentError("syntax error: expected `as`, got `$kw`"))

            # create operator expression
            names = get_names(M)
            ex = Expr(:.)
            for n in names
                push!(ex.args, n)
            end
            ex = Expr(Symbol($macroname), ex)

            return quote
                $(esc(ex))
                global const $(esc(m)) = $(esc(M))
                nothing
            end
        end
    end
end

const FROM_USAGE = "`@from Module use object as alias`"
const FROM_USAGE_MACRO = "`@from Module use @object as @alias`"

from_error(usage) = throw(ArgumentError("syntax error: expected $usage"))

function _from(condition, usage, _module, object, alias)
    condition || from_error(usage)

    names = get_names(_module)
    ex = Expr(:.)
    for n in names
        push!(ex.args, n)
    end
    ex = Expr(:import, ex)

    return quote
        $(esc(ex))
        global const $(esc(alias)) = $(esc(_module)).$object
        nothing
    end
end

macro from(_module::Union{Symbol, Expr}, use::Symbol, object::Symbol, as::Symbol, alias::Symbol)
    condition = use == :use && as == :as
    _from(condition, FROM_USAGE, _module, object, alias)
end

macro from(_module::Union{Expr, Symbol}, use::Symbol, object_as_alias::Expr)
    condition = use == :use && @capture(object_as_alias, @object_ as @alias_)
    _from(condition, FROM_USAGE_MACRO, _module, object, alias)
end

macro from(exprs...)
    from_error("$FROM_USAGE or $FROM_USAGE_MACRO")
end

# utility function to extract names from expression
function get_names(x)
    isa(x, Symbol)   && return (x, )
    isa(x, QuoteNode) && return (x.value, )
    x.head == :quote && return (x.args[1], )
    x.head == :.     && return (get_names(x.args[1])..., get_names(x.args[2])...)
    throw(ArgumentError("invalid module name"))
end


end # module
