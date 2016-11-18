# Imports.jl

[![Build Status][travis-img]][travis-url]
[![Build status][appveyor-img]][appveyor-url]

Provides two macros: `@Import` and `@Using` which loads a module and binds it to an alias.

## Usage

The two macros are used similarly. For instance the module `MyLongModuleName` can be imported
and bound to `m` with the following code:

```jl
@Import MyLongModuleName as m
```

which is just a simpler way of writing

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

The `@Using` macro is used in the same way, the only difference being that the module is
loaded with `using` instead of `import`. This means that exported functions from the module
can be used directly, and non-exported function can be reached via the alias

```jl
@Using MyLongModuleName as m
```


```jl
using MyLongModuleName
const m = MyLongModuleName
```

## Installation

The packages can be installed by running

```jl
Pkg.clone("https://github.com/fredrikekre/Imports.jl")
```

in the Julia REPL.

[travis-img]: https://travis-ci.org/fredrikekre/Imports.jl.svg?branch=master
[travis-url]: https://travis-ci.org/fredrikekre/Imports.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/ue16j31vjfnm2ask/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/fredrikekre/imports-jl/branch/master
