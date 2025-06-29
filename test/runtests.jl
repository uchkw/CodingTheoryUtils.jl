# Include test helpers
include("GaloisFieldUtils/test_helpers.jl")

# Include GaloisFieldUtils tests
include("GaloisFieldUtils/test_field_size.jl")
include("GaloisFieldUtils/test_primitive_root.jl")
include("GaloisFieldUtils/test_base_conversion.jl")
include("GaloisFieldUtils/test_binary_vector.jl")
include("GaloisFieldUtils/test_field_conversion.jl")
include("GaloisFieldUtils/test_trace.jl")
include("GaloisFieldUtils/test_inverse.jl")
include("GaloisFieldUtils/test_dot_product.jl")
include("GaloisFieldUtils/test_minimal_polynomial.jl")
include("GaloisFieldUtils/test_roots.jl")
include("GaloisFieldUtils/test_order.jl")
include("GaloisFieldUtils/test_companion_matrix.jl")
include("GaloisFieldUtils/test_matrix_operations.jl")
include("GaloisFieldUtils/test_display.jl")
include("GaloisFieldUtils/test_string_conversion.jl")
include("GaloisFieldUtils/test_helper_functions.jl")
include("GaloisFieldUtils/test_documentation.jl")
include("GaloisFieldUtils/test_bmat_output.jl")

# Include BCH tests
include("BCH/test_bch.jl")