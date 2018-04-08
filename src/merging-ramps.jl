## Esta función da la distancia de seguridad que debe de haber entre dos vehículos
function safe_distance(i, Highway1, N, delta, alfa::Array{Float64, 1} = Float64[0.8f0, 0.75f0])

    pvfo = Vehicle_Ahead(i, Highway1, N)
    d_ifo = (pvfo < N ? (pvfo-i-Highway1[pvfo].len) : delta*5 ) # 5 = vmax[2]
    tipo = ( Highway1[i].tipo == 1 ? 1 : 2)
    dfo = d_ifo + Int8( floor( (1.-alfa[tipo]) * Highway1[pvfo].speed + 0.5) )
    alfa = pvfo = d_ifo = 0
    return dfo
end


## Esta función hace que un vehículo cambie de carril
function Merge!(v0::Vehicle, Count0, C1::Highway1D, vmax::Array{Int64, 1} = [3, 5])

    i = v0.position
    if C1.highway[i].tipo == -1
        if (i < C1.N && C1.highway[i+1].tipo != 1) || i == C1.N

            pvbo = Vehicle_Behind(i, C1.highway, C1.N)
            d_bo = (pvbo < (C1.N) ? (i-pvbo-C1.highway[pvbo].len) : vmax[2] )
            vb = C1.highway[pvbo].speed
            if vb <= d_bo

                Change_Vehicle!( C1.highway[i], v0.speed, v0.position, v0.tipo, 1, v0.num, v0.len)
                Empty_Cell!( v0 )
                Count0 -= 1
                C1.count += 1
            end
        end
    end
end

## Esta función hace los cambios de carril desde un carril izquierdo hacia uno derecho
function Merge_Left_Right!(Ck, Ckminus1, k)

    for v in Ck.highway[end:-1:9]
        if (v.tipo == 1 || v.tipo == 2) && v.change == 0

            delta = (v.tipo == 2 ? Int8(3) : Int8(1))
            l = v.speed
            dfo = safe_distance(v.position, Ckminus1.highway, Ckminus1.N, delta)
            dfs = safe_distance(v.position, Ck.highway, Ck.N, delta)

            if v.tipo == 2 && dfo >= l*delta && (dfs >= delta*l || l > dfs)
                Merge!(v, Ck.count, Ckminus1)
            end

            if v.tipo == 1 && dfo >= l*delta && (dfs  >= delta*l || l > dfs)
                Merge!(v, Ck.count, Ckminus1)
            end
            l = dfo = dfs = delta = 0
        end
    end
end

## Esta función hace los cambios de carril desde un carril derecho hacia uno izquierdo
function Merge_Right_Left!(Ck, Ckplus1, k)

    for v in Ck.highway[end:-1:9]
        if (v.tipo == 2 || (v.tipo == 1 && k<3) ) && v.change == 0 #(v.tipo == 1 && k < 2)
        #if v.tipo == 2 && v.change == 0
            l = v.speed
            dfs = safe_distance(v.position, Ck.highway, Ck.N, Int8(1))

            if dfs < l
                if Ckplus1.highway[v.position].tipo == -1
                    dfo = safe_distance(v.position, Ckplus1.highway, Ckplus1.N, Int8(1))
                    if dfo >= l
                        Merge!(Ck.highway[v.position], Ck.count, Ckplus1)
                    end
                end
            end
            dfs = l = dfo = 0
        end
    end
end

## Esta función simula una rampa de entrada (tipo == 1) o de salida (tipo == 0)
function Rampa!( tipo, x0, lramp, pin, p, Ck, num, vmax::Array{Int8, 1} = Int8[3, 5])
    #vmax = [3, 5]

    # Rampa de salida, tipo == 0
    if tipo == 0
    ############################ cambio ###################################
        x = Pos_der(Ck.carretera[x0:x0+lramp])  # if longitud > 1 Ck.carretera[xi] && ... && Ck.carretera[xi+londitud] esten vacia
        if x <= x0+lramp && rand() < pin
            if Ck.cuenta > 0
                Ck.cuenta -= 1
            end
            Empty_Cell!(Ck.carretera[x])
        end

    # Rampa de entrada, tipo == 1
    elseif tipo == 1
    ############################ cambio ###################################
        x = Pos_siguiente(Ck.carretera[x0:x0+lramp])
        if x <= x0+lramp && rand() < pin
          Ck.cuenta += 1
          v_nueva = (rand() <= p ? vmax[1] : vmax[2])
          tipo_nuevo = (v_nueva == vmax[1] ? 1 : 2)
          Change_Vehicle!( Ck.carretera[x], v_nueva, x, tipo_nuevo, 1, num)
        end
        v_nueva = 0; tipo_nuevo = 0
    end
    x = 0
end

function Ramp!(x0, lramp, p2, p1, Ck, num, vmax::Array{Int8, 1} = Int8[2, 2], Len::Array{Int64, 1} = Int64[2, 1])

  ############# Ramp light vehicles #################

  ############# Entrance           #################
  if p2 > 0
    if rand() < p2
      intro = false
      x_end = x0+lramp
      x = Pos_next(Ck.highway[x0:x_end])
      while !intro && x >= x0
        if Ck.highway[x+1].tipo != 1
          Ck.count += 1
          Change_Vehicle!( Ck.highway[x], vmax[2], x, 2, 1, num, Len[2])
          intro = true
        else
          x_end = x-1
          x = Pos_next(Ck.highway[x0:x_end])
        end
      end
    end
  end
  ############# Exit            #################
  if p2 < 0
     if rand() < -p2
       out = false
       x_end = x0+lramp
       x = Pos_right(Ck.highway[x0:x_end], Int8(2))
       while !out && x >= x0
         if Ck.highway[x].tipo == 2
           Ck.count -= 1
           Empty_Cell!(Ck.highway[x])
           out = true
         else
           x_end = x-1
           x = Pos_right(Ck.highway[x0:x_end], Int8(2))
         end
       end
     end
   end

  ############# Ramp trucks    #################

  ############# Entrance         #################
  if p1 > 0
    if rand() < p1
      intro = false
      x_end = x0+lramp
      x = Pos_next(Ck.highway[x0:x_end])
      while !intro && x >= x0
        if Ck.highway[x+1].tipo != 1 && Ck.highway[x-1].tipo == -1
          Ck.count += 1
          Change_Vehicle!(Ck.highway[x], vmax[1], x, 1, 1, num, Len[1])
          intro = true
        else
          x_end = x-1
          x = Pos_next(Ck.highway[x0:x_end])
        end
      end
    end
  end
    ############# Exit            #################
  if p1 < 0
    if rand() < -p1
      out = false
      x_end = x0+lramp
      x = Pos_right(Ck.highway[x0:x_end], Int8(1))
      while !out && x >= x0
        if Ck.highway[x].tipo == 1
          Ck.count -= 1
          Empty_Cell!(Ck.highway[x])
          out = true
        else
          x_end = x-1
          x = Pos_right(Ck.highway[x0:x_end], Int8(2))
        end
      end
    end
  end
end
