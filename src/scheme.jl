include("hamiltonian.jl")
include("thermostat.jl")

const gamma = 1.0

mutable struct Scheme

    rotor_chain::RotorChain
    thermostat_left::Thermostat
    thermostat_right::Thermostat
    external_force::Float64

    time_step::Float64
    half_time_step::Float64
    alpha::Float64

    hamiltonian::Hamiltonian
    forces::Array{Float64, 1}
    first_iteration::Bool

    function Scheme(rotor_chain::RotorChain, temperature_left::Float64,
                    temperature_right::Float64, external_force::Float64,
                    time_step = 0.05)

        half_time_step = time_step / 2.0
        alpha = exp(-gamma * time_step)

        thermostat_left = Thermostat(alpha, temperature_left)
        thermostat_right = Thermostat(alpha, temperature_right)

        scheme = new(rotor_chain, thermostat_left, thermostat_right, external_force,
                     time_step, half_time_step, alpha)

        scheme.hamiltonian = Hamiltonian()
        scheme.forces = zeros(rotor_chain.length)
        scheme.first_iteration = true

        return scheme

    end

end

function iterate_ornstein_uhlenbeck!(scheme::Scheme)

    rotor_chain = scheme.rotor_chain

    first_rotor(rotor_chain).p = (scheme.alpha * rotor_chain.rotors[1].p) +
                                 force(scheme.thermostat_left)

    last_rotor(rotor_chain).p = scheme.external_force +
                                (scheme.alpha * (last_rotor(rotor_chain).p - scheme.external_force)) +
                                force(scheme.thermostat_right)
end


function calculate_rotor_force(scheme::Scheme, rotor_index::Int)
   return -scheme.half_time_step *
          rotor_force(scheme.hamiltonian, scheme.rotor_chain, rotor_index)
end

##
# On peut faire les iterations en-place car \frac{\partial H}{\partial q}
# ne depend pas de p.
##
function iterate_verlet!(scheme::Scheme)

    rotor_chain = scheme.rotor_chain
    rotor_chain_length = length(rotor_chain)

    if scheme.first_iteration
        for i in 1:rotor_chain_length
            scheme.forces[i] = calculate_rotor_force(scheme, i)
        end
        scheme.first_iteration = false
    end

    # iteration p^{n + 1/2}
    for i in 1:rotor_chain_length
        rotor_chain.rotors[i].p += scheme.forces[i]
    end

    # iteration q^{n + 1}
    for i in 1:rotor_chain_length
        rotor_chain.rotors[i].q += scheme.time_step * rotor_chain.rotors[i].p
    end

    # iteration p^{n + 1}
    for i in 1:rotor_chain_length
        scheme.forces[i] = calculate_rotor_force(scheme, i)
        rotor_chain.rotors[i].p += scheme.forces[i]
    end

end

function iterate!(scheme::Scheme)
    iterate_ornstein_uhlenbeck!(scheme)
    iterate_verlet!(scheme)
end
