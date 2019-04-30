module ImportMacros

export @import, @using, @from


"""
    @import LongModuleName as alias

Load the module `LongModuleName` with `import` and binds it to `alias`.
Roughly equivalent to

```julia
baremodule \$(gensym())
    import LongModuleName
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

"""
    @from Module use object as alias
    @from Module use @object as @alias

Load the module `Module` with `import` and bind `object` to `alias`,
or `@object` to `@alias` in the case of macros.
Roughly equivalent to:

```julia
baremodule \$(gensym())
    import Module
end
const alias = \$(gensym()).Module.object
```
"""
:(@from)

# generate the macros
for macroname in ("import", "using")
    @eval begin
        macro $(Symbol(macroname))(M::Union{Symbol, Expr}, kw::Symbol, alias::Symbol)
            # input check
            if kw !== :as
                throw(ArgumentError("syntax error: expected `@$($macroname) Module as mod`"))
            end
            return create_expression(Symbol($macroname), M, alias)
        end
    end
end

macro from(M::Union{Symbol, Expr}, use::Symbol, object::Symbol, as::Symbol, alias::Symbol)
    if use !== :use && as !== :as
        throw(ArgumentError("syntax error: expected `@from Module use object as alias`"))
    end
    return create_expression(:import, M, alias, object)
end

macro from(M::Union{Expr, Symbol}, use::Symbol, expr::Expr)
    # expr is something like :(@f as @F)
    object = nothing
    alias = nothing
    if expr.head === :macrocall && expr.args[1] isa Symbol
        object = expr.args[1]
        if expr.args[2] isa LineNumberNode && expr.args[3] === :as &&
           expr.args[4] isa Expr && expr.args[4].head === :macrocall &&
           expr.args[4].args[1] isa Symbol
           alias = expr.args[4].args[1]
        end
    end
    if use !== :use && (object === nothing || alias === nothing)
        throw(ArgumentError("syntax error: expected `@from Module use @object as @alias`"))
    end
    return create_expression(:import, M, alias, object)
end

function create_expression(import_or_using::Symbol, M::Union{Symbol, Expr},
                           alias::Symbol, object=nothing)
    symbols = get_names(M)
    import_expr = Expr(import_or_using, Expr(:., symbols...))
    rhs_expr = Expr(:escape, object === nothing ? last(symbols) : Expr(:., last(symbols), QuoteNode(object)))
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
