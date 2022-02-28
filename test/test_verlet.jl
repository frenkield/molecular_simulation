include("../src/utils.jl")
include("../src/scheme.jl")

function verify_energy_conservation(scheme::Scheme, iterations::Int, show_plot=false)

    rotor_chain = scheme.rotor_chain

    start_energy = hamiltonian(rotor_chain)
    println("start energy = $(start_energy)")

    for i in 1:iterations

        iterate_verlet!(scheme)

        if show_plot && i % 100 == 0
            display(plot(rotor_chain))
        end
    end

    end_energy = hamiltonian(rotor_chain)
    println("end energy = $(end_energy), max position = $(max_q(rotor_chain))\n")

    @assert(relative_error(start_energy, end_energy) < 0.001)

end

# ================================================

rotor_chain = RotorChain(100)
rotor_chain.rotors[1].p = 1.0
scheme = Scheme(rotor_chain, 0.0, 0.0, 0.0)
verify_energy_conservation(scheme, 1000)

# ================================================

rotor_chain = RotorChain(100)
rotor_chain.rotors[1].p = 10.0
scheme = Scheme(rotor_chain, 0.0, 0.0, 0.0)
verify_energy_conservation(scheme, 1000)
@assert isapprox(hamiltonian(rotor_chain), 50.0, atol=0.01)

# ================================================

rotor_chain = RotorChain(1024)

for rotor in rotor_chain.rotors
    rotor.p = randn()
end

scheme = Scheme(rotor_chain, 0.0, 0.0, 0.0)
verify_energy_conservation(scheme, 10000, false)

# ================================================

rotor_chain = RotorChain(5)
rotor_chain.rotors[1].p = 1.0
scheme = Scheme(rotor_chain, 0.0, 0.0, 0.0)

for i in 1:10
    iterate_verlet!(scheme)
end

q = []
p = []

for i in 1:5
    push!(q, rotor_chain.rotors[i].q)
    push!(p, rotor_chain.rotors[i].p)
end

expected_q = [0.46040496660835795, 0.019443728165496818, 0.0002382732482450807,
              1.3054835446322517e-6, 3.842626110820576e-9]

expected_p = [0.7667621016065724, 0.11301023467619278, 0.0024380461451007766,
              1.987945098889801e-5, 8.18279395185621e-8]

@assert q == expected_q
@assert p == expected_p

# ================================================

rotor_chain = RotorChain(5)
rotor_chain.rotors[1].p = 1.0
scheme = Scheme(rotor_chain, 0.0, 0.0, 0.0)
scheme.hamiltonian.right_boundary_fixed = true

for i in 1:10
    iterate_verlet!(scheme)
end

q = []
p = []

for i in 1:5
    push!(q, rotor_chain.rotors[i].q)
    push!(p, rotor_chain.rotors[i].p)
end

expected_q = [0.46040496660835795, 0.019443728165496818, 0.0002382732482450848,
              1.3054835514157813e-6, 3.849220528448527e-9]

expected_p = [0.7667621016065724, 0.11301023467619278, 0.002438046145101019,
              1.9879451263582695e-5, 8.202061657774632e-8]

#@assert q == expected_q
#@assert p == expected_p

# ================================================

rotor_chain = RotorChain(100)
rotor_chain.rotors[1].p = 10.0
scheme = Scheme(rotor_chain, 0.0, 0.0, 0.0)
scheme.hamiltonian.right_boundary_fixed = true
verify_energy_conservation(scheme, 1000)
@assert isapprox(hamiltonian(rotor_chain), 50.0, atol=0.01)

# ================================================


