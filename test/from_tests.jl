# A
@test (@from A use Foo as f) == nothing
@from A use foo as f
@from A use Foo as F
@from A use @foo as @f
@from A use @Foo as @F
@test_throws UndefVarError foo()
@test_throws UndefVarError Foo()
@test_throws UndefVarError @eval $(Symbol("@foo"))
@test_throws UndefVarError @eval $(Symbol("@Foo"))
@test f()
@test F()
@test (@f 1) == 1
@test @F

# A.B
@test (@from A.B use Bar as b) == nothing
@from A.B use bar as b
@from A.B use Bar as Br
@from A.B use @bar as @b
@test_throws UndefVarError bar()
@test_throws UndefVarError Bar()
@test_throws UndefVarError @eval $(Symbol("@bar"))
@test b()
@test Br()
@test (@b 1 2) == (1, 2)

# A.B.C
@test (@from A.B.C use Baz as bz) == nothing
@from A.B.C use baz as bz
@from A.B.C use Baz as Bz
@from A.B.C use @baz as @bz
@test_throws UndefVarError baz()
@test_throws UndefVarError Baz()
@test_throws UndefVarError @eval $(Symbol("@baz"))
@test bz()
@test Bz()
@test (@bz 1 2 3) == (1, 2, 3)
