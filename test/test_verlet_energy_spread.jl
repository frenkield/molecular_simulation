using Statistics
using Polynomials
using Test

include("../src/utils.jl")
include("../src/scheme.jl")

# ================================================

function compute_verlet_energy_spread()

    time_steps = []
    energy_spread_samples = []

    rotor_chain = RotorChain(100)
    energy_samples = zeros(1000)

    default_momenta = randn(length(rotor_chain))

    for time_step in range(0.01, stop=0.2, length=20)

        push!(time_steps, time_step)
        scheme = Scheme(rotor_chain, 0.0, 0.0, 0.0, time_step)

        for i in 1:length(rotor_chain)
            rotor_chain.rotors[i].p = default_momenta[i]
            rotor_chain.rotors[i].q = 0.0
        end

        println("se stabiliser - pas de temps = $(time_step)")

        # se stabiliser...
        for i in 1:100000
            iterate_verlet!(scheme)
        end

        # =====================================================

        println("echantillonner")

        for i in 1:length(energy_samples)
            energy_samples[i] = 0.0
        end

        # echantillonner...
        for i in 1:length(energy_samples)
            iterate_verlet!(scheme)
            energy_samples[i] = hamiltonian(rotor_chain)
        end

        energy_variance = var(energy_samples)
        energy_deviation = sqrt(energy_variance)

        push!(energy_spread_samples, energy_deviation)

    end

    return (time_steps, energy_spread_samples)

end

(time_steps, energy_spread_samples) = compute_verlet_energy_spread()

polynomial_fit = polyfit(log.(time_steps), log.(energy_spread_samples), 1)

@test polynomial_fit[1] ≈ 2.0 atol=0.1
