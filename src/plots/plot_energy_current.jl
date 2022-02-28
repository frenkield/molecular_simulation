using OnlineStats
include("../scheme.jl")
include("../plots.jl")

const stabilization_count = 10^4
const sample_count = 10^6

const rotor_count = 128
const forces = 0.0 : 0.1 : 2.4

function compute_energy_current(temperature_left::Float64, temperature_right::Float64,
                                rotor_chain_length::Int, external_force::Float64)

    rotor_chain = RotorChain(rotor_chain_length)
    scheme = Scheme(rotor_chain, temperature_left, temperature_right, external_force)

    scheme.hamiltonian.left_boundary_fixed = true
    scheme.hamiltonian.right_boundary_fixed = false

    # println("stabilizing...")
    for i in 1:stabilization_count
        iterate!(scheme)
    end

    stats = Series(Mean())

    scaled_sample_count = sample_count * 10^(external_force/2.4)
    # println("sampling - scaled sample count = $(scaled_sample_count)")

    for i in 1:scaled_sample_count
        iterate!(scheme)
        fit!(stats, compute_energy_current(rotor_chain))
    end

    return value(stats.stats[1])
end

function compute_energy_currents(temperature_left::Float64, temperature_right::Float64,
                                 rotor_chain_length::Int)

    energy_currents = []

    for force in forces

        println("force = $(force)")

        energy_current = compute_energy_current(temperature_left, temperature_right,
                                                rotor_chain_length, force)

        push!(energy_currents, energy_current)

#        label="\$ T_L = $(temperature_left), T_R = $(temperature_right) \$"
#        display(plot(forces, energy_currents))

    end

    println("$(temperature_left), $(temperature_right), $(rotor_chain_length)")
    println(energy_currents)

    return energy_currents

end

default(xlims=(0.0, 2.5), ylims=(-0.06, 0.02), xlabel="force", ylabel="current")
plot()

energy_currents = compute_energy_currents(0.15, 0.25, rotor_count)
display(plot!(forces, energy_currents))

energy_currents = compute_energy_currents(0.15, 0.15, rotor_count)
display(plot!(forces, energy_currents))

# energy_currents = compute_energy_currents(0.25, 0.15, rotor_count)
# display(plot!(forces, energy_currents))

# energy_currents = compute_energy_currents(0.2, 0.15, rotor_count)
