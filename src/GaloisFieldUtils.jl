module GaloisFieldUtils
using GaloisFields
using Polynomials
using LinearAlgebra

# Define F2 type
const F2 = GaloisField(2)
export F2

# Export list will be defined here
export field_size,
       extension_degree,
       primitive_root,
       is_primitive,
       de2bi,
       bi2de,
       de2f2,
       de2f2poly,
       bvec,
       wt,
       F2p,
       trace,
       get_tr_one_elem,
       get_minimum_polynomial,
       get_conjugates,
       get_roots,
       polynomial_from_roots,
       get_order,
       order,
       make_companion_matrix,
       from_f2mat_to_intmat,
       gf_pretty,
       hex,
       extract_degrees,
       string2coefvec,
       string2F2poly,
       one_hot_vector,
       num_terms

"""
    field_size(a::GaloisFields.AbstractGaloisField)::Int

Calculate the size of the finite field.

# Arguments
- `a::GaloisFields.AbstractGaloisField`: A finite field element

# Returns
- The size of the finite field

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
field_size(α) == 4
```
"""
function field_size(a::GaloisFields.AbstractGaloisField)::Int
    return length(typeof(a))
end

"""
    field_size(FF::Type{<:GaloisFields.AbstractGaloisField})::Int

Calculate the size of the finite field.

# Arguments
- `FF::Type{<:GaloisFields.AbstractGaloisField}`: A finite field type

# Returns
- The size of the finite field

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
field_size(F4) == 4
```
"""
function field_size(FF::Type{<:GaloisFields.AbstractGaloisField})::Int
    return length(FF)
end

"""
    extension_degree(ff::Type{<:GaloisFields.AbstractGaloisField})::Int

Calculate the extension degree of the finite field.

# Arguments
- `ff::Type{<:GaloisFields.AbstractGaloisField}`: A finite field type

# Returns
- The extension degree of the finite field

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
extension_degree(F4) == 2

GF2 = GaloisField(2)
extension_degree(GF2) == 1
```
"""
function extension_degree(ff::Type{<:GaloisFields.AbstractGaloisField})::Int
    if length(ff.parameters) == 2
        return 1
    else
        return ff.parameters[2]
    end
end

"""
    extension_degree(a::GaloisFields.AbstractGaloisField)::Int

Calculate the extension degree of the finite field.

# Arguments
- `a::GaloisFields.AbstractGaloisField`: A finite field element

# Returns
- The extension degree of the finite field

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
extension_degree(α) == 2
```
"""
function extension_degree(a::GaloisFields.AbstractGaloisField)::Int
    return extension_degree(typeof(a))
end

"""
    is_primitive(a::GaloisFields.AbstractGaloisField)::Bool

Check if an element is a primitive root of the finite field.

# Arguments
- `a::GaloisFields.AbstractGaloisField`: A finite field element

# Returns
- `true` if the element is a primitive root, `false` otherwise

# Notes
- A primitive root is an element that generates the multiplicative group of the field
- The multiplicative group of a finite field is cyclic

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
is_primitive(α) == true
is_primitive(F4(1)) == false

GF2 = GaloisField(2)
is_primitive(GF2(1)) == true # Special case for GF(2)
```
"""
function is_primitive(a::GaloisFields.AbstractGaloisField)::Bool
    if length(typeof(a)) == 2
        return isone(a)
    end
    if iszero(a) || isone(a)
        return false
    end
    for i in 1:length(typeof(a))-2
        if isone(a^i)
            return false
        end
    end
    return true
end

"""
    primitive_root(FF::Type{<:GaloisFields.AbstractGaloisField})::GaloisFields.AbstractGaloisField

Find a primitive root of the finite field.

# Arguments
- `FF::Type{<:GaloisFields.AbstractGaloisField}`: A finite field type

# Returns
- A primitive root of the finite field

# Notes
- A primitive root is an element that generates the multiplicative group of the field
- The multiplicative group of a finite field is cyclic

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
primitive_root(F4) == α

GF2 = GaloisField(2)
primitive_root(GF2) == GF2(1)
```
"""
function primitive_root(FF::Type{<:GaloisFields.AbstractGaloisField})::GaloisFields.AbstractGaloisField
    for a in FF
        if is_primitive(a)
            return a
        end
    end
    # Should theoretically not be reached for valid finite fields, but handle gracefully.
    error("Primitive root not found for field \$FF. This might indicate an issue with the field definition or is_primitive function.")
end

# Placeholder functions for exports
function de2bi end
function bi2de end
function de2f2 end
function de2f2poly end
function bvec end
function wt end

