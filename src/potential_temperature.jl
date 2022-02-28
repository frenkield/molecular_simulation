using DataStructures
using QuadGK

function compute_potential_energy(temperature::Float64)

    weight_function(r::Float64) = (1 - cos(r)) * exp((cos(r) - 1) / temperature)
    weight = quadgk(weight_function, 0, 2pi)[1]

    return weight / potential_energy_normalization(temperature)

end

function potential_energy_normalization(temperature::Float64)
    normalization_function(r::Float64) = exp((cos(r) - 1) / temperature)
    quadgk(normalization_function, 0, 2pi)[1]
end

# =====================================================================

potential_energy_to_temperature_map = SortedDict{Float64, Float64}()

for temperature in range(0, stop=0.7, length=100)

    if temperature == 0
        continue
    end

    energy = compute_potential_energy(temperature)
    potential_energy_to_temperature_map[energy] = temperature
end

potential_energy_to_temperature_keys =
    collect(keys(potential_energy_to_temperature_map))

# TODO - c'est moche, ca
function temperature_for_potential_energy(potential_energy::Float64)

    index = findfirst(energy -> energy >= potential_energy,
                      potential_energy_to_temperature_keys)

    if index == nothing
        return potential_energy_to_temperature_map[end]
    end

    potential_energy = potential_energy_to_temperature_keys[index]
    temperature = potential_energy_to_temperature_map[potential_energy]

    return potential_energy_to_temperature_map[potential_energy]
end


#=
The local potential temperature at bond i is then defined as
the value T_i such that g(T_i) is equal to the

time average of the potential energy of the bond r_i along the trajectory

defined by (2).
=#