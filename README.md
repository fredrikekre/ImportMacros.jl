# ImportMacros.jl

| **Build Status**                                                                                |
|:----------------------------------------------------------------------------------------------- |
| [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url] [![][codecov-img]][codecov-url] |

Provides three macros: `@import` and `@using` which loads a module and binds it to an
alias, and `@from` which loads an object from a module and binds it to an alias.

## Usage

`@import` and `@using` macros are used in the same way, although the result is different.
For instance the module `MyLongModuleName` can be imported and bound to `m` with
the following line:

```julia
@import MyLongModuleName as alias
```

which is roughly equivalent to

```julia
baremodule $(gensym())
    import LongModuleName
end
const alias = $(gensym()).LongModuleName
```

A (shorter) alias can be useful if non-exported functions from modules are used frequently
in the code. For instance, compare the two different ways of calling the function `foo`
from the module `MyLongModuleName`:

```julia
alias.foo() # via the alias

MyLongModuleName.foo() # via the original module name
```

The syntax for `@using` is the same as for `@import`

```julia
@using MyLongModuleName as alias
```

but the result is roughly equivalent to

```julia
using LongModuleName
const alias = LongModuleName
```

The syntax for `@from` is as follows:

```julia
@from MyModule use my_long_variable_name as alias
```

and for macros:

```julia
@from MyModule use @my_long_macro_name as @m
```

Using the `@from` macro is roughly equivalent to

```julia
baremodule $(gensym())
    import Module
end
const alias = $(gensym()).Module.my_long_variable_name
```

## Installation

The package can be installed with Julia's package manager,
either from the Pkg REPL

```
pkg> add https://github.com/fredrikekre/ImportMacros.jl
```

or from the Julia REPL

```julia
julia> using Pkg; Pkg.add(PackageSpec(url = "https://github.com/fredrikekre/ImportMacros.jl"))
```

[travis-img]: https://travis-ci.org/fredrikekre/ImportMacros.jl.svg?branch=master
[travis-url]: https://travis-ci.org/fredrikekre/ImportMacros.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/ds4d6njhs1t69aak/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/fredrikekre/importmacros-jl/branch/master

[codecov-img]: https://codecov.io/gh/fredrikekre/ImportMacros.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/fredrikekre/ImportMacros.jl
