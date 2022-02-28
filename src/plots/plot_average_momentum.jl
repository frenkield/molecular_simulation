include("../scheme.jl")
include("../plots.jl")
include("../rotor_chain_sampler.jl")

const external_force = 1.6

const sample_count = 1000000
const stabilisation_delay = 30

function plot_average_momentum(temperature_left::Float64, temperature_right::Float64)

    rotor_chain = RotorChain(1024)

    scheme = Scheme(rotor_chain, temperature_left, temperature_right, external_force)
    scheme.hamiltonian.left_boundary_fixed = true
    scheme.hamiltonian.right_boundary_fixed = false

    sampler = RotorChainSampler(rotor_chain, sample_count, stabilisation_delay)

    while !sampler.sample_ready
        iterate!(scheme)
        add_sample!(sampler)
    end

    label="\$ T_L = $(temperature_left), T_R = $(temperature_right) \$"
    display(plot!(sampler.momenta_mean, label=label))

end

default(ylims=(0, 2), xlabel="site", ylabel="average momentum", legend=:topleft)
plot()

plot_average_momentum(0.25, 0.2)
plot_average_momentum(0.25, 0.15)

plot_average_momentum(0.2, 0.2)
plot_average_momentum(0.2, 0.15)

plot_average_momentum(0.15, 0.25)
plot_average_momentum(0.15, 0.15)

# savefig("latex/plots/average_momentum.pdf")