"""
    de2bi(d::Integer; width::Int = 0)::Vector{Int}

Convert a decimal number to a binary vector.

# Arguments
- `d::Integer`: The decimal number to convert
- `width::Int = 0`: The desired width of the output vector. If 0, the minimum required width is used.

# Returns
- `Vector{Int}`: A vector of 0s and 1s representing the binary form of the input number

# Examples
```julia
julia> de2bi(5)
3-element Vector{Int64}:
 1
 0
 1

julia> de2bi(5, width=4)
4-element Vector{Int64}:
 1
 0
 1
 0
```
"""
function de2bi(d::Integer; width::Int = 0)::Vector{Int}
    d < 0 && throw(ArgumentError("Input must be non-negative"))
    
    # Calculate minimum required width
    min_width = d == 0 ? 1 : Int(floor(log2(d))) + 1
    actual_width = max(min_width, width)
    
    # Initialize result vector
    result = zeros(Int, actual_width)
    
    # Convert to binary
    for i in 1:min_width
        result[i] = (d >> (i-1)) & 1
    end
    
    return result
end

# Type aliases for convenience
de2bi(d::UInt; width::Int = 0) = de2bi(Int(d); width)
de2bi(d::UInt8; width::Int = 0) = de2bi(Int(d); width)
de2bi(d::UInt16; width::Int = 0) = de2bi(Int(d); width)

"""
    bi2de(b::Vector{<:Integer})::Int

Convert a binary vector to a decimal number.

# Arguments
- `b::Vector{<:Integer}`: A vector of 0s and 1s representing a binary number

# Returns
- `Int`: The decimal representation of the input binary vector

# Examples
```julia
julia> bi2de([1, 0, 1])
5

julia> bi2de([0, 1, 0, 1])
10
```
"""
function bi2de(b::Vector{<:Integer})::Int
    isempty(b) && throw(ArgumentError("Input vector cannot be empty"))
    any(x -> x ∉ (0, 1), b) && throw(ArgumentError("Input vector must contain only 0s and 1s"))
    
    return sum(b[i] * 2^(i-1) for i in eachindex(b))
end

"""
    de2f2(d::Integer; width::Int = 0)::Vector{F2}

Convert a decimal number to a vector of F2 elements.

# Arguments
- `d::Integer`: The decimal number to convert
- `width::Int = 0`: The desired width of the output vector. If 0, the minimum required width is used.

# Returns
- `Vector{F2}`: A vector of F2 elements representing the binary form of the input number

# Examples
```julia
julia> de2f2(5)
3-element Vector{F2}:
 1
 0
 1

julia> de2f2(5, width=4)
4-element Vector{F2}:
 1
 0
 1
 0
```
"""
function de2f2(d::Integer; width::Int = 0)::Vector{F2}
    return map(F2, de2bi(d; width=width))
end

"""
    de2f2poly(d::Integer; width::Int = 0)::Polynomial{F2,:x}

Convert a decimal number to a polynomial over F2.

# Arguments
- `d::Integer`: The decimal number to convert
- `width::Int = 0`: The desired width of the polynomial coefficients. If 0, the minimum required width is used.

# Returns
- `Polynomial{F2,:x}`: A polynomial over F2 representing the binary form of the input number

# Examples
```julia
julia> de2f2poly(5)
Polynomial(1 + x^2)

julia> de2f2poly(5, width=4)
Polynomial(1 + x^2)
```
"""
function de2f2poly(d::Integer; width::Int = 0)::Polynomial{F2,:x}
    return Polynomial(de2f2(d; width=width))
end

# Placeholder functions for other exports
function get_minimum_polynomial end
function get_conjugates end
function get_roots end
function get_order end
function make_companion_matrix end
function from_f2mat_to_intmat end
function gf_pretty end
function hex end
function extract_degrees end
function string2coefvec end
function string2F2poly end
function one_hot_vector end
function num_terms end

"""
    bvec(α::Fe)::Vector{F2}

Convert a Galois field element to its binary vector representation.
The length of the output vector is equal to the extension degree of the field.

# Arguments
- `α::Fe`: A Galois field element

# Returns
- `Vector{F2}`: Binary vector representation of the element
"""
function bvec(α::Fe)::Vector{F2} where Fe <: GaloisFields.AbstractExtensionField
    return [iszero((α.n >> (i-1)) & 1) ? zero(F2) : one(F2) for i in 1:extension_degree(α)]
end

