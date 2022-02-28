include("../src/rotor_chain_sampler.jl")

rotor_chain = RotorChain(10)
sampler = RotorChainSampler(rotor_chain, 5, 0)

for i in 1:7

    add_sample!(sampler)

    if sampler.sample_ready
        @assert sampler.momenta_mean == [3.0, 6.0, 9.0, 12.0, 15.0, 18.0, 21.0, 24.0, 27.0, 30.0]
        @assert sampler.momenta_variance == [2.5, 10.0, 22.5, 40.0, 62.5, 90.0, 122.5, 160.0, 202.5, 250.0]
    end

    for i in 1:length(rotor_chain)
        rotor_chain.rotors[i].p += i
    end

end

