using Documenter
using CodingTheoryUtils

makedocs(
    sitename = "CodingTheoryUtils.jl",
    modules = [CodingTheoryUtils],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
    ]
)

deploydocs(
    repo = "github.com/uchkw/CodingTheoryUtils.jl",
    push_preview = true,
)
