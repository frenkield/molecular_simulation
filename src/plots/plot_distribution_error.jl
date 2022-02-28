using Statistics
using StatsBase
using Plots
using LinearAlgebra
using Polynomials

include("../sampler_utils.jl")

function compute_distribution_errors(temperature_left::Float64, temperature_right::Float64)

    temperature_sample_count = 2000000
    stabilization_delay = 60

    (scheme, hot_rotor_index) =
        sample_and_find_hottest_rotor(temperature_left, temperature_right,
                                      nsamples=temperature_sample_count,
                                      delay=stabilization_delay)

    max_rotor = scheme.rotor_chain.rotors[hot_rotor_index]
    left_rotor = scheme.rotor_chain.rotors[hot_rotor_index - 1]

    errors = []

    for n in 13:18

        sample_count = 2^n
        println("sample count = $(sample_count)")

        momenta = zeros(sample_count)
        distances = zeros(sample_count)

        for i in 1:sample_count
            iterate!(scheme)
            momenta[i] = max_rotor.p
            distances[i] = max_rotor.q - left_rotor.q
        end

        error = compute_distribution_error(distances, momenta)
        push!(errors, error)

    end

    return errors

end

function compute_distribution_error(distances::Array{Float64,1}, momenta::Array{Float64,1})

    normalized_distances = map(distance -> normalize_position(distance), distances)

    momenta_histogram = normalize(fit(Histogram, momenta, nbins=75))
    distances_histogram = normalize(fit(Histogram, normalized_distances, nbins=75))
    joint_histogram = normalize(fit(Histogram, (normalized_distances, momenta), nbins=75))

    momenta_density = momenta_histogram.weights
    distances_density = distances_histogram.weights
    joint_density = joint_histogram.weights

    tensor_density = distances_density * momenta_density'

    error = abs.(tensor_density - joint_density)

    error_integral = sum(error) * momenta_histogram.edges[1].step.hi *
                     distances_histogram.edges[1].step.hi

    return error_integral

#    display(surface(error))

end

errors = compute_distribution_errors(0.2, 0.2)
println("errors = $(errors)")


n = [2^n for n in 13:18]
dn = [28.7 * a^(-0.494) for a in n]

display(plot(xlabel="\$ \\log_2 n \$"))
display(plot!(log2.(n), log2.(dn), label="\$ 28.7 \\times n^{-0.494} \$"))
display(plot!(log2.(n), log2.(errors), label="\$ \\log_2 \\delta_n \$"))

f = polyfit(log.(n), log.(errors), 1)


# 1 : Poly(3.8622406346701825 - 0.5060503305796568*x)
# 2 : Poly(3.6623268402959557 - 0.4911193304405179*x)