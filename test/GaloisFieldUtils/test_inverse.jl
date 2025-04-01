using Test
using GaloisFields
using LinearAlgebra
using CodingTheoryUtils

@testset "Matrix Inverse Tests" begin
    # Call directly due to name resolution issues
    test_inv(M) = Base.inv(M)

    # Test case 1: Regular matrix in GF(4)
    F4, α = GaloisField(2, 2, :α)
    M1 = [α 1; 1 α]
    M1_inv = test_inv(M1)
    @test M1_inv * M1 == Matrix{F4}(I, 2, 2)
    @test M1 * M1_inv == Matrix{F4}(I, 2, 2)

    # Test case 2: Identity matrix in GF(4)
    I2 = Matrix{F4}(I, 2, 2)
    I2_inv = test_inv(I2)
    @test I2_inv == I2

    # Test case 3: Singular matrix in GF(4)
    M2 = [F4(1) F4(1); F4(1) F4(1)]
    M2_inv = test_inv(M2)
    @test M2_inv === nothing

    # Test case 4: Zero matrix in GF(4)
    M3 = zeros(F4, 2, 2)
    M3_inv = test_inv(M3)
    @test M3_inv === nothing

    # Test case 5: Regular matrix in GF(8)
    F8, β = GaloisField(2, 3, :β)
    M4 = [β 1; 1 β]
    M4_inv = test_inv(M4)
    @test M4_inv * M4 == Matrix{F8}(I, 2, 2)
    @test M4 * M4_inv == Matrix{F8}(I, 2, 2)

    # Test case 6: 3x3 matrix in GF(4)
    M5 = [α F4(1) F4(0); F4(1) α F4(1); F4(0) F4(1) α]
    M5_inv = test_inv(M5)
    @test M5_inv * M5 == Matrix{F4}(I, 3, 3)
    @test M5 * M5_inv == Matrix{F4}(I, 3, 3)
end 