"""
    bvec(x::T, bw::Int=0)::Vector{F2}

Convert an integer to its binary vector representation.

# Arguments
- `x::T`: An integer value
- `bw::Int`: Optional bit width (default: 0, meaning automatic calculation)

# Returns
- `Vector{F2}`: Binary vector representation of the integer
"""
function bvec(x::T, bw::Int=0)::Vector{F2} where T <: Integer
    if bw == 0
        bw = x == 0 ? 1 : ceil(Int, log2(x))
    end
    bx = de2bi(x, width=bw)
    return map(F2, bx)
end

"""
    bvec(p::Polynomial{F2,:x}, bw::Int=0)::Vector{F2}

Convert a polynomial over F2 to its binary vector representation.

# Arguments
- `p::Polynomial{F2,:x}`: A polynomial over F2
- `bw::Int`: Optional bit width (default: 0, meaning use polynomial degree)

# Returns
- `Vector{F2}`: Binary vector representation of the polynomial
"""
function bvec(p::Polynomial{F2,:x}, bw::Int=0)::Vector{F2}
    if iszero(bw) || iszero(bw-length(p))
        return p.coeffs
    else
        return vcat(p.coeffs, zeros(F2, bw-length(p)))
    end
end

"""
    wt(v::Vector{F2})::Int

Calculate the Hamming weight (number of non-zero elements) of a binary vector.

# Arguments
- `v::Vector{F2}`: A binary vector over F2

# Returns
- `Int`: The Hamming weight of the vector
"""
function wt(v::Vector{F2})::Int
    return sum(v[i].n for i in eachindex(v))
end

"""
    F2p(b::Vector{Fb}, α::Fe)::Fe

Convert a vector of F2 elements to a field element using the given basis element.

# Arguments
- `b::Vector{Fb}`: A vector of F2 elements
- `α::Fe`: A basis element of the target field

# Returns
- `Fe`: The field element represented by the vector

# Throws
- `AssertionError`: If the length of the input vector does not match the extension degree of the field

# Examples
```julia
julia> F4, α = GaloisField(2, 2, :α)
julia> F2p([F2(1), F2(0)], α)
1
```
"""
function F2p(b::Vector{Fb}, α::Fe)::Fe where Fb <: GaloisFields.AbstractGaloisField where Fe <: GaloisFields.AbstractExtensionField
    @assert length(b) == extension_degree(α) "Vector length must match field extension degree"
    basis = [α^i for i in 0:length(b)-1]
    return sum(basis .* b)
end

"""
    F2p(Fe::Type{<:GaloisFields.AbstractExtensionField}, b::Vector{Fb})::Fe

Convert a vector of F2 elements to a field element using the primitive element of the field.

# Arguments
- `Fe::Type{<:GaloisFields.AbstractExtensionField}`: The target field type
- `b::Vector{Fb}`: A vector of F2 elements

# Returns
- `Fe`: The field element represented by the vector

# Throws
- `AssertionError`: If the length of the input vector does not match the extension degree of the field

# Examples
```julia
julia> F4, α = GaloisField(2, 2, :α)
julia> F2p(F4, [F2(1), F2(0)])
1
```
"""
function F2p(Fe::Type{<:GaloisFields.AbstractExtensionField}, b::Vector{Fb})::Fe where Fb <: GaloisFields.AbstractGaloisField
    @assert length(b) == extension_degree(Fe) "Vector length must match field extension degree"
    α = primitive_root(Fe)
    basis = [α^i for i in 0:length(b)-1]
    return sum(basis .* b)
end

"""
    trace(a::F)::F2 where F <: GaloisFields.AbstractGaloisField

Calculate the trace of a Galois field element.

# Arguments
- `a::F`: A Galois field element

# Returns
- `F2`: The trace of the element (0 or 1)

# Notes
- The trace of an element a in GF(2^m) is defined as Tr(a) = a + a^2 + a^4 + ... + a^(2^(m-1))
- The trace is always an element of the base field GF(2)
- The trace is a linear function over GF(2)
- The trace of zero is zero
"""
function trace(a::F)::F2 where F <: GaloisFields.AbstractGaloisField
    if iszero(a)
        return zero(F2)
    end
    r = a
    for i in 1:extension_degree(F)-1
        r += a^(2^i)
    end
    return F2(r.n & 1)
end

