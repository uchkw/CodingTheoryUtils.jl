using Test
using CodingTheoryUtils.GaloisFieldUtils
using GaloisFields
using Polynomials

@testset "Minimal Polynomial Functions" begin
    # Set up finite fields for testing
    F2 = @GaloisField 2
    F4, α = GaloisField(2, 2, :α)
    F8, β = GaloisField(2, 3, :β)
    F16, γ = GaloisField(2, 4, :γ)

    @testset "get_conjugates" begin
        # Test conjugates of the primitive root of F4
        conjugates = get_conjugates(α)
        @test length(conjugates) == 2  # There are 2 conjugates in F4
        @test all(x -> x in conjugates, [α, α^2])
        
        # Test conjugates of the primitive root of F8
        conjugates = get_conjugates(β)
        @test length(conjugates) == 3  # There are 3 conjugates in F8
        @test all(x -> x in conjugates, [β, β^2, β^4])
    end

    @testset "get_minimum_polynomial" begin
        # Test minimal polynomial of the primitive root of F4
        minpoly = get_minimum_polynomial(α)
        @test degree(minpoly) == 2  # Minimal polynomial of primitive root of F4 is degree 2
        @test iszero(minpoly(α))  # α is a root
        @test iszero(minpoly(α^2))  # α^2 is also a root
        
        # Test minimal polynomial of the primitive root of F8
        minpoly = get_minimum_polynomial(β)
        @test degree(minpoly) == 3  # Minimal polynomial of primitive root of F8 is degree 3
        @test iszero(minpoly(β))  # β is a root
        @test iszero(minpoly(β^2))  # β^2 is also a root
        @test iszero(minpoly(β^4))  # β^4 is also a root
    end

    @testset "Edge Cases" begin
        # Minimal polynomial of 0
        @test_throws ArgumentError get_minimum_polynomial(zero(F4))
        
        # Minimal polynomial of 1
        minpoly = get_minimum_polynomial(one(F4))
        @test degree(minpoly) == 1
        @test iszero(minpoly(one(F4)))
    end
end 