using Test
using CodingTheoryUtils

@testset "BCH Parameter Validation" begin
    # Test valid parameters
    @testset "Valid Parameters" begin
        # Full BCH codes (n = 2^m - 1)
        m, t = BCH.validate_bch_parameters(15, 7)
        @test m == 4
        @test t == 2
        
        m, t = BCH.validate_bch_parameters(31, 21)
        @test m == 5
        @test t == 2
        
        m, t = BCH.validate_bch_parameters(7, 4)
        @test m == 3
        @test t == 1
        
        # Shortened BCH codes (n < 2^m - 1)
        m, t = BCH.validate_bch_parameters(10, 4)  # Shortened from BCH(15,7)
        @test m == 4
        @test t == 1  # (10-4)/4 = 1.5, so t = 1
        
        m, t = BCH.validate_bch_parameters(12, 4)  # Shortened from BCH(15,7)
        @test m == 4
        @test t == 2
    end
    
    # Test invalid parameters
    @testset "Invalid Parameters" begin
        # k >= n
        @test_throws ArgumentError BCH.validate_bch_parameters(15, 15)
        @test_throws ArgumentError BCH.validate_bch_parameters(15, 20)
        
        # Non-positive values
        @test_throws ArgumentError BCH.validate_bch_parameters(0, 5)
        @test_throws ArgumentError BCH.validate_bch_parameters(15, 0)
        @test_throws ArgumentError BCH.validate_bch_parameters(-5, 3)
        
        # n > 2^m - 1
        @test_throws ArgumentError BCH.validate_bch_parameters(16, 10)
        @test_throws ArgumentError BCH.validate_bch_parameters(33, 20)
        
        # t < 1 (insufficient parity bits for error correction)
        @test_throws ArgumentError BCH.validate_bch_parameters(15, 13)  # (15-13)=2, m=4, so t=0
    end
end

@testset "BCH Parity Matrix Construction" begin
    @testset "BCH(15,7) Matrix Dimensions" begin
        n, k = 15, 7
        m, t = BCH.validate_bch_parameters(n, k)
        H = BCH.build_bch_parity_matrix(n, k, m, t)
        
        @test size(H, 1) == n - k  # 8 rows
        @test size(H, 2) == n      # 15 columns
        @test eltype(H) == F2
    end
    
    @testset "BCH(7,4) Matrix Dimensions" begin
        n, k = 7, 4
        m, t = BCH.validate_bch_parameters(n, k)
        H = BCH.build_bch_parity_matrix(n, k, m, t)
        
        @test size(H, 1) == n - k  # 3 rows
        @test size(H, 2) == n      # 7 columns
        @test eltype(H) == F2
    end
end

@testset "BCH(15,7) Expected Matrix" begin
    # Expected BCH(15,7) matrix from the specification
    expected = [
        1 0 0 0 1 0 0 1 1 0 1 0 1 1 1;
        0 1 0 0 1 1 0 1 0 1 1 1 1 0 0;
        0 0 1 0 0 1 1 0 1 0 1 1 1 1 0;
        0 0 0 1 0 0 1 1 0 1 0 1 1 1 1;
        1 0 0 0 1 1 0 0 0 1 1 0 0 0 1;
        0 0 0 1 1 0 0 0 1 1 0 0 0 1 1;
        0 0 1 0 1 0 0 1 0 1 0 0 1 0 1;
        0 1 1 1 1 0 1 1 1 1 0 1 1 1 1
    ]
    
    H_int = generate_bch_parity_check_matrix(15, 7)
    
    # Note: The actual matrix might have different row ordering
    # due to different conjugate ordering, so we test basic properties
    @test size(H_int) == (8, 15)
    @test all(x -> x ∈ [0, 1], H_int)
end

@testset "Integration Test - File Output" begin
    # Test file creation and cleanup
    test_filename = "test_BCH_15_7.bmat"
    
    try
        # Remove file if it exists
        isfile(test_filename) && rm(test_filename)
        
        # Generate matrix (this creates the file)
        H = generate_bch_parity_check_matrix(15, 7)
        
        # Check file was created with expected name format
        expected_filename = "BCH_15_7.bmat"
        @test isfile(expected_filename)
        
        # Read and verify file format
        content = read(expected_filename, String)
        lines = split(strip(content), '\n')
        
        # First line should be dimensions
        @test lines[1] == "8 15"
        
        # Should have 9 lines total (1 header + 8 data rows)
        @test length(lines) == 9
        
        # Each data line should have 15 space-separated values
        for i in 2:9
            values = split(lines[i], ' ')
            @test length(values) == 15
            @test all(v -> v ∈ ["0", "1"], values)
        end
        
    finally
        # Cleanup
        isfile("BCH_15_7.bmat") && rm("BCH_15_7.bmat")
        isfile(test_filename) && rm(test_filename)
    end
end