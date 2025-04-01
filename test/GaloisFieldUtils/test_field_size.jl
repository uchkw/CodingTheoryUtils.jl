using Test
using GaloisFields
using CodingTheoryUtils

@testset "Field Size Functions" begin
    F4, α = GaloisField(2, 2, :α)
    F8, β = GaloisField(2, 3, :β)
    F16, γ = GaloisField(2, 4, :γ)

    # Test field_size with field types
    @test field_size(F2) == 2
    @test field_size(F4) == 4
    @test field_size(F8) == 8
    @test field_size(F16) == 16

    # Test field_size with field elements
    @test field_size(F2(1)) == 2
    @test field_size(F4(1)) == 4
    @test field_size(F8(1)) == 8
    @test field_size(F16(1)) == 16

    # Test extension_degree with field types
    @test extension_degree(F2) == 1
    @test extension_degree(F4) == 2
    @test extension_degree(F8) == 3
    @test extension_degree(F16) == 4

    # Test exsize with field elements
    @test extension_degree(F2(1)) == 1
    @test extension_degree(F4(1)) == 2
    @test extension_degree(F8(1)) == 3
    @test extension_degree(F16(1)) == 4
end 