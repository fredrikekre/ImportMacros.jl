# Imports.jl

[![Build Status][travis-img]][travis-url]
[![Build status][appveyor-img]][appveyor-url]

Provides two macros: `@Import` and `@Using` which loads a module and binds it to an alias.

## Usage

The two macros are used in the same way, although the result is different. For instance the
module `MyLongModuleName` can be imported and bound to `m` with the following line:

```jl
@Import MyLongModuleName as m
```

the result of running the `@Import`macro is the same as running

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

The syntax for `@Using` is the same, the difference being that the module is loaded with
`using` instead of `import`. This means that exported functions from the module
can be used directly, and non-exported function can be reached via the alias

```jl
@Using MyLongModuleName as m
```

The result of the `@Using` macro is the same as running

```jl
using MyLongModuleName
const m = MyLongModuleName
```

## Installation

The package can be installed by running

```jl
Pkg.clone("https://github.com/fredrikekre/Imports.jl")
```

in the Julia REPL. The package can be loaded automatically when Julia is started by adding

```jl
using Imports
```

to the `.juliarc.jl` file.

[travis-img]: https://travis-ci.org/fredrikekre/Imports.jl.svg?branch=master
[travis-url]: https://travis-ci.org/fredrikekre/Imports.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/ue16j31vjfnm2ask/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/fredrikekre/imports-jl/branch/master
