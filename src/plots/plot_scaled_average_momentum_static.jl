using Plots

function plot_scaled_average_momenta(average_momentum::Array, color::Int, rotor_chain_length::Int)
    scaled_position = range(0, stop=1, length=length(average_momentum))
    label="N = $(rotor_chain_length)"
    display(plot!(scaled_position, average_momentum, label=label, color=color))
end

function plot_average_momenta(rotor_chain_length::Int, color::Int)

    include("../../data/rotor_chain-$(rotor_chain_length).txt")
    increment = div(length(momenta_variance), 128)

    average_momenta_small = momenta_mean[1:increment:end]
    plot_scaled_average_momenta(average_momenta_small, color, length(momenta_mean))

end

default(xlims=(0.0, 1.0), ylims=(0.0, 1.6),
        xlabel="x = i/N", ylabel="average momentum", legend=:bottomright)

display(plot())

plot_average_momenta(128, 1)
plot_average_momenta(256, 2)
plot_average_momenta(512, 3)

plot_average_momenta(1024, 4)

plot_average_momenta(2048, 5)

# plot_average_momenta(4096, 6)

plot_average_momenta(8192, 7)

# savefig("latex/slides/plots/average_momentum_scaled.pdf")
