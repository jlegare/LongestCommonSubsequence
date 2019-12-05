@testset "Sanity/String" begin
    @test lcs("", "", ==) == ( [ ], [ ] )

    @test lcs("a", "", ==) == ( [ ( true, 1:1:1 ) ], [ ] )
    @test lcs("", "a", ==) == ( [ ], [ ( true, 1:1:1 ) ] )

    @test lcs("ab", "", ==) == ( [ ( true, 1:1:2 ) ], [ ] )
    @test lcs("abc", "", ==) == ( [ ( true, 1:1:3 ) ], [ ] )

    @test lcs("a", "a", ==) == ( [ ( false, 1:1:1 ) ], [ ( false, 1:1:1 ) ] )
    @test lcs("a", "b", ==) == ( [ ( true, 1:1:1 ) ], [ ( true, 1:1:1 ) ] )

    @test lcs("a", "ab", ==) == ( [ ( false, 1:1:1 ) ], [ ( false, 1:1:1 ), ( true, 2:1:2 ) ] )
    @test lcs("a", "bb", ==) == ( [ ( true, 1:1:1 ) ], [ ( true, 1:1:2 ) ] )

    @test lcs("ab", "bb", ==) == ( [ ( true, 1:1:1 ), ( false, 2:1:2 ) ], [ ( true, 1:1:1 ), ( false, 2:1:2 ) ] )

    @test lcs("abc", "bbc", ==) == ( [ ( true, 1:1:1 ), ( false, 2:1:3 ) ], [ ( true, 1:1:1 ), ( false, 2:1:3 ) ] )
    @test lcs("abc", "abb", ==) == ( [ ( false, 1:1:2 ), ( true, 3:1:3 ) ], [ ( false, 1:1:2 ), ( true, 3:1:3 ) ] )
end
