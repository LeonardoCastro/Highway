type Vehicle
    speed::Int8
    position::Int64
    tipo::Int8
    change::Int8
    num::Int64
    len::Int64
end

type Highway1D
	count::Int64
	N::Int64
	highway::Vector{Vehicle}
end

function Highway1D(N::Int64)
    highway = Vehicle[]
    for i in 1:N
        cell = Vehicle(round(Int8, -1), i, round(Int8, -1), zero(Int8), 0, 0)
        push!(highway, cell)
    end
    return Highway1D(0, N, highway)
end

type Highway2D
  lanes::Int8
  highway::Vector{Highway1D}
end

function Highway2D(lanes::Int64, N::Int64)
    C = Highway1D[]
    if lanes > 1
        for i = 1:lanes
            push!(C, Highway1D(N))
        end
        return Highway2D(round(Int8,lanes), C)
    end
    if lanes == 1
        return Highway1D(N)
    end
    if lanes < 1
      println("There must be at least one lane!")
    end
end
