using ImportMacros
using Base.Test

module A
    export foo
    foo() = true
    Foo() = true
    module B
        export bar
        bar() = true
        Bar() = true
        module C
            export baz
            baz() = true
            Baz() = true
        end
    end
end

@testset "@import" begin
    # A
    @test (@import A as a) == nothing
    @import A as a
    @test_throws UndefVarError foo()
    @test_throws UndefVarError Foo()
    @test a.foo()
    @test a.Foo()

    # A.B
    @test (@import A.B as ab) == nothing
    @import A.B as ab
    @test_throws UndefVarError bar()
    @test_throws UndefVarError Bar()
    @test ab.bar()
    @test ab.Bar()

    # A.B.C
    @test (@import A.B.C as abc) == nothing
    @import A.B.C as abc
    @test_throws UndefVarError baz()
    @test_throws UndefVarError Baz()
    @test abc.baz()
    @test abc.Baz()
end # testset

@testset "@using" begin
    # A
    @test (@using A as a) == nothing
    @using A as a
    @test foo()
    @test_throws UndefVarError Foo()
    @test a.foo()
    @test a.Foo()

    # A.B
    @test (@using A.B as ab) == nothing
    @using A.B as ab
    @test bar()
    @test_throws UndefVarError Bar()
    @test ab.bar()
    @test ab.Bar()

    # A.B.C
    @test (@using A.B.C as abc) == nothing
    @using A.B.C as abc
    @test baz()
    @test_throws UndefVarError Baz()
    @test abc.baz()
    @test abc.Baz()
end # testset
