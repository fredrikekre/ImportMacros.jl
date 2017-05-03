# ImportMacros.jl

[![Build Status][travis-img]][travis-url]
[![Build status][appveyor-img]][appveyor-url]

Provides three macros: `@import` and `@using` which loads a module and binds it to an alias, and
`@from` which loads an object from a module and binds it to an alias.

## Usage

`@import` and `@using` macros are used in the same way, although the result is different. For instance the
module `MyLongModuleName` can be imported and bound to `m` with the following line:

```jl
@import MyLongModuleName as m
```

the result of running the `@import`macro is the same as running

```jl
import MyLongModuleName
const m = MyLongModuleName
```

A (shorter) alias can be useful if non-exported functions from modules are used frequently
in the code. For instance, compare the two different ways of calling the function `foo`
from the module `MyLongModuleName`:

```jl
m.foo() # via the alias

MyLongModuleName.foo() # via the original module name
```

The syntax for `@using` is the same as for `@import`, the difference being that the module is loaded with
`using` instead of `import`. This means that exported functions from the module
can be used directly, and non-exported function can be reached via the alias.

The syntax for `@from` is as follows:

```jl
@from MyModule use my_long_variable_name as v
```

In order to alias a macro use `@` before the macro name:

```jl
@from MyModule use @my_long_macro_name as @m
```

## Installation

The package can be installed by running

```jl
Pkg.clone("https://github.com/fredrikekre/ImportMacros.jl")
```

in the Julia REPL. The package can be loaded automatically when Julia is started by adding

```jl
using ImportMacros
```

to the `.juliarc.jl` file.

[travis-img]: https://travis-ci.org/fredrikekre/ImportMacros.jl.svg?branch=master
[travis-url]: https://travis-ci.org/fredrikekre/ImportMacros.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/ds4d6njhs1t69aak/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/fredrikekre/importmacros-jl/branch/master
