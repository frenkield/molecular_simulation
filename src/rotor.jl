mutable struct Rotor

    q::Float64
    p::Float64
    temperature::Float64

    function Rotor()
        Rotor(0.0)
    end

    function Rotor(q::Float64)
        new(q, 0.0, 0.0)
    end

end

function Base.show(io::IO, rotor::Rotor)
    print(io, "[Rotor: q = $(rotor.q), p = $(rotor.p)]")
end

# on suppose que la masse du rotor est 1
function kinetic_energy(rotor::Rotor)
    (rotor.p ^ 2) / 2
end

function normalize_position(position::Float64)
    return mod(position, 2pi)
end

function normalize_position(rotor::Rotor)
    return normalize_position(rotor.q)
end
