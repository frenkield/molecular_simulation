using Plots
include("../potential_temperature.jl")

function plot_scaled_temperature(temperature::Array, color::Int, rotor_chain_length::Int)
    scaled_position = range(0, stop=1, length=length(temperature))
    label="N = $(rotor_chain_length)"
    display(plot!(scaled_position, temperature, label=label, color=color))
end

function plot_potential_temperature(potential_energies_mean, color::Int)

    potential_temperatures =
        temperature_for_potential_energy.(potential_energies_mean)

    scaled_position = range(0, stop=1, length=length(potential_temperatures))

    display(plot!(scaled_position, potential_temperatures, label="",
                  color=color, linestyle=:dot, linewidth=2))
end

function plot_temperatures(rotor_chain_length::Int, color::Int)

    include("../../data/rotor_chain-$(rotor_chain_length).txt")
    increment = div(length(momenta_variance), 128)

    momenta_variance_small = momenta_variance[1:increment:end]
    potential_energies_mean_small = potential_energies_mean[1:increment:end]

    plot_scaled_temperature(momenta_variance_small, color, length(momenta_variance))
    plot_potential_temperature(potential_energies_mean_small, color)
end

default(xlims=(0.0, 1.0), ylims=(0.15, 0.7),
        xlabel="x = i/N", ylabel="kinetic and potential temperatures")

display(plot())

plot_temperatures(128, 1)

plot_temperatures(512, 2)

plot_temperatures(2048, 3)

plot_temperatures(8192, 4)

# savefig("latex/slides/plots/temperature_scaled.pdf")
