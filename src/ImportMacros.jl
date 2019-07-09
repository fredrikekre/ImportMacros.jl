module ImportMacros

export @import, @using


"""
    @import LongModuleName as alias
    @import LongModuleName.object as alias

Load the module `LongModuleName` with `import` and binds it to `alias`.
Can also be used for specific objects inside the module.
The resulting expression is roughly equivalent to

```julia
baremodule \$(gensym())
    import LongModuleName.object
end
const alias = \$(gensym()).LongModuleName
```
"""
:(@import)

"""
    @using LongModuleName as alias

Load the module `LongModuleName` with `using` and binds it to `alias`.
Roughly equivalent to

```julia
using LongModuleName
const alias = LongModuleName
```
"""
:(@using)

# generate the macros
@eval begin
    # @import version for symbols, e.g. @import A.foo as f
    macro $(Symbol("import"))(M::Union{Symbol, Expr}, kw::Symbol, alias::Symbol)
        # input check
        if kw !== :as
            throw(ArgumentError("syntax error: expected `@import A.B.object as alias`"))
        end
        return create_expression(:import, M, alias)
    end
    # @import version for macros, e.g. @import A.@foo as @f
    macro $(Symbol("import"))(expr::Expr)
        M = nothing
        alias = nothing
        if expr.head === :macrocall && expr.args[1] isa Expr &&
           expr.args[2] isa LineNumberNode && expr.args[3] === :as &&
           expr.args[4] isa Expr && expr.args[4].head === :macrocall &&
           expr.args[4].args[1] isa Symbol
           M = expr.args[1]
           alias = expr.args[4].args[1]
        end
        if M === nothing || alias === nothing
            throw(ArgumentError("syntax error: expected `@import A.@object as @alias`"))
        end
        return create_expression(:import, M, alias)
    end
    # @using version
    macro $(Symbol("using"))(M::Union{Symbol, Expr}, kw::Symbol, alias::Symbol)
        # input check
        if kw !== :as
            throw(ArgumentError("syntax error: expected `@using A.B as alias`"))
        end
        return create_expression(:using, M, alias)
    end
end

function create_expression(import_or_using::Symbol, M::Union{Symbol, Expr},
                           alias::Symbol)
    symbols = get_names(M)
    import_expr = Expr(import_or_using, Expr(:., symbols...))
    rhs_expr = Expr(:escape, last(symbols))
    if import_or_using === :import # hide M behind a gensym baremodule
        s = gensym()
        import_expr = Expr(:module, false, Expr(:escape, s), Expr(:block, import_expr))
        if rhs_expr.args[1] isa Symbol
            rhs_expr.args[1] = Expr(:., s, QuoteNode(rhs_expr.args[1]))
        else # esc expr
            rhs_expr.args[1] = Expr(:., Expr(:., s, QuoteNode(rhs_expr.args[1].args[1])), rhs_expr.args[1].args[2])
        end
    end
    const_expr = Expr(:const, Expr(:global, Expr(:(=), alias, rhs_expr)))
    return_expr = Expr(:toplevel, import_expr, const_expr, nothing)
    return return_expr
end

# utility function to extract names from expression
function get_names(x)
    isa(x, Symbol)    && return (x, )
    isa(x, QuoteNode) && return (x.value, )
    x.head === :quote && return (x.args[1], )
    x.head === :.     && return (get_names(x.args[1])..., get_names(x.args[2])...)
    throw(ArgumentError("invalid module name"))
end


end # module
