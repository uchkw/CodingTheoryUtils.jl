using Pkg
Pkg.develop(PackageSpec(path=joinpath(@__DIR__, "..")))
using Documenter
using CodingTheoryUtils

# Import submodules explicitly  
import CodingTheoryUtils.GaloisFieldUtils
import CodingTheoryUtils.BCH

makedocs(
    sitename = "CodingTheoryUtils.jl",
    modules = [CodingTheoryUtils, CodingTheoryUtils.GaloisFieldUtils, CodingTheoryUtils.BCH],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/uchkw/CodingTheoryUtils.jl",
    push_preview = true,
)
