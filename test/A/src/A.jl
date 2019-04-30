module A
    export foo
    foo() = true
    Foo() = true
    macro foo(x) x end
    macro Foo() true end
    module B
        export bar
        bar() = true
        Bar() = true
        macro bar(x, y) x, y end
        module C
            export baz
            baz() = true
            Baz() = true
            macro baz(x, y, z) x, y, z end
        end
    end
end
