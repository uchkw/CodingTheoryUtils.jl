using Test
using GaloisFields
using CodingTheoryUtils

@testset "Binary Vector Operations" begin
    # Test bvec function with GaloisField element
    @testset "bvec with GaloisField element" begin
        # Create a test field
        F4, α = GaloisField(2, 2, :α)
        
        # Test bvec with zero element
        @test bvec(zero(F4)) == [F2(0), F2(0)]
        
        # Test bvec with one element
        @test bvec(one(F4)) == [F2(1), F2(0)]
        
        # Test bvec with primitive element
        @test bvec(α) == [F2(0), F2(1)]
    end

    # Test bvec function with integer
    @testset "bvec with integer" begin
        # Test with zero
        @test bvec(0) == [F2(0)]
        
        # Test with one
        @test bvec(1) == [F2(1)]
        
        # Test with larger number
        @test bvec(5) == [F2(1), F2(0), F2(1)]
        
        # Test with specified bit width
        @test bvec(5, 4) == [F2(1), F2(0), F2(1), F2(0)]
    end

    # Test bvec function with polynomial
    @testset "bvec with polynomial" begin
        # Create test polynomial
        p = Polynomial([F2(1), F2(0), F2(1)])
        
        # Test without specified bit width
        @test bvec(p) == [F2(1), F2(0), F2(1)]
        
        # Test with specified bit width
        @test bvec(p, 5) == [F2(1), F2(0), F2(1), F2(0), F2(0)]
    end

    # Test wt function
    @testset "wt (weight) function" begin
        # Test with zero vector
        @test wt([F2(0), F2(0), F2(0)]) == 0
        
        # Test with all ones
        @test wt([F2(1), F2(1), F2(1)]) == 3
        
        # Test with mixed values
        @test wt([F2(1), F2(0), F2(1), F2(0)]) == 2
    end
end 