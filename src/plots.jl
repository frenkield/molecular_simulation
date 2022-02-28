using Plots
include("hamiltonian.jl")

function RecipesBase.plot(rotor_chain::RotorChain; type="momentum")

    data = zeros(length(rotor_chain))

    if type == "temperature"
        label = "temp"
        for i in 1:rotor_chain.length
            data[i] = temperature(rotor_chain, i)
        end

    elseif type == "position"
        label = "q"
        for i in 1:length(rotor_chain)
            data[i] = rotor_chain.rotors[i].q
        end

    elseif type == "normalized_position"
        label = "q"
        for i in 1:length(rotor_chain)
            data[i] = normalize_position(rotor_chain.rotors[i])
        end

    elseif type == "rotor_force"

        label = "rotor_force"
        data = zeros(length(rotor_chain))

        for i in 1:length(rotor_chain)
            data[i] = rotor_force(rotor_chain, i)
        end

    elseif type == "smoothed_momentum"

        smoothed_rotor_chain = RotorChain(rotor_chain.length)

        for i in 1:rotor_chain.length

            for j in max(i - 2, 1) : min(i + 2, rotor_chain.length)
                smoothed_rotor_chain.rotors[i].p += rotor_chain.rotors[j].p
            end

            smoothed_rotor_chain.rotors[i].p /= 5

        end

        data = map(rotor -> rotor.p, smoothed_rotor_chain.rotors)

        label = "smoothed p"

    else
        label = "\$p\$"

        data = zeros(length(rotor_chain))
        for i in 1:length(rotor_chain)
            data[i] = rotor_chain.rotors[i].p
        end
    end

    plot(data, seriestype=:scatter, label=label)

#    positions = map(rotor -> rotor.q, rotor_chain.rotors)
#    temperatures = map(rotor -> rotor.temperature, rotor_chain.rotors)
#    normalized_qs = map(rotor -> normalized_q(rotor), rotor_chain.rotors)



#    p = plot(positions, seriestype=:scatter, label="q")
#    plot!(p, momenta, seriestype=:scatter, label="p")


end