"""
    get_tr_one_elem(a::F)::F where F <: GaloisFields.AbstractGaloisField

Find an element in the Galois field whose trace is 1.

# Arguments
- `a::F`: A non-zero Galois field element (assumed to be a primitive element)

# Returns
- `F`: An element whose trace is 1

# Throws
- `AssertionError`: If the input element is zero

# Notes
- This function finds an element b such that trace(b) = 1
- Such an element always exists in a finite field of characteristic 2
- The returned element can be used as a basis element for the trace-dual basis
"""
function get_tr_one_elem(a::F)::F where F <: GaloisFields.AbstractGaloisField
    @assert !iszero(a) "Input element cannot be zero"
    for i in 0:field_size(a)-2
        if isone(trace(a^i))
            return a^i
        end
    end
    error("No element with trace 1 found")
end


"""
    inv(M::Array{F, 2}) where F <: GaloisFields.AbstractGaloisField

Compute the inverse of a square matrix over a Galois field using Gaussian elimination.

# Arguments
- `M`: A square matrix over a Galois field

# Returns
- The inverse matrix if it exists
- `nothing` if the matrix is singular

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
M = [α 1; 1 α]
M_inv = inv(M)
```
"""
function Base.inv(M::Matrix{F}) where F <: GaloisFields.AbstractGaloisField
    n, m = size(M)
    n != m && throw(DimensionMismatch("Matrix must be square"))
    
    # Create augmented matrix [M|I]
    N = Matrix(I, n, n)
    MN = hcat(M, N)
    
    # Gaussian elimination
    for j in 1:n
        # Find pivot
        pivot_row = j
        for i in j:n
            if !iszero(MN[i,j])
                pivot_row = i
                break
            end
        end
        
        # Swap rows if necessary
        if pivot_row != j
            MN[j,:], MN[pivot_row,:] = MN[pivot_row,:], MN[j,:]
        end
        
        # Check if matrix is singular
        if iszero(MN[j,j])
            return nothing
        end
        
        # Normalize pivot row
        pivot = MN[j,j]
        if !isone(pivot)
            MN[j,:] /= pivot
        end
        
        # Eliminate column j in other rows
        for i in 1:n
            i == j && continue
            if !iszero(MN[i,j])
                MN[i,:] -= MN[j,:] * MN[i,j]
            end
        end
    end
    
    # Extract inverse matrix
    return MN[:, n+1:2n]
end

"""
    Base.:*(a::Vector{F2}, b::Vector{F2})::F2

Compute the dot product of two binary vectors.

# Arguments
- `a::Vector{F2}`: First binary vector
- `b::Vector{F2}`: Second binary vector

# Returns
- `F2`: The dot product result in F2

# Examples
```julia
v1 = [F2(1), F2(0), F2(1)]
v2 = [F2(1), F2(1), F2(0)]
result = v1 * v2  # Returns F2(1)
```

# Throws
- `AssertionError`: If the vectors have different lengths
"""
function Base.:*(a::Vector{F2}, b::Vector{F2})::F2
    @assert length(a) == length(b) "Vectors must have the same length for dot product"
    result = F2(0)
    @inbounds for i in 1:length(a)
        result += a[i] * b[i]
    end
    return result
end

"""
    Base.:*(a::Vector{F}, b::Vector{F2})::F where F <: GaloisFields.AbstractGaloisField

Compute the dot product of two vectors over Galois fields.

# Arguments
- `a::Vector{F}`: First vector with elements in a Galois field F
- `b::Vector{F2}`: Second vector with elements in F2 (binary field)

# Returns
- `F`: The dot product result in the same field as the first vector

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
v1 = [F4(1), F4(0), F4(1)]
v2 = [F2(1), F2(1), F2(0)]
result = v1 * v2  # Returns F4(1)
```

# Throws
- `AssertionError`: If the vectors have different lengths
"""
function Base.:*(a::Vector{F}, b::Vector{F2})::F where F <: GaloisFields.AbstractGaloisField
    @assert length(a) == length(b) "Vectors must have the same length for dot product"
    result = F(0)
    @inbounds for i in 1:length(a)
        result += a[i] * b[i]
    end
    return result
end

"""
    Base.:*(a::Vector{F2}, b::Vector{F})::F where F <: GaloisFields.AbstractGaloisField

Compute the dot product of two vectors over Galois fields, with the first vector in F2.

This is a commutative operation that calls the main dot product implementation.

# Arguments
- `a::Vector{F2}`: First vector with elements in F2 (binary field)
- `b::Vector{F}`: Second vector with elements in a Galois field F

# Returns
- `F`: The dot product result in the same field as the second vector

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
v1 = [F2(1), F2(1), F2(0)]
v2 = [F4(1), F4(0), F4(1)]
result = v1 * v2  # Returns F4(1)
```

# Throws
- `AssertionError`: If the vectors have different lengths
"""
function Base.:*(a::Vector{F2}, b::Vector{F})::F where F <: GaloisFields.AbstractGaloisField
    return Base.:*(b, a)
