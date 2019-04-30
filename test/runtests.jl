using ImportMacros, Test, Pkg

# Add the test-package
Pkg.develop(PackageSpec(path = joinpath(@__DIR__, "A")))

@testset "@import" begin
    # A.B.C
    @test (@import A.B.C as abc) == nothing
    @import A.B.C as abc
    @test_throws UndefVarError baz()
    @test_throws UndefVarError C.baz()
    @test_throws UndefVarError Baz()
    @test_throws UndefVarError C.Baz()
    @test abc.baz()
    @test abc.Baz()

    # A.B
    @test (@import A.B as ab) == nothing
    @import A.B as ab
    @test_throws UndefVarError bar()
    @test_throws UndefVarError B.bar()
    @test_throws UndefVarError Bar()
    @test_throws UndefVarError B.Bar()
    @test ab.bar()
    @test ab.Bar()

    # A
    @test (@import A as a) == nothing
    @import A as a
    @test_throws UndefVarError foo()
    @test_throws UndefVarError A.foo()
    @test_throws UndefVarError Foo()
    @test_throws UndefVarError A.Foo()
    @test a.foo()
    @test a.Foo()
end # testset

@testset "@from" begin
    # A.B.C
    @test (@from A.B.C use baz as bz) == nothing
    @from A.B.C use baz as bz
    @from A.B.C use Baz as Bz
    @from A.B.C use @baz as @bz
    @test_throws UndefVarError baz()
    @test_throws UndefVarError C.baz()
    @test_throws UndefVarError Baz()
    @test_throws UndefVarError C.Baz()
    @test_throws UndefVarError @eval $(Symbol("@baz"))
    @test_throws UndefVarError @eval C.$(Symbol("@baz"))
    @test bz()
    @test Bz()
    @test @eval (@bz 1 2 3) == (1, 2, 3)

    # A.B
    @test (@from A.B use bar as b) == nothing
    @from A.B use bar as b
    @from A.B use Bar as Br
    @from A.B use @bar as @b
    @test_throws UndefVarError bar()
    @test_throws UndefVarError B.bar()
    @test_throws UndefVarError Bar()
    @test_throws UndefVarError B.Bar()
    @test_throws UndefVarError @eval $(Symbol("@bar"))
    @test_throws UndefVarError @eval B.$(Symbol("@bar"))
    @test b()
    @test Br()
    @test @eval (@b 1 2) == (1, 2)

    # A
    @test (@from A use foo as f) == nothing
    @from A use foo as f
    @from A use Foo as F
    @from A use @foo as @f
    @from A use @Foo as @F
    @test_throws UndefVarError foo()
    @test_throws UndefVarError A.foo()
    @test_throws UndefVarError Foo()
    @test_throws UndefVarError A.Foo()
    @test_throws UndefVarError @eval $(Symbol("@foo"))
    @test_throws UndefVarError @eval A.$(Symbol("@foo"))
    @test_throws UndefVarError @eval $(Symbol("@Foo"))
    @test_throws UndefVarError @eval A.$(Symbol("@Foo"))
    @test f()
    @test F()
    @test @eval (@f 1) == 1
    @test @eval @F
end

@testset "@using" begin
    # A.B.C
    @test (@using A.B.C as abc) == nothing
    @using A.B.C as abc
    @test baz()
    @test C.baz()
    @test_throws UndefVarError Baz()
    @test C.Baz()
    @test abc.baz()
    @test abc.Baz()

    # A.B
    @test (@using A.B as ab) == nothing
    @using A.B as ab
    @test bar()
    @test B.bar()
    @test_throws UndefVarError Bar()
    @test B.Bar()
    @test ab.bar()
    @test ab.Bar()

    # A
    @test (@using A as a) == nothing
    @using A as a
    @test foo()
    @test A.foo()
    @test_throws UndefVarError Foo()
    @test A.Foo()
    @test a.foo()
    @test a.Foo()
end # testset
