using StaticArrays
include("rotor.jl")

const rotor_chain_max_length = 2^11

mutable struct RotorChain

    length::Int
    rotors::SArray{Tuple{rotor_chain_max_length}, Rotor, 1, rotor_chain_max_length}

    function RotorChain(length::Int)
        @assert length <= rotor_chain_max_length
        rotors = @SVector [Rotor() for i in 1:rotor_chain_max_length]
        return new(length, rotors)
    end

end

function Base.show(io::IO, rotor_chain::RotorChain)
    println(io, "RotorChain with $(length(rotor_chain.rotors)) rotors:")
    for i in 1:rotor_chain.length
        rotor = rotor_chain.rotors[i]
        println(io, " $(rotor)")
    end
end

Base.length(rotor_chain::RotorChain) = rotor_chain.length

# TODO - pourquoi cela pourri tant la performance ? meme avec @inbounds...
#Base.:getindex(rotor_chain::RotorChain, index::Int) = rotor_chain.rotors[index]
#Base.:firstindex(rotor_chain::RotorChain) = 1
#Base.:lastindex(rotor_chain::RotorChain) = length(rotor_chain.rotors)

function active(rotor_chain::RotorChain)
    any(rotor -> (rotor.q != 0 || rotor.p != 0), rotor_chain.rotors[1:rotor_chain.length])
end

function max_q(rotor_chain::RotorChain)
    maximum(rotor -> abs(rotor.q), rotor_chain.rotors)
end

first_rotor(rotor_chain::RotorChain) = rotor_chain.rotors[1]
last_rotor(rotor_chain::RotorChain) = rotor_chain.rotors[rotor_chain.length]