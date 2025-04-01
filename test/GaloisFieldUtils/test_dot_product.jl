using Test
using CodingTheoryUtils.GaloisFieldUtils

@testset "Vector dot product operations" begin
    # Test setup
    F4, α = GaloisField(2, 2, :α)
    F8, β = GaloisField(2, 3, :β)

    # Test basic dot product with F2 vectors
    @test begin
        v1 = [F2(1), F2(0), F2(1)]
        v2 = [F2(1), F2(1), F2(0)]
        v1 * v2 == F2(1)
    end

    # Test dot product with F4 vectors
    @test begin
        v1 = [F4(1), F4(0), F4(1)]
        v2 = [F2(1), F2(1), F2(0)]
        v1 * v2 == F4(1)
    end

    # Test dot product with F8 vectors
    @test begin
        v1 = [F8(1), F8(0), F8(1)]
        v2 = [F2(1), F2(1), F2(0)]
        v1 * v2 == F8(1)
    end

    # Test commutative property
    @test begin
        v1 = [F4(1), F4(0), F4(1)]
        v2 = [F2(1), F2(1), F2(0)]
        v1 * v2 == v2 * v1
    end

    # Test with zero vectors
    @test begin
        v1 = [F4(0), F4(0), F4(0)]
        v2 = [F2(1), F2(1), F2(1)]
        v1 * v2 == F4(0)
    end

    # Test with unit vectors
    @test begin
        v1 = [F4(1), F4(0), F4(0)]
        v2 = [F2(1), F2(0), F2(0)]
        v1 * v2 == F4(1)
    end

    # Test with different field elements
    @test begin
        v1 = [α, F4(0), α^2]
        v2 = [F2(1), F2(1), F2(0)]
        v1 * v2 == α
    end

    # Test error handling for mismatched lengths
    @test_throws AssertionError begin
        v1 = [F4(1), F4(0)]
        v2 = [F2(1), F2(1), F2(0)]
        v1 * v2
    end
end 