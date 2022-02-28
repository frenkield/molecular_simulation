using Test

include("../src/potential_temperature.jl")

@test potential_temperature_normalization(1.0) ≈ 2.9264539
@test potential_temperature_normalization(2.0) ≈ 4.0528761

@test potential_temperature(1.0) ≈ 0.5536100341034603

#@test hamiltonian(rotor_chain) ≈ 0.9194 atol=0.001
