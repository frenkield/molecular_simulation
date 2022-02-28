include("scheme.jl")
include("rotor_chain_sampler.jl")

function sample_and_find_hottest_rotor(temperature_left::Float64, temperature_right::Float64;
                                       force = 1.6, nsamples = 100000, delay = 3)

    rotor_chain = RotorChain(1024)
    scheme = Scheme(rotor_chain, temperature_left, temperature_right, force)
    sampler = RotorChainSampler(rotor_chain, nsamples, delay)

    while !sampler.sample_ready
        iterate!(scheme)
        add_sample!(sampler)
    end

    max_temperature = maximum(sampler.momenta_variance)
    max_rotor_index = findfirst(t -> t == max_temperature, sampler.momenta_variance)

    println("max temperature at rotor $(max_rotor_index)")
    return (scheme, max_rotor_index, max_temperature)

end

function save_sampler(sampler::RotorChainSampler, stabilization_iterations::Int,
                      sample_count::Int)

    rotor_chain_length = sampler.rotor_chain.length
    filename = "data/rotor_chain-$(rotor_chain_length).txt"

    open(filename, "w") do io

        println(io, "rotor_chain_length = $(rotor_chain_length)")
        println(io, "iterations = $(stabilization_iterations + sample_count)")
        println(io, "sample_count = $(sample_count)")
        println(io, "")

        println(io, "momenta_mean = $(sampler.momenta_mean)")
        println(io, "momenta_variance = $(sampler.momenta_variance)")
        println(io, "potential_energies_mean = $(sampler.potential_energies_mean)")
        println(io, "")

        positions = map(rotor -> rotor.q, sampler.rotor_chain.rotors[1:rotor_chain_length])
        momenta = map(rotor -> rotor.p, sampler.rotor_chain.rotors[1:rotor_chain_length])
        println(io, "positions = $(positions)")
        println(io, "momenta = $(momenta)")

    end

end

function continue_sample(data_filename::String, new_stabilization_iterations::Int,
                         new_sample_count::Int)

    include(data_filename)
    println("iterations so far $(iterations)")

    rotor_chain = RotorChain(rotor_chain_length)

    for i in 1:rotor_chain_length
        rotor_chain.rotors[i].q = positions[i]
        rotor_chain.rotors[i].p = momenta[i]
    end

    scheme = Scheme(rotor_chain, 0.2, 0.2, 1.6)
    scheme.hamiltonian.left_boundary_fixed = true
    scheme.hamiltonian.right_boundary_fixed = false

    println("stabilizing for $(new_stabilization_iterations) iterations")

    for iteration in 1:new_stabilization_iterations
        iterate!(scheme)
    end

    sampler = RotorChainSampler(rotor_chain, new_sample_count)
    sampler_iterations = 1

    while !sampler.sample_ready

        iterate!(scheme)
        add_sample!(sampler)

        sampler_iterations += 1
        if sampler_iterations % 100000 == 0
            println("$(sampler_iterations) of $(new_sample_count)")
        end

    end

    stabilization_iterations = iterations + new_stabilization_iterations
    save_sampler(sampler, stabilization_iterations, new_sample_count)

    return sampler

end
