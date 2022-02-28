using Plots

include("../scheme.jl")
include("../rotor_chain_sampler.jl")
include("../sampler_utils.jl")
include("../potential_temperature.jl")

const external_force = 1.6
sample_count = 10^5
const temperature = 0.2

function sample_temperature(rotor_chain_length::Int, stabilization_iterations::Int)

    println("sampling chain with length $(rotor_chain_length)")
    rotor_chain = RotorChain(rotor_chain_length)

    scheme = Scheme(rotor_chain, temperature, temperature, external_force)
    scheme.hamiltonian.left_boundary_fixed = true
    scheme.hamiltonian.right_boundary_fixed = false

    println("stabilizing for $(stabilization_iterations) iterations")

    for iteration in 1:stabilization_iterations
        iterate!(scheme)
        if iteration % 1000000 == 0
            println("iteration $(iteration) of $(stabilization_iterations)")
        end
    end

    sampler = RotorChainSampler(rotor_chain, sample_count)

    while !sampler.sample_ready
        iterate!(scheme)
        add_sample!(sampler)
    end

    return sampler

end

function plot_scaled_temperature(temperature::Array, color::Int)
    scaled_position = range(0, stop=1, length=length(temperature))
    label="N = $(length(temperature))"
    display(plot!(scaled_position, temperature, label=label, color=color))
end

function plot_potential_temperature(sampler, color::Int)

    potential_temperatures =
        temperature_for_potential_energy.(sampler.potential_energies_mean)

    rotor_chain_length = length(potential_temperatures)
    scaled_position = range(0, stop=1, length=rotor_chain_length)

    display(plot!(scaled_position, potential_temperatures, label="",
                  color=color, linestyle=:dot, linewidth=2))

end

default(xlims=(0.0, 1.0), ylims=(0.0, 0.7), yticks=[0.0, 0.4, 0.8, 1.2, 1.6],
        xlabel="x = i/N", ylabel="temperature", legend=:bottomright)
plot()

stabilization_iterations = 10^6

sampler = sample_temperature(2^10, stabilization_iterations)
plot_scaled_temperature(sampler.momenta_variance, 1)
plot_potential_temperature(sampler, 1)
save_sampler(sampler, stabilization_iterations, sample_count)

# savefig("latex/slides/plots/temperature_scaled.pdf")
