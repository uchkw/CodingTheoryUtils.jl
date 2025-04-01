using Test
using CodingTheoryUtils

@testset "Display Functions" begin
    # Simple test case
    v1 = [F2(1), F2(0), F2(1), F2(0)] # 1010
    @test hex(v1) == "a"

    # Test with length less than word size
    v2 = [F2(1), F2(1), F2(1), F2(1), F2(0), F2(0), F2(0), F2(0)] # 11110000
    @test hex(v2) == "f0"

    # Test with length equal to word size
    v3 = [F2(1), F2(0), F2(1), F2(0), F2(1), F2(0), F2(1), F2(0)] # 10101010
    @test hex(v3) == "aa"

    # Test with length greater than word size
    v4 = [F2(1), F2(0), F2(1), F2(0), F2(1), F2(0), F2(1), F2(0), F2(1), F2(0), F2(1), F2(0), F2(1), F2(0), F2(1), F2(0)] # 1010... x 2
    @test hex(v4) == "aaaa"

    # Test with a single bit
    v5 = [F2(1)]
    @test hex(v5) == "1"

    # Test with all zeros
    v6 = [F2(0), F2(0), F2(0), F2(0)]
    @test hex(v6) == "0"

    # Test with all ones
    v7 = [F2(1), F2(1), F2(1), F2(1), F2(1), F2(1), F2(1), F2(1)]
    @test hex(v7) == "ff"

    # Test with non-multiple of 4 length
    v8 = [F2(0), F2(0), F2(1), F2(0), F2(1)] # 00101 -> 0101 = 5
    @test hex(v8) == "05"

    v9 = [F2(1), F2(0), F2(1), F2(0), F2(1), F2(0), F2(1)] # 1010101 -> 01010101 = 55
    @test hex(v9) == "55"
end

@testset "gf_pretty Functions" begin
    F4, α = GaloisField(4, :α)
    F8, β = GaloisField(8, :β)

    # Test for single elements
    @test gf_pretty(α, α) == "α^1"
    @test gf_pretty(α^2, α) == "α^2"
    @test gf_pretty(F4(1), α) == "α^0"
    @test gf_pretty(β^5, β) == "β^5"
    # @test gf_pretty(F4(0), α) == "0" # Decide how to handle zero

    # Test for vectors of elements
    v_f4 = [α, α^2, F4(1)]
    @test gf_pretty(v_f4, α) == ["α^1", "α^2", "α^0"]

    # Test for F2 vectors (polynomial representation)
    v_f2_1 = [F2(1), F2(0), F2(1)] # 1 + x^2
    @test gf_pretty(v_f2_1) == "1 + x^2"
    v_f2_2 = [F2(1)] # 1
    @test gf_pretty(v_f2_2) == "1"
    v_f2_3 = [F2(0), F2(1)] # x
    @test gf_pretty(v_f2_3) == "x"
    v_f2_4 = [F2(1), F2(1), F2(0), F2(1)] # 1 + x + x^3
    @test gf_pretty(v_f2_4) == "1 + x + x^3"
    v_f2_5 = F2[] # Empty
    @test gf_pretty(v_f2_5) == "0"
    v_f2_6 = [F2(0), F2(0), F2(0)] # Zero polynomial
     @test gf_pretty(v_f2_6) == "0"
end 