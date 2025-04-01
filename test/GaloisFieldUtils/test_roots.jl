using Test
using CodingTheoryUtils
using GaloisFields
using Polynomials

@testset "Root Finding Functions" begin
    # Set up finite fields for testing
    F2 = @GaloisField 2
    F4, α = GaloisField(2, 2, :α)
    F8, β = GaloisField(2, 3, :β)
    F16, γ = GaloisField(2, 4, :γ)

    @testset "get_roots" begin
        # Test root calculation in F4
        p1 = Polynomial([F4(1), F4(1), F4(1)])  # x^2 + x + 1
        roots = get_roots(p1)
        @test length(roots) == 2  # Should have 2 roots in F4
        @test all(x -> iszero(p1(x)), roots)  # Polynomial value should be 0 for all roots
        
        # Test root calculation in F8
        p2 = Polynomial([F8(1), F8(1), F8(1), F8(1)])  # x^3 + x^2 + x + 1
        
        # Debug F8 structure
        # println("Order of F8: ", field_size(F8))
        # println("Primitive root of F8: ", β)
        # println("All elements of F8:")
        # for i in 0:field_size(F8)-2
        #     x = β^i
        #     println("β^$i = $x, p2(x) = $(p2(x))")
        # end
        # println("Case 0: p2(0) = $(p2(zero(F8)))")
        
        roots = get_roots(p2)
        # println("Number of roots in F8: ", length(roots))
        # println("Found roots: ", roots)
        # println("Polynomial value at each root: ", [p2(x) for x in roots])
        @test length(roots) == 1  # Should have 1 root (1) in F8
        @test all(x -> iszero(p2(x)), roots)  # Polynomial value should be 0 for all roots
        @test roots[1] == one(F8)  # The root is 1
    end

    @testset "polynomial_from_roots" begin
        # Test polynomial generation in F4
        roots1 = [α, α^2]
        p1 = polynomial_from_roots(roots1)
        @test degree(p1) == 2
        @test all(x -> iszero(p1(x)), roots1)  # Polynomial value should be 0 for all roots
        
        # Test polynomial generation in F8
        roots2 = [β, β^2, β^4]
        p2 = polynomial_from_roots(roots2)
        @test degree(p2) == 3
        @test all(x -> iszero(p2(x)), roots2)  # Polynomial value should be 0 for all roots
    end

    @testset "Edge Cases" begin
        # Generate polynomial from empty set of roots
        @test polynomial_from_roots(Vector{F4}()) == Polynomial([one(F4)])
        
        # Generate polynomial from root 0
        @test polynomial_from_roots([zero(F4)]) == Polynomial([zero(F4), one(F4)])
        
        # Calculate roots of a constant polynomial
        p = Polynomial([one(F4)])
        @test isempty(get_roots(p))
    end
end 