end

"""
    get_conjugates(β::F)::Array{F,1} where F <: GaloisFields.AbstractExtensionField

Calculate the conjugates of a finite field element.

# Arguments
- `β`: A finite field element

# Returns
- `Array{F,1}`: An array of the element's conjugates

# Examples
```julia
julia> F4 = @GaloisField 2^2
julia> α = primitiveroot(F4)
julia> get_conjugates(α)
2-element Array{GaloisField{2,2},1}:
 α
 α^2
```
"""
function get_conjugates(β::F)::Array{F,1} where F <: GaloisFields.AbstractExtensionField
    iszero(β) && return [zero(F)]
    ret = [β]
    i = 1
    x = β^2
    while x != β
        push!(ret, x)
        i += 1
        x = β^(2^i)
    end
    return ret
end

"""
    get_minimum_polynomial(β::F)::Polynomial{F} where F <: GaloisFields.AbstractExtensionField

Calculate the minimal polynomial of a finite field element.

# Arguments
- `β`: A finite field element

# Returns
- `Polynomial{F}`: The minimal polynomial of the element

# Examples
```julia
julia> F4 = @GaloisField 2^2
julia> α = primitiveroot(F4)
julia> get_minimum_polynomial(α)
Polynomial(1 + x + x^2)
```
"""
function get_minimum_polynomial(β::F)::Polynomial{F} where F <: GaloisFields.AbstractExtensionField
    iszero(β) && throw(ArgumentError("Cannot compute minimal polynomial of zero element"))
    conjugates = get_conjugates(β)
    n = length(conjugates)
    c = zeros(F, n+1)
    c[1] = one(F)
    for j = 1:n
        for i = j:-1:1
            c[i+1] = c[i+1] - conjugates[j]*c[i]
        end
    end
    return Polynomial(reverse(c), :x)
end

"""
    get_roots(px::Polynomial{F})::Array{F,1} where F <: GaloisFields.AbstractExtensionField

Calculate the roots of a polynomial over a finite field.

# Arguments
- `px`: A polynomial over a finite field

# Returns
- `Array{F,1}`: An array of the polynomial's roots

# Examples
```julia
julia> F4, α = GaloisField(2, 2, :α)
julia> p = Polynomial([F4(1), F4(1), F4(1)])  # x^2 + x + 1
julia> get_roots(p)
2-element Array{GaloisField{2,2},1}:
 α
 α^2
```
"""
function get_roots(px::Polynomial{F})::Array{F,1} where F <: GaloisFields.AbstractExtensionField
    ret = Vector{F}()
    # Check 0
    if iszero(px(zero(F)))
        push!(ret, zero(F))
    end
    # Check non-zero elements
    prim = primitive_root(F)  # Get primitive root
    q = field_size(F)
    # Check exponents from 0 to q-2 (q-1 is the order of the multiplicative group)
    for i in 0:q-2
        x = prim^i
        if iszero(px(x))
            push!(ret, x)
        end
    end
    return ret
end

"""
    polynomial_from_roots(r::AbstractVector{T}, var::Polynomials.SymbolLike=:x)::Polynomial{T} where {T}

Generate a polynomial from its roots.

# Arguments
- `r`: An array of roots
- `var`: The variable symbol for the polynomial (default: :x)

# Returns
- `Polynomial{T}`: The polynomial with the given roots

# Examples
```julia
julia> F4, α = GaloisField(2, 2, :α)
julia> roots = [α, α^2]
julia> polynomial_from_roots(roots)
Polynomial(1 + x + x^2)
```
"""
function polynomial_from_roots(r::AbstractVector{T}, var::Polynomials.SymbolLike=:x)::Polynomial{T} where {T}
    n = length(r)
    c = zeros(T, n+1)
    c[1] = one(T)
    for j = 1:n
        for i = j:-1:1
            c[i+1] = c[i+1] - r[j]*c[i]
        end
    end
    return Polynomial(reverse(c), var)
end

"""
    get_order(x::F) where F <: GaloisFields.AbstractGaloisField

Calculate the order of a finite field element.

# Arguments
- `x::F`: A finite field element

# Returns
- `Int`: The order of the element. If the element is zero, returns -1.

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
get_order(α)  # 3
get_order(F4(1))  # 1
get_order(F4(0))  # -1
```
"""
function get_order(x::F) where F <: GaloisFields.AbstractGaloisField
    iszero(x) && return -1
    isone(x) && return 1
    
    field_size = length(typeof(x))
    for i in 2:field_size
        isequal(x^i, one(F)) && return i
    end
    return -1
