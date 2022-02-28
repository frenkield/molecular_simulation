using Test

include("../src/hamiltonian.jl")
include("../src/rotor_chain.jl")

hamiltonien = Hamiltonian()

rotor_chain = RotorChain(3)
@assert(hamiltonian(rotor_chain) == 0.0)

rotor_chain.rotors[1].p = 1
@assert(hamiltonian(rotor_chain) == 0.5)

rotor_chain.rotors[1].p = 0
rotor_chain.rotors[1].q = 1
@test hamiltonian(rotor_chain) ≈ 0.9194 atol=0.001

rotor_chain.rotors[1].p = 1
rotor_chain.rotors[1].q = 1
@assert(isapprox(hamiltonian(rotor_chain), 1.419, atol=0.001))

rotor_chain = RotorChain(3)
@assert(rotor_force(hamiltonien, rotor_chain, 1) == 0)
@assert(rotor_force(hamiltonien, rotor_chain, 2) == 0)
@assert(rotor_force(hamiltonien, rotor_chain, 3) == 0)

rotor_chain = RotorChain(3)
rotor_chain.rotors[1].p = 1
@assert(rotor_force(hamiltonien, rotor_chain, 1) == 0)
@assert(rotor_force(hamiltonien, rotor_chain, 2) == 0)
@assert(rotor_force(hamiltonien, rotor_chain, 3) == 0)

# =========================================================

rotor_chain = RotorChain(3)
rotor_chain.rotors[1].q = 1
@assert(isapprox(rotor_force(hamiltonien, rotor_chain, 1), 1.683, atol=0.001))
@assert(isapprox(rotor_force(hamiltonien, rotor_chain, 2), -0.8415, atol=0.001))
@assert(rotor_force(hamiltonien, rotor_chain, 3) == 0)

rotor_chain = RotorChain(3)
rotor_chain.rotors[3].q = 1
@test rotor_force(hamiltonien, rotor_chain, 1) == 0

@test rotor_force(hamiltonien, rotor_chain, 2) ≈ -0.8415 atol=0.001

println(rotor_force(hamiltonien, rotor_chain, 2))
println("il y a une bogue là")

#@test rotor_force(hamiltonien, rotor_chain, 2) ≈ -0.8415 atol=0.001
#@test isapprox(rotor_force(hamiltonien, rotor_chain, 1), 1.683, atol=0.001)

# =========================================================

rotor_chain = RotorChain(3)
rotor_chain.rotors[1].q = pi / 2
rotor_chain.rotors[1].p = 2
@test compute_energy_current(rotor_chain) ≈ 0.333 atol=0.001

rotor_chain = RotorChain(3)
rotor_chain.rotors[1].q = pi / 2
rotor_chain.rotors[1].p = 2
rotor_chain.rotors[3].q = pi / 2
rotor_chain.rotors[3].p = 2
@test compute_energy_current(rotor_chain) ≈ 0.0 atol=0.001
