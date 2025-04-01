using Test
using CodingTheoryUtils
using Polynomials

# Define F2 and a field GF(8) for testing
const GF8, α = GaloisField(2, 3, :α)

@testset "one_hot_vector" begin
    # Test with F2
    @test one_hot_vector(5, 3, F2(1)) == [F2(0), F2(0), F2(1), F2(0), F2(0)]
    @test one_hot_vector(3, 1, F2(1)) == [F2(1), F2(0), F2(0)]
    @test one_hot_vector(1, 1, F2(1)) == [F2(1)]
    @test one_hot_vector(4, 4, F2(1)) == [F2(0), F2(0), F2(0), F2(1)]
    # Test with GF8
    v = α^3
    @test one_hot_vector(4, 2, v) == [GF8(0), v, GF8(0), GF8(0)]
    # Test invalid position
    @test_throws BoundsError one_hot_vector(3, 4, F2(1))
    @test_throws BoundsError one_hot_vector(3, 0, F2(1))
end

@testset "num_terms" begin
    # Test with Polynomial{F2}
    p1 = Polynomial([F2(1), F2(1), F2(0), F2(1)]) # 1 + x + x^3
    @test num_terms(p1) == 3
    p2 = Polynomial([F2(0), F2(0), F2(1), F2(0), F2(1)]) # x^2 + x^4
    @test num_terms(p2) == 2
    p3 = Polynomial([F2(1)]) # 1
    @test num_terms(p3) == 1
    p4 = Polynomial(F2[]) # Zero polynomial
    @test num_terms(p4) == 0
    p5 = Polynomial([F2(0), F2(0), F2(0)]) # Zero polynomial
    @test num_terms(p5) == 0

    # Test with Polynomial{GF8}
    p6 = Polynomial([α^1, α^0, GF8(0), α^3]) # α + 1*x + α^3*x^3
    @test num_terms(p6) == 3
    p7 = Polynomial([GF8(0), GF8(0)]) # Zero polynomial
    @test num_terms(p7) == 0
end 