end

"""
    get_order(genpoly::Polynomial{F}) where F <: GaloisFields.AbstractGaloisField

Calculate the order of a polynomial.

# Arguments
- `genpoly::Polynomial{F}`: A polynomial over a finite field

# Returns
- `Int`: The order of the polynomial

# Examples
```julia
F2 = @GaloisField 2
p = Polynomial([F2(1), F2(1), F2(1)])  # x^2 + x + 1
get_order(p)  # 3
```
"""
function get_order(genpoly::Polynomial{F}) where F <: GaloisFields.AbstractGaloisField
    F2 = @GaloisField 2
    coeffs = Array{F2}(genpoly.coeffs[1:end-1])
    A = make_companion_matrix(coeffs)
    
    # Initial vector [1, 0, ..., 0]
    s = zeros(F2, size(A, 1))
    s[1] = one(F2)
    
    # Calculate matrix powers to find the order
    n = A * s
    order = 1
    while !isequal(n, s)
        order += 1
        n = A * n
    end
    
    return order
end

# Alias
const order = get_order

"""
    make_companion_matrix(g::Vector{F})::Matrix{F} where F <: GaloisFields.AbstractGaloisField

Generate a companion matrix from a polynomial's coefficient vector.

# Arguments
- `g::Vector{F}`: Coefficient vector of the polynomial (excluding constant term)

# Returns
- `Matrix{F}`: Companion matrix

# Examples
```julia
F2 = @GaloisField 2
g = [F2(1), F2(1)]  # Coefficients of x^2 + x + 1
A = make_companion_matrix(g)
```
"""
function make_companion_matrix(g::Vector{F})::Matrix{F} where F <: GaloisFields.AbstractGaloisField
    n = length(g)
    A = zeros(F, n, n)
    A[:, end] = copy(g)
    for i in 2:n
        A[i, i-1] = one(F)
    end
    return A
end

"""
    make_companion_matrix(a::F)::Matrix{F2} where F <: GaloisFields.AbstractGaloisField

Generate a companion matrix from a finite field element.

# Arguments
- `a::F`: A finite field element

# Returns
- `Matrix{F2}`: Companion matrix

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
A = make_companion_matrix(α)
```
"""
function make_companion_matrix(a::F)::Matrix{F2} where F <: GaloisFields.AbstractGaloisField
    d = length(bvec(a))
    A = zeros(F2, d, d)
    v = a
    p = primitive_root(typeof(a))
    for i in 1:d
        A[:, i] = bvec(v)
        v *= p
    end
    return A
end

"""
    make_companion_matrix(a::F, α::F)::Matrix{F2} where F <: GaloisFields.AbstractGaloisField

Generate a companion matrix from a finite field element and its primitive root.

# Arguments
- `a::F`: A finite field element
- `α::F`: The primitive root of the field

# Returns
- `Matrix{F2}`: Companion matrix

# Examples
```julia
F4, α = GaloisField(2, 2, :α)
A = make_companion_matrix(α, α)
```
"""
function make_companion_matrix(a::F, α::F)::Matrix{F2} where F <: GaloisFields.AbstractGaloisField
    d = length(bvec(a))
    A = zeros(F2, d, d)
    v = a
    for i in 1:d
        A[:, i] = bvec(v)
        v *= α
    end
    return A
end

"""
    from_f2mat_to_intmat(M::Matrix{<:GaloisFields.AbstractGaloisField})::Matrix{Int}

Convert a matrix over a Galois field to an integer matrix where 1 is mapped to 1 and 0 is mapped to 0.

# Arguments
- `M::Matrix{<:GaloisFields.AbstractGaloisField}`: Input matrix over a Galois field

# Returns
- `Matrix{Int}`: Integer matrix with the same dimensions as the input matrix

# Examples
```julia
julia> F4, α = GaloisField(2, 2, :α)
julia> M = [F4(1) F4(0); F4(0) F4(1)]
julia> from_f2mat_to_intmat(M)
2×2 Matrix{Int64}:
 1  0
 0  1
```
"""
function from_f2mat_to_intmat(M::Matrix{<:GaloisFields.AbstractGaloisField})::Matrix{Int}
    rows, cols = size(M)
    result = zeros(Int, rows, cols)
    
    @inbounds for j in 1:cols, i in 1:rows
        result[i,j] = Int(M[i,j] == one(M[i,j]))
    end
    
    return result
end

