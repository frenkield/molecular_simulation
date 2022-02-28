using Random
using Dates

function affiche(object)
    display(round.(object, digits = 5))
    println()
end

function seed_random(extra = 1)
    Random.seed!(Dates.value(now()) * extra)
end

function relative_error(expected::Float64, approximate::Float64)
    abs((expected - approximate) / expected)
end

function compute_plot_limits(data::Array, scale::Float64)
    min_value = minimum(data)
    max_value = maximum(data)
    padding = (max_value - min_value) / scale
    return (min_value - padding, max_value + padding)
end
