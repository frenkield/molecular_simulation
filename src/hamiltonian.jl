include("rotor_chain.jl")

mutable struct Hamiltonian

    left_sin::Float64
    right_sin::Float64
    left_boundary_fixed::Bool
    right_boundary_fixed::Bool

    Hamiltonian() = new(0.0, 0.0, true, false)
end

function hamiltonian(rotor_chain::RotorChain)

    energy = 0.0
    previous_q = 0.0

    for i in 1:length(rotor_chain)

        rotor::Rotor = rotor_chain.rotors[i]

        energy += kinetic_energy(rotor)
        energy += 1 - cos(rotor.q - previous_q)

        previous_q = rotor.q

    end

    return energy

end

#==
 = \frac{\partial H}{\partial q} ne depend pas de p
 =
 = TODO - il y a une bogue là - on change les valeurs de left_sin et right_sin
 =        donc c'est plutot rotor_force!
 =#
function rotor_force(hamiltonian::Hamiltonian, rotor_chain::RotorChain,
                     rotor_index::Integer)

    rotors = rotor_chain.rotors

    if rotor_index == 1

        @fastmath hamiltonian.right_sin = sin(rotors[2].q - rotors[1].q)

        if hamiltonian.left_boundary_fixed
            @fastmath hamiltonian.left_sin = sin(rotors[1].q)
        else
            hamiltonian.left_sin = 0.0
        end

    elseif rotor_index == length(rotor_chain)

        hamiltonian.left_sin = hamiltonian.right_sin

        if hamiltonian.right_boundary_fixed
            @fastmath hamiltonian.right_sin = -sin(rotors[rotor_index].q)
        else
            hamiltonian.right_sin = 0.0
        end

    else

        rotor_q = rotors[rotor_index].q
        rotor_right_q = rotors[rotor_index + 1].q

        hamiltonian.left_sin = hamiltonian.right_sin
        @fastmath hamiltonian.right_sin = sin(rotor_right_q - rotor_q)

    end

    hamiltonian.left_sin - hamiltonian.right_sin

end

function compute_energy_current(positions::Array{Float64}, momenta::Array{Float64})

    energy_current = 0.0

    for i in 1:length(positions) - 1

        @fastmath energy_current += -sin(positions[i + 1] - positions[i]) *
                                    (momenta[i + 1] + momenta[i]) / 2
    end

    return energy_current / length(positions)

end

# stoltz hors equilibre - page 42
function compute_energy_current(rotor_chain::RotorChain)

    energy_current = 0.0

    for i in 1:rotor_chain.length - 1

        rotor = rotor_chain.rotors[i]
        next_rotor = rotor_chain.rotors[i + 1]

        @fastmath energy_current += -sin(next_rotor.q - rotor.q) *
                                    (next_rotor.p + rotor.p) / 2

    end

    return energy_current / rotor_chain.length

end
