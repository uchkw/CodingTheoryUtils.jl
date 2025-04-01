"""
Test helper functions for GaloisFieldUtils tests.
"""

# Helper function to generate random binary vectors
function random_binary_vector(n::Integer)
    return rand(Bool, n)
end

# Helper function to generate random polynomials over F2
function random_f2poly(degree::Integer)
    return rand(Bool, degree + 1)
end

# Helper function to check if a vector is binary
function is_binary_vector(v::AbstractVector)
    return all(x -> x == 0 || x == 1, v)
end

# Helper function to check if a polynomial is over F2
function is_f2poly(p::AbstractVector)
    return all(x -> x == 0 || x == 1, p)
end

# Helper function to convert polynomial to string representation
function poly_to_string(p::AbstractVector)
    terms = String[]
    for (i, c) in enumerate(p)
        if c == 1
            if i == 1
                push!(terms, "1")
            elseif i == 2
                push!(terms, "x")
            else
                push!(terms, "x^$(i-1)")
            end
        end
    end
    return isempty(terms) ? "0" : join(terms, " + ")
end

# Helper function to check if two polynomials are equal
function are_polys_equal(p1::AbstractVector, p2::AbstractVector)
    # Remove trailing zeros
    p1 = rstrip_zeros(p1)
    p2 = rstrip_zeros(p2)
    return p1 == p2
end

# Helper function to remove trailing zeros
function rstrip_zeros(v::AbstractVector)
    i = length(v)
    while i > 0 && v[i] == 0
        i -= 1
    end
    return v[1:i]
end 