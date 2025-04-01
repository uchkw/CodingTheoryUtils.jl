using Test
using GaloisFields
using Polynomials
using LinearAlgebra
using CodingTheoryUtils

@testset "Documentation Tests for GaloisFieldUtils" begin
    # List of functions that should have docstrings with examples
    function_names = [
        :field_size, 
        :extension_degree,
        :primitive_root, 
        :is_primitive,
        :de2bi,
        :bi2de,
        :de2f2,
        :de2f2poly,
        :bvec,
        :wt,
        :F2p,
        :trace,
        :get_tr_one_elem,
        :inv,
        :get_minimum_polynomial,
        :get_conjugates,
        :get_roots,
        :polynomial_from_roots,
        :get_order,
        :make_companion_matrix,
        :from_f2mat_to_intmat,
        :gf_pretty,
        :hex,
        :extract_degrees,
        :string2coefvec,
        :string2F2poly,
        :one_hot_vector,
        :num_terms
    ]
    
    # Read the source file to check for docstrings
    source_file = joinpath(@__DIR__, "../../src/GaloisFieldUtils.jl")
    source_content = read(source_file, String)
    
    # Check if docstring is present for each function
    for func_name in function_names
        # Pattern to check if a docstring exists BEFORE the function definition
        docstring_exists_pattern = Regex("\"\"\"[\\s\\S]*?^function\\s+(?:Base\\.)?$(func_name)", "m")

        # Check if the docstring pattern is found in the source (without custom message)
        @test occursin(docstring_exists_pattern, source_content)

        # Pattern to capture the docstring content
        capture_docstring_pattern = Regex("\"\"\"(.*?)\"\"\"\\s*^function\\s+(?:Base\\.)?$(func_name)", "ms")
        func_docstring_matches = match(capture_docstring_pattern, source_content)

        # Check if the function has an Examples section within its captured docstring
        if func_docstring_matches !== nothing && length(func_docstring_matches.captures) >= 1
            func_docstring = func_docstring_matches.captures[1]
            # Ensure the Examples section exists (without custom message)
            @test (occursin("# Examples", func_docstring) ||
                  occursin("## Examples", func_docstring) ||
                  occursin("### Examples", func_docstring))
        else
            # If docstring exists but couldn't be captured properly for Examples check, fail the test
            if occursin(docstring_exists_pattern, source_content)
                 @test false # Indicate failure to capture docstring for Examples check
            end
        end
    end
end 