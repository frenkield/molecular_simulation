using Plots

include("../utils.jl")
include("../scheme.jl")

function sample_energy(rotor_chain::RotorChain, sample_count::Int, sample_frequency::Int)

    scheme = Scheme(rotor_chain, 0.0, 0.0, 0.0)
    energy_samples = []

    for i in 1:sample_count

        iterate_verlet!(scheme)

        if i % sample_frequency == 0
            push!(energy_samples, hamiltonian(rotor_chain))
        end

    end

    return energy_samples

end

rotor_chain = RotorChain(1024)

for rotor in rotor_chain.rotors
    rotor.p = randn()
    rotor.q = randn()
end

sample_count = 10^6
sample_frequency = 1000

energy_samples = sample_energy(rotor_chain, sample_count, sample_frequency)

ylims = compute_plot_limits(energy_samples, 2.0)

default(xlabel="iteration", ylabel="energy", ylims=ylims)

iterations = sample_frequency:sample_frequency:sample_count
display(plot(iterations, energy_samples, legend=false))