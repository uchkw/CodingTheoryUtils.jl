using Test
using GaloisFields
using CodingTheoryUtils
using Polynomials

# Define F2 and a field GF(8) for testing
const GF8, α = GaloisField(2, 3, :α)

@testset "one_hot_vector" begin
    # Test with F2
    @test one_hot_vector(5, 3, F2(1)) == [F2(0), F2(0), F2(1), F2(0), F2(0)]
    @test one_hot_vector(3, 1, F2(1)) == [F2(1), F2(0), F2(0)]
    @test one_hot_vector(1, 1, F2(1)) == [F2(1)]
    @test one_hot_vector(4, 4, F2(1)) == [F2(0), F2(0), F2(0), F2(1)]
    # Test with GF8
    v = α^3
    @test one_hot_vector(4, 2, v) == [GF8(0), v, GF8(0), GF8(0)]
    # Test invalid position
    @test_throws BoundsError one_hot_vector(3, 4, F2(1))
    @test_throws BoundsError one_hot_vector(3, 0, F2(1))
end

@testset "num_terms" begin
    # Test with Polynomial{F2}
    p1 = Polynomial([F2(1), F2(1), F2(0), F2(1)]) # 1 + x + x^3
    @test num_terms(p1) == 3
    p2 = Polynomial([F2(0), F2(0), F2(1), F2(0), F2(1)]) # x^2 + x^4
    @test num_terms(p2) == 2
    p3 = Polynomial([F2(1)]) # 1
    @test num_terms(p3) == 1
    p4 = Polynomial(F2[]) # Zero polynomial
    @test num_terms(p4) == 0
    p5 = Polynomial([F2(0), F2(0), F2(0)]) # Zero polynomial
    @test num_terms(p5) == 0

    # Test with Polynomial{GF8}
    p6 = Polynomial([α^1, α^0, GF8(0), α^3]) # α + 1*x + α^3*x^3
    @test num_terms(p6) == 3
    p7 = Polynomial([GF8(0), GF8(0)]) # Zero polynomial
    @test num_terms(p7) == 0
end

@testset "log function" begin
    # GF(2^3) の例
    # α^i の対数が正しく返るか
    for i in 0:6
        @test log(α, α^i) == i
    end
    # 1の対数は0
    @test log(α, GF8(1)) == 0
    # 0の対数はInf
    @test log(α, GF8(0)) == Inf
    # α^i でない値（定義外）は何も返さない（現状はnothing）
    # 例: α^7 = 1 なので、α^7は0乗に等しい
    # 例: α^3 * α^4 = α^7 = 1
    # 例: α^2 + α^3 などは原始元の冪でない
    # ただし現状の実装ではforループ外は何も返さない
    # GF(2^2) でも同様にテスト
    F4, β = GaloisField(2, 2, :β)
    for i in 0:2
        @test log(β, β^i) == i
    end
    @test log(β, F4(1)) == 0
    @test log(β, F4(0)) == Inf
end 