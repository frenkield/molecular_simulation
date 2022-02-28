include("../src/rotor_chain.jl")

rotor_chain = RotorChain(3)
rotor_chain.rotors[1].q = 1.0

@assert(rotor_chain[1].q == 1.0)
