using Documenter
using CodingTheoryUtils
using CodingTheoryUtils.GaloisFieldUtils
using CodingTheoryUtils.BCH

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
