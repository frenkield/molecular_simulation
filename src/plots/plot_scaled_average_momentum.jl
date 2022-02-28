include("../scheme.jl")
include("../plots.jl")
include("../rotor_chain_sampler.jl")

const external_force = 1.6
const temperature_left = 0.2
const temperature_right = 0.2

const sample_count = 1e5

function sample_average_momentum(rotor_chain_length::Int, stabilisation_iterations::Int)

    rotor_chain = RotorChain(rotor_chain_length)

    scheme = Scheme(rotor_chain, temperature_left, temperature_right, external_force)
    scheme.hamiltonian.left_boundary_fixed = true
    scheme.hamiltonian.right_boundary_fixed = false

    println("stabilizing for $(stabilisation_iterations) iterations")

    for iteration in 1:stabilisation_iterations
        iterate!(scheme)
        if iteration % 1000000 == 0
            println("iteration $(iteration) of $(stabilisation_iterations)")
        end
    end

    sampler = RotorChainSampler(rotor_chain, sample_count, 0)

    while !sampler.sample_ready
        iterate!(scheme)
        add_sample!(sampler)
    end

    return sampler.momenta_mean

end

function plot_average_momentum(rotor_chain_length::Int, stabilisation_iterations = 1e6)

    println("length $(rotor_chain_length)")
    average_momentum = sample_average_momentum(rotor_chain_length, stabilisation_iterations)

    open("data/scaled_average_momentum.txt", "a") do io
        println(io, "# stabilisation_iterations = $(stabilisation_iterations)")
        print(io, "momenta_$(rotor_chain_length) = ")
        println(io, average_momentum)
        println(io, "")
    end

    scaled_position = range(0, stop=1, length=rotor_chain_length)

    label="N = $(rotor_chain_length)"
    display(plot!(scaled_position, average_momentum, label=label))

end

# default(xlims=(0.0, 1.0), ylims=(0.0, 1.6), yticks=[0.0, 0.4, 0.8, 1.2, 1.6],
#        xlabel="x = i/N", ylabel="average momentum", legend=:bottomright)

# plot()


# savefig("latex/slides/plots/scaled_average_momentum.pdf")
