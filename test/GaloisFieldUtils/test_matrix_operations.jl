using Test
using CodingTheoryUtils

@testset "Matrix Operations" begin
    # Test case 1: Simple 2x2 matrix
    F4, α = GaloisField(2, 2, :α)
    M1 = [F4(1) F4(0); F4(0) F4(1)]
    expected1 = [1 0; 0 1]
    @test from_f2mat_to_intmat(M1) == expected1

    # Test case 2: 3x3 matrix with mixed values
    F8, β = GaloisField(2, 3, :β)
    M2 = [F8(1) F8(0) F8(1); F8(0) F8(1) F8(0); F8(1) F8(0) F8(1)]
    expected2 = [1 0 1; 0 1 0; 1 0 1]
    @test from_f2mat_to_intmat(M2) == expected2

    # Test case 3: 1x4 matrix (vector)
    M3 = reshape([F4(1), F4(0), F4(1), F4(0)], 1, 4)
    expected3 = reshape([1, 0, 1, 0], 1, 4)
    @test from_f2mat_to_intmat(M3) == expected3

    # Test case 4: 4x1 matrix (vector)
    M4 = reshape([F4(1), F4(0), F4(1), F4(0)], 4, 1)
    expected4 = reshape([1, 0, 1, 0], 4, 1)
    @test from_f2mat_to_intmat(M4) == expected4

    # Test case 5: Zero matrix
    M5 = zeros(F4, 2, 2)
    expected5 = zeros(Int, 2, 2)
    @test from_f2mat_to_intmat(M5) == expected5

    # Test case 6: All ones matrix
    M6 = ones(F4, 2, 2)
    expected6 = ones(Int, 2, 2)
    @test from_f2mat_to_intmat(M6) == expected6

    # Test case 7: Larger matrix (4x4)
    M7 = [F4(1) F4(0) F4(1) F4(0);
          F4(0) F4(1) F4(0) F4(1);
          F4(1) F4(0) F4(1) F4(0);
          F4(0) F4(1) F4(0) F4(1)]
    expected7 = [1 0 1 0;
                 0 1 0 1;
                 1 0 1 0;
                 0 1 0 1]
    @test from_f2mat_to_intmat(M7) == expected7
end 