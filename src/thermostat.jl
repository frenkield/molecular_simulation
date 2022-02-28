using Random

struct Thermostat

    temperature::Float64
    sigma::Float64

    function Thermostat(alpha::Float64, temperature::Float64 = 0.0)
        sigma = sqrt((1 - alpha^2) * temperature)
        new(temperature, sigma)
    end

end

function force(thermostat::Thermostat)
    force = thermostat.sigma * randn()

   # println("sigma = $(thermostat.sigma), force = $(force)")

    return force

end

function Base.show(io::IO, thermostat::Thermostat)
    print(io, "Thermostat $(thermostat.temperature) degrees")
end
