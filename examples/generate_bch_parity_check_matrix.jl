#!/usr/bin/env julia

"""
Generate BCH parity check matrix and save to bmat format.

Usage: julia examples/generate_bch_parity_check_matrix.jl n k

Arguments:
  n    Code length
  k    Information bits

Output:
  Creates BCH_n_k.bmat file in current directory
  Prints matrix content to console
"""

using CodingTheoryUtils

function main(args::Vector{String})
    # Check number of arguments
    if length(args) != 2
        println("Error: Exactly 2 arguments required")
        println("Usage: julia examples/generate_bch_parity_check_matrix.jl n k")
        println("  n: Code length")
        println("  k: Information bits")
        exit(1)
    end
    
    # Parse arguments
    try
        n = parse(Int, args[1])
        k = parse(Int, args[2])
        
        # Generate BCH parity check matrix
        println("Generating BCH($n,$k) parity check matrix...")
        H = generate_bch_parity_check_matrix(n, k)
        
        println("Matrix saved to BCH_$(n)_$(k).bmat")
        
    catch e
        if isa(e, ArgumentError)
            println("Error: $(e.msg)")
        else
            println("Error parsing arguments: $e")
            println("Both n and k must be positive integers")
        end
        exit(1)
    end
end

# Run main function with command line arguments
if abspath(PROGRAM_FILE) == @__FILE__
    main(ARGS)
end