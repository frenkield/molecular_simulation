include("../src/scheme.jl")

const rotor_chain_length = 1024
const temperature_left = 0.25
const temperature_right = 0.15
const external_force = 1.6
const iterations = 10

function test_performance()

    rotor_chain = RotorChain(rotor_chain_length)

    scheme = Scheme(rotor_chain, temperature_left, temperature_right, external_force)

    for i in 1:10000
        iterate!(scheme)
    end
end


@time test_performance()
@time test_performance()

using Profile

@profile test_performance()
Profile.print(sortedby=:count, format=:flat)
