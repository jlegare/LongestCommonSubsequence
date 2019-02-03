using LongestCommonSubsequence
using Test

tests = [ "lcs", ]

for test ∈ tests
    include("$test.jl")
end

