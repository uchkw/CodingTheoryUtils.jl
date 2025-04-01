using Test
using GaloisFields
using CodingTheoryUtils

@testset "Field Conversion Functions" begin
    # Define F2 field
    F2 = GaloisField(2)
    
    # Test F2p with field element
    @testset "F2p with field element" begin
        # Create test fields
        F4, α = GaloisField(2, 2, :α)
        F8, β = GaloisField(2, 3, :β)
        
        # Test with zero vector
        @test F2p([F2(0), F2(0)], α) == zero(F4)
        
        # Test with one vector
        @test F2p([F2(1), F2(0)], α) == one(F4)
        
        # Test with primitive element
        @test F2p([F2(0), F2(1)], α) == α
        
        # Test with larger field
        @test F2p([F2(1), F2(0), F2(1)], β) == β^2 + one(F8)
    end
    
    # Test F2p with field type
    @testset "F2p with field type" begin
        # Create test fields
        F4, α = GaloisField(2, 2, :α)
        F8, β = GaloisField(2, 3, :β)
        
        # Test with zero vector
        @test F2p(F4, [F2(0), F2(0)]) == zero(F4)
        
        # Test with one vector
        @test F2p(F4, [F2(1), F2(0)]) == one(F4)
        
        # Test with primitive element
        @test F2p(F4, [F2(0), F2(1)]) == α
        
        # Test with larger field
        @test F2p(F8, [F2(1), F2(0), F2(1)]) == β^2 + one(F8)
    end
    
    # Test error cases
    @testset "Error cases" begin
        # Create test fields
        F4, α = GaloisField(2, 2, :α)
        
        # Test with wrong vector length
        @test_throws AssertionError F2p([F2(0)], α)
        @test_throws AssertionError F2p(F4, [F2(0)])
    end
end 