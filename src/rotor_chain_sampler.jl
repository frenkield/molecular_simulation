using OnlineStats
include("rotor_chain.jl")

mutable struct RotorChainSampler

    rotor_chain::RotorChain
    period_in_seconds::Float64
    last_run_time::Float64
    current_sample_index::Int
    sample_count::Int
    active::Bool
    sample_ready::Bool

    momenta_stats
    momenta_mean::Array{Float64}
    momenta_variance::Array{Float64}

    sample_potential_energy::Bool
    potential_energy_stats
    potential_energies_mean::Array{Float64}

    function RotorChainSampler(rotor_chain::RotorChain, sample_count = 10, period_in_seconds = 0.0)

        sampler = new(rotor_chain, period_in_seconds, time())
        sampler.sample_count = sample_count
        sampler.sample_ready = false

        sampler.momenta_stats = [Series(Mean(), Variance()) for i in 1:rotor_chain.length]
        sampler.potential_energy_stats = [Series(Mean()) for i in 1:rotor_chain.length]

        sampler.sample_potential_energy = true

        return sampler
    end

end

function add_sample!(sampler::RotorChainSampler)

    @assert !sampler.sample_ready

    if sampler.active

        rotors = sampler.rotor_chain.rotors
        rotor_chain_length = sampler.rotor_chain.length

        if sampler.current_sample_index <= sampler.sample_count

            # TODO - c'est un peu moche
            sampler.sample_ready = false

            for i in 1:rotor_chain_length

                fit!(sampler.momenta_stats[i], rotors[i].p)

                if sampler.sample_potential_energy
                    distance = i == 1 ? rotors[i].q : rotors[i].q - rotors[i - 1].q
                    potential_energy = 1 - cos(distance)
                    fit!(sampler.potential_energy_stats[i], potential_energy)
                end
            end

            sampler.current_sample_index += 1

        else

            println("sample finished")

            sampler.sample_ready = true
            sampler.active = false
            sampler.last_run_time = time()

            sampler.momenta_mean = zeros(rotor_chain_length)
            sampler.momenta_variance = zeros(rotor_chain_length)
            sampler.potential_energies_mean = zeros(rotor_chain_length)

            for i in 1:rotor_chain_length

                sampler.momenta_mean[i] = value(sampler.momenta_stats[i].stats[1])
                sampler.momenta_variance[i] = value(sampler.momenta_stats[i].stats[2])

                if sampler.sample_potential_energy
                    sampler.potential_energies_mean[i] =
                        value(sampler.potential_energy_stats[i].stats[1])
                end

            end

        end

    elseif time() - sampler.last_run_time > sampler.period_in_seconds
        println("activating sampler - starting at next sample")
        sampler.active = true
        sampler.current_sample_index = 1
    end

end
