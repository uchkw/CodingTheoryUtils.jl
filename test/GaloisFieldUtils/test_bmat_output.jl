using Test
using CodingTheoryUtils

@testset "write_bmat_file Tests" begin
    
    @testset "Int Matrix Output" begin
        # Test with simple integer matrix
        H_int = [1 0 1; 0 1 1; 1 1 0]
        test_file = "test_int_matrix.bmat"
        
        try
            write_bmat_file(H_int, test_file)
            
            # Verify file exists
            @test isfile(test_file)
            
            # Read and verify content
            content = read(test_file, String)
            lines = split(strip(content), '\n')
            
            # Check dimensions line
            @test lines[1] == "3 3"
            
            # Check matrix content
            @test lines[2] == "1 0 1"
            @test lines[3] == "0 1 1" 
            @test lines[4] == "1 1 0"
            
            @test length(lines) == 4
            
        finally
            isfile(test_file) && rm(test_file)
        end
    end
    
    @testset "F2 Matrix Output" begin
        # Test with F2 matrix
        H_F2 = [F2(1) F2(0) F2(1); F2(0) F2(1) F2(1)]
        test_file = "test_f2_matrix.bmat"
        
        try
            write_bmat_file(H_F2, test_file)
            
            # Verify file exists
            @test isfile(test_file)
            
            # Read and verify content
            content = read(test_file, String)
            lines = split(strip(content), '\n')
            
            # Check dimensions line
            @test lines[1] == "2 3"
            
            # Check matrix content (F2 should be converted to Int)
            @test lines[2] == "1 0 1"
            @test lines[3] == "0 1 1"
            
            @test length(lines) == 3
            
        finally
            isfile(test_file) && rm(test_file)
        end
    end
    
    @testset "Large Matrix Output" begin
        # Test with larger matrix
        rows, cols = 5, 8
        H_large = rand(0:1, rows, cols)
        test_file = "test_large_matrix.bmat"
        
        try
            write_bmat_file(H_large, test_file)
            
            # Verify file exists
            @test isfile(test_file)
            
            # Read and verify structure
            content = read(test_file, String)
            lines = split(strip(content), '\n')
            
            # Check dimensions line
            @test lines[1] == "$rows $cols"
            
            # Check number of lines
            @test length(lines) == rows + 1
            
            # Check each row has correct number of elements
            for i in 2:(rows+1)
                values = split(lines[i], ' ')
                @test length(values) == cols
                @test all(v -> v ∈ ["0", "1"], values)
            end
            
        finally
            isfile(test_file) && rm(test_file)
        end
    end
    
    @testset "Edge Cases" begin
        @testset "Single Element Matrix" begin
            H_single = reshape([1], 1, 1)
            test_file = "test_single.bmat"
            
            try
                write_bmat_file(H_single, test_file)
                
                content = read(test_file, String)
                lines = split(strip(content), '\n')
                
                @test lines[1] == "1 1"
                @test lines[2] == "1"
                @test length(lines) == 2
                
            finally
                isfile(test_file) && rm(test_file)
            end
        end
        
        @testset "Single Row Matrix" begin
            H_row = [1 0 1 0 1]
            test_file = "test_row.bmat"
            
            try
                write_bmat_file(H_row, test_file)
                
                content = read(test_file, String)
                lines = split(strip(content), '\n')
                
                @test lines[1] == "1 5"
                @test lines[2] == "1 0 1 0 1"
                @test length(lines) == 2
                
            finally
                isfile(test_file) && rm(test_file)
            end
        end
        
        @testset "Single Column Matrix" begin
            H_col = reshape([1, 0, 1], 3, 1)
            test_file = "test_col.bmat"
            
            try
                write_bmat_file(H_col, test_file)
                
                content = read(test_file, String)
                lines = split(strip(content), '\n')
                
                @test lines[1] == "3 1"
                @test lines[2] == "1"
                @test lines[3] == "0"
                @test lines[4] == "1"
                @test length(lines) == 4
                
            finally
                isfile(test_file) && rm(test_file)
            end
        end
    end
    
    @testset "File Overwrite" begin
        # Test that function properly overwrites existing files
        test_file = "test_overwrite.bmat"
        
        try
            # Write first matrix
            H1 = [1 0; 0 1]
            write_bmat_file(H1, test_file)
            
            # Write second matrix (should overwrite)
            H2 = [0 1 1; 1 0 1; 1 1 0]
            write_bmat_file(H2, test_file)
            
            # Verify content is from second matrix
            content = read(test_file, String)
            lines = split(strip(content), '\n')
            
            @test lines[1] == "3 3"
            @test length(lines) == 4
            
        finally
            isfile(test_file) && rm(test_file)
        end
    end
end