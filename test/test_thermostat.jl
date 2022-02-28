include("../src/thermostat.jl")

gamma = 1.0
time_step = 1.0

alpha = exp(-gamma * time_step)

thermostat = Thermostat(alpha)
println(force(thermostat))

thermostat = Thermostat(alpha, 1.0)
println(force(thermostat))

thermostat = Thermostat(alpha, 10.0)
println(force(thermostat))

thermostat = Thermostat(alpha, 100.0)
println(force(thermostat))
