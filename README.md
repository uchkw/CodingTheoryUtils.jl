# CodingTheoryUtils.jl

[![CI](https://github.com/uchkw/CodingTheoryUtils.jl/actions/workflows/CI.yml/badge.svg)](https://github.com/uchkw/CodingTheoryUtils.jl/actions/workflows/CI.yml)

CodingTheoryUtils.jl is a Julia package that provides utilities for coding theory, with a particular focus on Galois field operations and related mathematical tools. This package is designed to support research and development in coding theory, error correction, and related fields.

## Features

- **Galois Field Operations**
  - Field size and extension degree calculations
  - Primitive root operations
  - Trace function implementation
  - Minimum polynomial computation
  - Conjugate element calculations
  - Root finding in finite fields

- **Polynomial Operations**
  - Polynomial representation and manipulation
  - Conversion between different polynomial formats
  - Companion matrix generation
  - Polynomial evaluation and factorization

- **Utility Functions**
  - Binary-decimal conversions
  - Vector operations
  - Matrix transformations
  - Pretty printing for Galois field elements
  - One-hot vector generation

## Installation

To install the package, use the Julia package manager:

```julia
using Pkg
Pkg.add("CodingTheoryUtils")
```

## Usage

Here's a simple example of using the package:

```julia
using CodingTheoryUtils

# Create a Galois field element
x = F2(1)

# Calculate field size
size = field_size(x)

# Find primitive root
root = primitive_root(F2)

# Convert between different representations
binary = de2bi(5)
decimal = bi2de(binary)
```

## Documentation

Documentation is currently under construction. Please check back later for detailed documentation.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the GNU General Public License Version 3 - see the LICENSE file for details.