"""
    hex(v::Vector{F2})::String

Convert a binary vector over F2 to a hexadecimal string representation.

# Arguments
- `v::Vector{F2}`: A binary vector over F2

# Returns
- `String`: Hexadecimal string representation of the input vector

# Examples
```julia
julia> v = [F2(1), F2(0), F2(1), F2(0)]
julia> hex(v)
"a"  # 1010 in hex

julia> v = [F2(1), F2(1), F2(1), F2(1), F2(0), F2(0), F2(0), F2(0)]
julia> hex(v)
"f0"  # 11110000 in hex
```
"""
function hex(v::Vector{F2})::String
    isempty(v) && return ""
    n = length(v)
    hex_digits = ceil(Int, n / 4)
    
    value = 0
    for i in 1:n # Process bits from left to right (MSB first)
        value = (value << 1) | v[i].n
    end
    
    return string(value, base=16, pad=hex_digits)
end

# --- Add gf_pretty implementations below --- #

"""
    gf_pretty(a::F, α::F)::String where F <: GaloisFields.AbstractGaloisField

Pretty print a Galois field element in the form "α^p".

# Arguments
- `a::F`: The Galois field element to print.
- `α::F`: The primitive element of the field used as the base.

# Returns
- `String`: The string representation "α^p" or "0" if the element is zero.

# Examples
```julia
F4, α = GaloisField(4, :α)
gf_pretty(α, α) == "α^1"
gf_pretty(F4(1), α) == "α^0"
gf_pretty(F4(0), α) == "0"
```
"""
function gf_pretty(a::F, α::F)::String where F <: GaloisFields.AbstractGaloisField
    if iszero(a)
        return "0"
    end
    p = -1
    prim_sym = typeof(α).parameters[3] # Get the symbol of the primitive element (e.g., :α)
    for i in 0:field_size(a)-2
        if a == α^i
            p = i
            break
        end
    end
    if p == -1
        error("Element $a not found as a power of primitive element $α")
    end
    return string(prim_sym) * "^" * string(p)
end

"""
    gf_pretty(v::Vector{F}, α::F)::Vector{String} where F <: GaloisFields.AbstractGaloisField

Pretty print a vector of Galois field elements using `gf_pretty(a, α)` for each element.

# Arguments
- `v::Vector{F}`: The vector of Galois field elements.
- `α::F`: The primitive element of the field.

# Returns
- `Vector{String}`: A vector of string representations.
"""
function gf_pretty(v::Vector{F}, α::F)::Vector{String} where F <: GaloisFields.AbstractGaloisField
    return [gf_pretty(el, α) for el in v]
end

"""
    gf_pretty(v::Vector{F2})::String

Pretty print a binary vector (F2) as a polynomial string (e.g., "1 + x^2").
Corresponds to the polynomial whose coefficients are the elements of `v`.

# Arguments
- `v::Vector{F2}`: The binary vector.

# Returns
- `String`: The polynomial string representation, or "0" for zero/empty vector.

# Examples
```julia
gf_pretty([F2(1), F2(0), F2(1)]) == "1 + x^2"
gf_pretty([F2(0), F2(1)]) == "x"
gf_pretty(F2[]) == "0"
```
"""
function gf_pretty(v::Vector{F2})::String
    if isempty(v) || all(iszero, v)
        return "0"
    end
    terms = String[]
    for i in eachindex(v)
        if !iszero(v[i])
            if i == 1
                push!(terms, "1")
            elseif i == 2
                push!(terms, "x")
            else
                push!(terms, "x^" * string(i - 1))
            end
        end
    end
    return join(terms, " + ")
end

"""
    extract_degrees(polynomial::AbstractString) -> Vector{Int}

Extract the degrees of the terms in a polynomial string representation.

The polynomial string should be in the format "x^a + x^b + ... + 1".
Terms should be separated by " + ".

# Examples
julia> extract_degrees("x^3 + x + 1")
3-element Vector{Int64}:
 3
 1
 0

julia> extract_degrees("x^5")
1-element Vector{Int64}:
 5
"""
function extract_degrees(polynomial::AbstractString)::Vector{Int}
    degrees = Vector{Int}()
    isempty(strip(polynomial)) && return degrees # Handle empty or whitespace string

    # Split terms and remove whitespace
    terms = split(polynomial, "+")
    for term in terms
        term = strip(term)
        isempty(term) && continue # Skip empty terms resulting from multiple '+'

        # Match 'x^degree'
        match_result = match(r"^x\^(\d+)$", term)
        if match_result !== nothing
            degree = parse(Int, match_result.captures[1])
            push!(degrees, degree)
            continue
        end

        # Match 'x'
        if term == "x"
            push!(degrees, 1)
            continue
        end

        # Match '1'
        if term == "1"
            push!(degrees, 0)
            continue
        end

        # Handle potential malformed terms (optional: could throw an error)
        @warn "Skipping potentially malformed term: '$term' in polynomial '$polynomial'"
    end

    # Return degrees sorted in descending order
    return sort(degrees, rev=true)
