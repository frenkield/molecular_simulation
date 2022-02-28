using Statistics
using Plots

include("../sampler_utils.jl")

function generate_samples(temperature_left::Float64, temperature_right::Float64)

    temperature_sample_count = 10^6
    stabilization_delay = 30

    (scheme, hot_rotor_index, temperature) =
        sample_and_find_hottest_rotor(temperature_left, temperature_right,
                                      nsamples=temperature_sample_count,
                                      delay=stabilization_delay)

    hot_rotor = scheme.rotor_chain.rotors[hot_rotor_index]
    left_rotor = scheme.rotor_chain.rotors[hot_rotor_index - 1]
    right_rotor = scheme.rotor_chain.rotors[hot_rotor_index + 1]

    distance_sample_count = 10^5
    distances = zeros(distance_sample_count)

    for i in 1:distance_sample_count
        iterate!(scheme)
        distances[i] = hot_rotor.q - left_rotor.q
    end

    return (distances, temperature)

end

(distances, temperature) = generate_samples(0.2, 0.2)

normalized_distances = map(distance -> normalize_position(distance), distances)
bin_count = 75

plot()
default(xlabel="distance", ylabel="density", legend=:top)
histogram(normalized_distances, normed=true, label="data histogram", bins=bin_count)

# ===========================================================================

density(distance) = exp(-(1 - cos(distance)) / temperature)

distance_range = range(0, stop=2pi, length=bin_count)
distance_density = density.(distance_range)

norm_distance_density = sum(distance_density) * 2pi / bin_count

normed_distance_density = distance_density / norm_distance_density
plot!(distance_range, normed_distance_density, lw=4, label="reference density")

