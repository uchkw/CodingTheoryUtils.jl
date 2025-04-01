using Test
using GaloisFields
using CodingTheoryUtils

@testset "Trace Functions" begin
    # Define test fields
    F2 = GaloisField(2)
    F4, α = GaloisField(2, 2, :α)
    F8, β = GaloisField(2, 3, :β)
    
    # Test trace function
    @testset "trace" begin
        # Test with zero element
        @test trace(zero(F4)) == zero(F2)
        
        # Test with one element
        @test trace(one(F4)) == zero(F2)
        
        # Test with primitive element
        @test trace(α) == one(F2)
        
        # Test with larger field
        @test trace(zero(F8)) == zero(F2)
        @test trace(one(F8)) == one(F2)
        @test trace(β) == zero(F2)
        
        # Test with non-zero, non-one elements
        @test trace(α + one(F4)) == trace(α) + trace(one(F4))
        @test trace(β^2 + β) == trace(β^2) + trace(β)
    end
    
    # Test get_tr_one_elem function
    @testset "get_tr_one_elem" begin
        # Test with F4
        tr_one = get_tr_one_elem(α)
        @test !isnothing(tr_one)
        @test isone(trace(tr_one))
        
        # Test with F8
        tr_one = get_tr_one_elem(β)
        @test !isnothing(tr_one)
        @test isone(trace(tr_one))
        
        # Test with zero element
        @test_throws AssertionError get_tr_one_elem(zero(F4))
    end
end 