end

"""
    string2coefvec(polynomial::AbstractString) -> Vector{Int}

Convert a polynomial string representation into a coefficient vector (Int).
Assumes the polynomial is over GF(2), so coefficients are 0 or 1.
The vector index corresponds to the degree (index 1 is degree 0).

# Examples
julia> string2coefvec("x^3 + x + 1")
4-element Vector{Int64}:
 1
 1
 0
 1

julia> string2coefvec("x^5")
6-element Vector{Int64}:
 0
 0
 0
 0
 0
 1
"""
function string2coefvec(polynomial::AbstractString)::Vector{Int}
    degrees = extract_degrees(polynomial)
    isempty(degrees) && return Int[] # Handle empty polynomial

    max_degree = maximum(degrees)
    coef_array = zeros(Int, max_degree + 1)
    for i in degrees
        coef_array[i+1] = 1 # GF(2) assumed
    end
    return coef_array
end

"""
    string2F2poly(polynomial::AbstractString) -> Polynomial{F2, :x}

Convert a polynomial string representation into a Polynomial{F2, :x} object.

# Examples
julia> string2F2poly("x^3 + x + 1")
Polynomial(1 + x + x^3)

julia> string2F2poly("x^5")
Polynomial(x^5)
"""
function string2F2poly(polynomial::AbstractString)::Polynomial{F2, :x}
    coef_vec = string2coefvec(polynomial)
    isempty(coef_vec) && return Polynomial(F2[]) # Return empty polynomial
    f2_array = map(F2, coef_vec)
    return Polynomial(f2_array)
end

"""
    one_hot_vector(len::Int, pos::Int, v::F) where F <: AbstractGaloisField -> Vector{F}

Create a one-hot vector of length `len` with value `v` at position `pos`.
All other elements will be zero in the field `F`.

# Arguments
- `len::Int`: The length of the resulting vector.
- `pos::Int`: The 1-based index where the value `v` should be placed.
- `v::F`: The value to place at the specified position.

# Returns
- `Vector{F}`: The resulting one-hot vector.

# Examples
julia> one_hot_vector(5, 3, F2(1))
5-element Vector{F2}:
 0
 0
 1
 0
 0

julia> GF8, α = GaloisField(2, 3, :α);

julia> one_hot_vector(4, 2, α^3)
4-element Vector{GF8}:
 0
 α^3
 0
 0
"""
function one_hot_vector(len::Int, pos::Int, v::F)::Vector{F} where F <: GaloisFields.AbstractGaloisField
    (1 <= pos <= len) || throw(BoundsError("Position must be within 1 and length ($len)"))
    ret = zeros(F, len)
    ret[pos] = v
    return ret
end

"""
    num_terms(f::Polynomial{F}) where F <: AbstractGaloisField -> Int

Return the number of non-zero terms (coefficients) in the polynomial `f`.

# Arguments
- `f::Polynomial{F}`: The input polynomial.

# Returns
- `Int`: The number of non-zero coefficients.

# Examples
julia> p = Polynomial([F2(1), F2(1), F2(0), F2(1)]); # 1 + x + x^3

julia> num_terms(p)
3
"""
function num_terms(f::Polynomial{F})::Int where F <: GaloisFields.AbstractGaloisField
    # Count non-zero coefficients directly
    # Note: Polynomials.jl might store trailing zeros, so check explicitly
    count = 0
    for coeff in f.coeffs
        !iszero(coeff) && (count += 1)
    end
    return count
end

"""
    log(α::F, a::F) where F <: AbstractGaloisField

Compute the logarithm of `a` in base `α` in the Galois field `F`.

# Arguments
- `α::F`: The base of the logarithm.
- `a::F`: The value to compute the logarithm of.

# Returns
- `Int`: The discrete logarithm of `a` base `α` if it exists.
- `Inf`: If `a` is zero.
- `nothing`: If `a` is not a power of `α`.

"""
function Base.log(α::F, a::F) where {F <: GaloisFields.AbstractGaloisField}
    iszero(a)   && return Inf
    isone(a)    && return 0

    ord = length(F) - 1          
    pow = one(F)
    for k in 0:ord-1
        pow == a && return k
        pow *= α
    end
    return nothing
end

end # module GaloisFieldUtils 