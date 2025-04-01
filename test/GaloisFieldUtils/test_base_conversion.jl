using Test
using CodingTheoryUtils.GaloisFieldUtils
using GaloisFields
using Polynomials

@testset "Base Conversion Functions" begin
    # Define F2 locally for this test set
    F2 = @GaloisField 2

    # Test de2bi
    @testset "de2bi" begin
        @test de2bi(5) == [1, 0, 1]
        @test de2bi(5, width=4) == [1, 0, 1, 0]
        @test de2bi(0) == [0]
        @test de2bi(1) == [1]
        @test de2bi(UInt(5)) == [1, 0, 1]
        @test de2bi(UInt8(5)) == [1, 0, 1]
        @test de2bi(UInt16(5)) == [1, 0, 1]
    end

    # Test bi2de
    @testset "bi2de" begin
        @test bi2de([1, 0, 1]) == 5
        @test bi2de([0, 1, 0, 1]) == 10
        @test bi2de([0]) == 0
        @test bi2de([1]) == 1
        @test bi2de([1, 1, 1, 1]) == 15
    end

    # Test de2f2
    @testset "de2f2" begin
        @test de2f2(5) == [F2(1), F2(0), F2(1)]
        @test de2f2(5, width=4) == [F2(1), F2(0), F2(1), F2(0)]
        @test de2f2(0) == [F2(0)]
        @test de2f2(1) == [F2(1)]
    end

    # Test de2f2poly
    @testset "de2f2poly" begin
        @test de2f2poly(5) == Polynomial([F2(1), F2(0), F2(1)])
        @test de2f2poly(5, width=4) == Polynomial([F2(1), F2(0), F2(1), F2(0)])
        @test de2f2poly(0) == Polynomial([F2(0)])
        @test de2f2poly(1) == Polynomial([F2(1)])
    end
end 