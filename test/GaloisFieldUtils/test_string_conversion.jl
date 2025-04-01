using Test
using CodingTheoryUtils
using CodingTheoryUtils.GaloisFieldUtils # Access internal functions if needed
using Polynomials

# Use the F2 defined in CodingTheoryUtils
# Define a field GF(8) for testing
const GF8, α = GaloisField(2, 3, :α) # Example GF(8)

@testset "extract_degrees" begin
    @test extract_degrees("x^3 + x + 1") == [3, 1, 0]
    @test extract_degrees("x^5") == [5]
    @test extract_degrees("1") == [0]
    @test extract_degrees("x^10 + x^5 + x^2 + 1") == [10, 5, 2, 0]
    @test extract_degrees("x") == [1]
    @test isempty(extract_degrees("")) # Empty string
    @test isempty(extract_degrees("   ")) # Whitespace only
    # TODO: Add tests for edge cases like unexpected characters if needed
end

@testset "string2coefvec" begin
    @test string2coefvec("x^3 + x + 1") == [1, 1, 0, 1]
    @test string2coefvec("x^5") == [0, 0, 0, 0, 0, 1]
    @test string2coefvec("1") == [1]
    @test string2coefvec("x^2 + 1") == [1, 0, 1]
    @test string2coefvec("x") == [0, 1]
    @test string2coefvec("") == Int[]
    @test string2coefvec("   ") == Int[]
end

@testset "string2F2poly" begin
    p1 = Polynomial([F2(1), F2(1), F2(0), F2(1)])
    @test string2F2poly("x^3 + x + 1") == p1

    p2 = Polynomial([F2(0), F2(0), F2(0), F2(0), F2(0), F2(1)])
    @test string2F2poly("x^5") == p2

    p3 = Polynomial([F2(1)])
    @test string2F2poly("1") == p3

    p4 = Polynomial([F2(1), F2(0), F2(1)])
    @test string2F2poly("x^2 + 1") == p4

    p5 = Polynomial([F2(0), F2(1)])
    @test string2F2poly("x") == p5

    p6 = Polynomial(F2[])
    @test string2F2poly("") == p6 # Empty polynomial for empty string
    @test string2F2poly("   ") == p6 # Empty polynomial for whitespace
end 