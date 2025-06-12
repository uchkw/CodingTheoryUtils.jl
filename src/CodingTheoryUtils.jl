module CodingTheoryUtils

using Reexport
include("GaloisFieldUtils.jl")
@reexport using .GaloisFieldUtils

include("BCH.jl")
@reexport using .BCH

end # module CodingTheoryUtils
