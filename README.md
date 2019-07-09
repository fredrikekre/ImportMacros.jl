# ImportMacros.jl

| **Build Status**                                                                                |
|:----------------------------------------------------------------------------------------------- |
| [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][codecov-img]][codecov-url] |

Provides two macros: `@import` and `@using` which loads a module or object and binds it to
an alias.

## Usage

`@import` can be used with modules, or specific objects inside modules, to create an alias,
and to hide the underlying module from the user code. For example

```julia
julia> using ImportMacros

julia> @import LinearAlgebra as LA

julia> LA.dot([1, 2], [3, 4])
11
```

creates an alias `LA` which is bound to the `LinearAlgebra` module. Note that the name
`LinearAlgebra` is hidden and only the alias name is introduced in the calling scope:

```julia
julia> LinearAlgebra
ERROR: UndefVarError: LinearAlgebra not defined
```

A (shorter) alias can be useful, for example, if non-exported functions from modules are
used frequently in the code. For instance, compare the two different ways of calling the
function `foo` from the module `MyLongModuleName`:

```julia
alias.foo() # via the alias

MyLongModuleName.foo() # via the original module name
```

An alias can also be useful in order to load a package with a name that conflicts with
your own code.

The syntax for `@using` is the same as for `@import`

```julia
@using MyLongModuleName as alias
```

but the result is roughly equivalent to

```julia
using LongModuleName
const alias = LongModuleName
```

## Installation

The package can be installed with Julia's package manager,
either from the Pkg REPL

```
pkg> add ImportMacros
```

or from the Julia REPL

```julia
julia> using Pkg; Pkg.add("ImportMacros")
```

[travis-img]: https://travis-ci.org/fredrikekre/ImportMacros.jl.svg?branch=master
[travis-url]: https://travis-ci.org/fredrikekre/ImportMacros.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/ds4d6njhs1t69aak/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/fredrikekre/importmacros-jl/branch/master

[codecov-img]: https://codecov.io/gh/fredrikekre/ImportMacros.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/fredrikekre/ImportMacros.jl
