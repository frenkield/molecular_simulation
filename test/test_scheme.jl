using Test
include("../src/scheme.jl")

rotor_chain = RotorChain(3)
scheme = Scheme(rotor_chain, 1.0, 1.0, 0.0)
iterate_ornstein_uhlenbeck!(scheme)
@test rotor_chain.rotors[2].q == 0 && rotor_chain.rotors[2].p == 0
@test rotor_chain.rotors[1].p != 0 && last_rotor(rotor_chain).p != 0

rotor_chain = RotorChain(3)
iterate_verlet!(scheme)
@test !active(rotor_chain)

rotor_chain = RotorChain(3)
rotor_chain.rotors[1].p = 1.0
iterate_verlet!(scheme)
@test active(rotor_chain)
