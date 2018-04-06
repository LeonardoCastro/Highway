### Function making an empty cell
function Empty_Cell!(v::Vehicle)
    v.speed = Int8(-1)
    v.tipo = Int8(-1)
    v.change = Int8(0)
    v.num = 0
    v.len = 0
end

## Function making an obstacle cell
function Obstacle!(v::Vehicle)
    v.speed = Int8(-1)
    v.tipo = Int8(-2)
    v.change = Int8(0)
    v.num = Int8(0)
    v.len = 0
end

## Function changing the values of a vehicle
function Change_Vehicle!(v, speed, pos, tipo, change, num, length)
    v.speed = Int8(speed)
    v.position = Int64(pos)
    v.tipo = Int8(tipo)
    v.change = Int8(change)
    v.num = num
    v.len = length
end

## Function inserting a vehicle with probability p of being a truck in the first six cells of the highway
function Insert_Vehicle!(highway, num::Int64, p::Float64, vmax::Array{Int8, 1} = Int8[3, 5], left_boundary::Int8 = Int8(5), Len::Array{Int8, 1} = Int8[2, 1])

    lim = left_boundary + Int8(1)

    v_new = ( rand() <= p ? vmax[1] : vmax[2] )
    length_new = (v_new == vmax[1] ? Len[1] : Len[2])

    while highway[lim].tipo == -1 && highway[lim-length_new+Int8(1)].tipo == -1 && lim < (left_boundary+vmax[2])
        lim += Int8(1)
    end

    pos_new = min( lim - v_new, v_new)

    if highway[pos_new + 1].tipo != 1
      if pos_new > 1 && v_new == vmax[1] && highway[pos_new-1].tipo == -1
        tipo = 1
        Change_Vehicle!(highway[pos_new], v_new, pos_new, tipo, 1, num, Int64(length_new))
      end

      if (pos_new == 1 && v_new == vmax[1]) || v_new == vmax[2]
        tipo = (v_new == vmax[1] ? 1 : 2 )
        Change_Vehicle!(highway[pos_new], v_new, pos_new, tipo, 1, num, Int64(length_new))
      end
    end
    lim = v_new = pos_new = tipo = left_boundary = vmax = length_new = 0
end

## Function giving the position of the vehicle ahead when used in an empty cell
## When used at a non empty cell, it returns the position of the cell
## The function Vehicle_Ahead counts obstacles
function Vehicle_Ahead( position, Highway, N)
    i = position
    while i < N && Highway[i].tipo == -1
        i += 1
    end
    return i
end

## Function giving the position of the vehicle behind, even when we call it at a non empty cell
## If there's no vehicle behing, it returns the last cell
## It does not count obstacles
function Vehicle_Behind( position, Highway, N, left_boundary::Int8 = Int8(5) )

    i = position - Highway[position].len
    while i > left_boundary && (Highway[i].tipo == -1 || Highway[i].tipo == -2)
        i -= 1
    end

    if i > left_boundary
        return i
    else
        return N
    end
end

## Function giving the position of the vehicle closest to the end
function Pos_left(highway)

    gap = highway[end].position

    while gap >= 1 && (highway[gap].tipo == -1 || highway[gap].tipo == -2)
        gap -= 1
    end
    gap
end

## Same as Pos_left but without counting the first 9 cells
function Pos_left9(highway)

    gap = highway[end].position

    while gap >= 9 && (highway[gap].tipo == -1 || highway[gap].tipo == -2)
        gap -= 1
    end
    gap
end

## Function giving the position of the vehicle closest to the begining of the highway
function Pos_right(highway)
    x = highway[1].position
    i = 1
    while x < highway[end].position && (highway[i].tipo == -1 ||highway[i].tipo == -2)
        x += 1
        i += 1
    end
    x
    #if highway[x].tipo == 1
    #  return x + highway[x].len - 1
    #elseif highway[x].tipo == 2
    #  return x + highway[x].len - 1
    #end
end

## Function giving the last empty cell in a highway
function Pos_next(highway)
    x = highway[end].position
    i = length(highway)
    while x > highway[1].position && (highway[i].tipo == 1 || highway[i].tipo == 2)
        x -= 1
        i -= 1
    end
    x
end
