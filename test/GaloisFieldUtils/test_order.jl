using Test
using CodingTheoryUtils
using GaloisFields
using Polynomials

@testset "Order calculation" begin
    # Test order calculation for finite field elements
    F4, α = GaloisField(2, 2, :α)
    @test get_order(α) == 3  # Order of α is 3
    @test get_order(F4(1)) == 1  # Order of 1 is 1
    @test get_order(F4(0)) == -1  # Order of 0 is -1

    F8, β = GaloisField(2, 3, :β)
    @test get_order(β) == 7  # Order of β is 7
    @test get_order(F8(1)) == 1  # Order of 1 is 1
    @test get_order(F8(0)) == -1  # Order of 0 is -1

    # Test order calculation for polynomials
    F2 = @GaloisField 2
    p = Polynomial([F2(1), F2(1), F2(1)])  # x^2 + x + 1
    @test get_order(p) == 3  # Order of primitive polynomial is 2^2 - 1 = 3

    # Test alias
    @test order(α) == get_order(α)
    @test order(p) == get_order(p)
end 