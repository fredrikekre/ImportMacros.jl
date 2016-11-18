using Imports
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

@testset "@Import" begin
    # A
    @test (@Import A as a) == nothing
    @Import A as a
    @test_throws UndefVarError foo()
    @test_throws UndefVarError Foo()
    @test a.foo()
    @test a.Foo()

    # A.B
    @test (@Import A.B as ab) == nothing
    @Import A.B as ab
    @test_throws UndefVarError bar()
    @test_throws UndefVarError Bar()
    @test ab.bar()
    @test ab.Bar()

    # A.B.C
    @test (@Import A.B.C as abc) == nothing
    @Import A.B.C as abc
    @test_throws UndefVarError baz()
    @test_throws UndefVarError Baz()
    @test abc.baz()
    @test abc.Baz()
end # testset

@testset "@Using" begin
    # A
    @test (@Using A as a) == nothing
    @Using A as a
    @test foo()
    @test_throws UndefVarError Foo()
    @test a.foo()
    @test a.Foo()

    # A.B
    @test (@Using A.B as ab) == nothing
    @Using A.B as ab
    @test bar()
    @test_throws UndefVarError Bar()
    @test ab.bar()
    @test ab.Bar()

    # A.B.C
    @test (@Using A.B.C as abc) == nothing
    @Using A.B.C as abc
    @test baz()
    @test_throws UndefVarError Baz()
    @test abc.baz()
    @test abc.Baz()
end # testset
