function AccelerationNoise(highway; vmax::Array{Int8, 1} = Int8[3, 5], R::Float32 = 0.2f0, left_boundary::Int64 = 5)

    for v in highway[left_boundary+1:end]
        if v.tipo == 1 || v.tipo == 2

            #Acceleration
            if v.speed != -1
                  Cambiar_Vehiculo!(v, min(v.speed+1, vmax[v.tipo]), v.position, v.tipo, v.change, v.num, v.len)
            end

            #Noise
            if v.speed > 0
                if rand() <= R
                    Change_Vehicle!(v, max(v.speed-1, 0), v.position, v.tipo, v.change, v.num, v.len)
                end
            end
        end
    end
end



function DecelerationMove(C::Highway1D)

    alfa = [0.8f0, 0.75f0]
    left_boundary = Int8(5)

    i = Pos_left(C.highway)
    i_1 = ( i > 1 ? Pos_left(C.highway[1:i-1]) : 0 )

    # This while is for the next steps
    while (i > 0)

        if i_1 != 0
        ############################ change ###################################
          distance = i - i_1 - C.highway[i].len

          #The vehicle i-1 deaccelarate with respect to vehicle i
          estimated_speed = round(Int8, floor( C.highway[i].speed * (1.0 - alfa[C.highway[i].tipo]) + 0.5 ) )
          Change_Vehicle!(C.highway[i_1], min( (estimated_speed+distance), C.highway[i_1].speed),
                              C.highway[i_1].position, C.highway[i_1].tipo, C.highway[i_1].change,
                              C.highway[i_1].num, C.highway[i_1].len)
        end

        #Vehicle i is moved

        next_pos = C.highway[i].speed + C.highway[i].position
        if C.highway[i].position != next_pos  && next_pos > 0 #&& C.carretera[pos_sig].tipo == -1

            if next_pos > C.N
                Empty_Cell!(C.highway[i])
                C.count -= 1
            end

            if next_pos <= C.N && C.highway[next_pos].tipo == -1

                if C.highway[i].position <= left_boundary && next_pos > left_boundary
                    C.count += 1
                end

                Change_Vehicle!(C.highway[next_pos], C.highway[i].speed, next_pos, C.highway[i].tipo, 0
                                    , C.highway[i].num, C.highway[i].len)

                Empty_Cell!(C.highway[i])
            elseif next_pos <= C.N && C.highway[next_pos].tipo == -2 && next_pos > 0
                while C.highway[next_pos].tipo == -2 && next_pos > 1
                   next_pos -= 1
                end
               Change_Vehicle!(C.highway[next_pos], C.highway[i].speed, next_pos, C.highway[i].tipo, 0,
                                C.highway[i].num, C.highway[i].len)
               Empty_Cell!(C.highway[i])
            end
        end
        #Reindexing the vehicle i-1 as the vehicle i

        i = i_1
        i_1 = ( i > 1 ? Pos_left(C.highway[1:i-1]) : 0 )
    end

    alfa = left_boundary = i = i_1 = 0
end


################################## Special Functions for the simulations with curves ############################

######### Sense 1 ###########

function AccelerationNoiseS1(highway, vmax::Array{Int8, 1} = Int8[3, 5], R::Float32 = 0.2f0, left_boundary::Int64 = 5)

    for v in highway[left_boundary+1:end]
        if v.tipo == 1 || v.tipo == 2

            #Acceleration
            if v.speed != -1
              #Curves zone
                if (v.position < 349) || ( v.position > 620 && v.position < 663)
                  vmax[2] = Int8(4)
                end
                Change_Vehicle!(v, min(v.speed+1, vmax[v.tipo]), v.position, v.tipo, v.change, v.num, v.len)

            end

            #Noise
            if v.speed > 0
                if rand() <= R
                    Change_Vehicle!(v, max(v.speed-1, 0), v.position, v.tipo, v.change, v.num, v.len)
                end
            end
            vmax[2] = Int8(5)
        end
    end
  vmax = 0
end


##### Sense 2 #######

function AccelerationNoiseS2(highway, vmax::Array{Int8, 1} = Int8[3, 5], R::Float32 = 0.2f0, left_boundary::Int64 = 5)

    for v in highway[left_boundary+1:end]
        if v.tipo == 1 || v.tipo == 2

            #Acceleration
            if v.speed != -1
              #Curves zone
                if (v.position > 3518) || ( v.position < 3408 && v.position > 3265)
                    vmax[2] = Int8(4)
                end

                #Hill
                if (v.position > 2500) && v.tipo == 1
                    vmax[1] = Int8(2)
                end
                Change_Vehicle!(v, min(v.speed+1, vmax[v.tipo]), v.position, v.tipo, v.change, v.num, v.len)
            end

            #Noise
            if v.speed > 0
                if rand() <= R
                    Change_Vehicle!(v, max(v.speed-1, 0), v.position, v.tipo, v.change, v.num, v.len)
                end
            end
        vmax = Int8[3, 5]
        end
    end
  vmax = 0
end
