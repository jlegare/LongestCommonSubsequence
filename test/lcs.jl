@testset "Sanity/String" begin
    @test lcs("", "", ==) == ( [ ], [ ] )

    @test lcs("a", "", ==) == ( [ ( true, 1:1:1 ) ], [ ] )
    @test lcs("", "a", ==) == ( [ ], [ ( true, 1:1:1 ) ] )

    @test lcs("a", "a", ==) == ( [ ( false, 1:1:1 ) ], [ ( false, 1:1:1 ) ] )
    @test lcs("a", "b", ==) == ( [ ( true, 1:1:1 ) ], [ ( true, 1:1:1 ) ] )
end
