using Statistics

include("../scheme.jl")
include("../plots.jl")
include("../rotor_chain_sampler.jl")
include("../histogram_sampler.jl")

const external_force = 1.6

const sample_count = 1000000
const stabilisation_delay = 30

function generate_histogram(temperature_left::Float64, temperature_right::Float64)

    rotor_chain = RotorChain(1024)
    scheme = Scheme(rotor_chain, temperature_left, temperature_right, external_force)
    sampler = RotorChainSampler(rotor_chain, sample_count, stabilisation_delay)

    while !sampler.sample_ready
        iterate!(scheme)
        add_sample!(sampler)
    end

    temperature = maximum(sampler.momenta_variance)
    rotor_index = findfirst(t -> t == temperature, sampler.momenta_variance)
    rotor = rotor_chain.rotors[rotor_index]

    println("max temperature at rotor $(rotor_index)")
    momenta = zeros(sample_count)

    for i in 1:sample_count
        iterate!(scheme)
        momenta[i] = rotor.p
    end

    return (temperature, momenta)

end

(temperature, momenta) = generate_histogram(0.2, 0.2)
average_momentum = mean(momenta)

plot()
default(xlabel="momentum", ylabel="density")

histogram(momenta, normed=true, label="data histogram", bins=75)

density(momentum) = exp(-(momentum - average_momentum)^2 / (2*temperature)) /
                    sqrt(2pi * temperature)

momenta_range = range(-2.0, stop=4.0, length=100)
plot!(momenta_range, density.(momenta_range), lw=4, label="reference density")

#    savefig("latex/plots/gibbs_momentum.pdf")
