using Test
using GaloisFields
using CodingTheoryUtils
# Define finite field types

@testset "Primitive Root Functions" begin
    F4, α = GaloisField(2, 2, :α)
    F8, β = GaloisField(2, 3, :β)
    F16, γ = GaloisField(2, 4, :γ)
    # Test primitive_root with field types
    @test primitive_root(F2) == F2(1)
    @test primitive_root(F4) == α
    @test primitive_root(F8) == β
    @test primitive_root(F16) == γ

    # Test is_primitive with field elements
    @test is_primitive(F2(1))
    @test is_primitive(α)
    @test is_primitive(β)
    @test is_primitive(γ)

    # Test non-primitive elements
    @test !is_primitive(F2(0))
    @test !is_primitive(F4(0))
    @test !is_primitive(F8(0))
    @test !is_primitive(F16(0))
end

