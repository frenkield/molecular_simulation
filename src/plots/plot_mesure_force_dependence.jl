using Plots
using QuadGK

const low = 0.4
const high = 0.5

function V(q::Float64, perturbation::Float64)

    value = 1.0 - cos(q)

    if low <= q <= high
        value += perturbation
    end

    return value
end

function density(q::Float64, F::Float64, perturbation::Float64)
    integrand(y) = exp(V(q + y, perturbation)) * exp(-F * y)
    quadrature = quadgk(integrand, 0, 1, rtol=1e-4)
    exp(-V(q, perturbation)) * quadrature[1]
end

function normalization(F::Float64, perturbation::Float64)
    integrand(q) = density(q, F, perturbation)
    quadgk(integrand, 0.0, 1.0)[1]
end

function plot_density(F::Float64, perturbation::Float64)

    z = normalization(F, perturbation)

    q = range(0, stop=1, length=10)

    label = F == 0 ? "F = 0, V = 1 - cos" : "F \\neq 0, V = 1 - \\cos"

    if perturbation != 0.0

        label *= " + $(perturbation) \\times " *
              "\\mathbf{1}_{[$(low),$(high)]}"
    end

    plot!(q, density.(q, F, perturbation) ./ z, label="\$" * label * "\$",
          legend=:topleft)

end

plot()

plot_density(0.0, 0.0)
plot_density(0.0, 0.1)

plot_density(10.0, 0.0)
plot_density(10.0, 0.1)
