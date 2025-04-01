using Test
using CodingTheoryUtils
using GaloisFields
using Polynomials

@testset "Companion Matrix Functions" begin
    # Test generating companion matrix from polynomial coefficient vector
    F2 = @GaloisField 2
    g = [F2(1), F2(1)]  # Coefficients of x^2 + x + 1
    A = make_companion_matrix(g)
    @test size(A) == (2, 2)
    @test A[1, 2] == F2(1)
    @test A[2, 2] == F2(1)
    @test A[2, 1] == F2(1)
    @test A[1, 1] == F2(0)

    # Test generating companion matrix from finite field element
    F4, α = GaloisField(2, 2, :α)
    B = make_companion_matrix(α)
    @test size(B) == (2, 2)
    @test B[1, 1] == F2(0)
    @test B[1, 2] == F2(1)
    @test B[2, 1] == F2(1)
    @test B[2, 2] == F2(1)

    # Test generating companion matrix from finite field element and basis element
    C = make_companion_matrix(α, α)
    @test size(C) == (2, 2)
    @test C[1, 1] == F2(0)
    @test C[1, 2] == F2(1)
    @test C[2, 1] == F2(1)
    @test C[2, 2] == F2(1)

    # Test edge cases
    # Coefficient vector of a 1st degree polynomial
    g1 = [F2(1)]
    A1 = make_companion_matrix(g1)
    @test size(A1) == (1, 1)
    @test A1[1, 1] == F2(1)

    # Coefficient vector of a 3rd degree polynomial
    g3 = [F2(1), F2(1), F2(1)]
    A3 = make_companion_matrix(g3)
    @test size(A3) == (3, 3)
    @test A3[1, 3] == F2(1)
    @test A3[2, 3] == F2(1)
    @test A3[3, 3] == F2(1)
    @test A3[2, 1] == F2(1)
    @test A3[3, 2] == F2(1)
end 