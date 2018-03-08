function Measure_Densities!(f, v, d, A, Lanes, S, N, flux, speeds)
	for a = 1:A, k = 1:Lanes, s = 1:S
		f[s, k, a] += flux[s, k, a]/N
		v[s, k, a] += speeds[s, k, a]/N
		if speeds[s, k, a] != 0
			d[s, k, a] += flux[s, k, a]/(N*speeds[s, k, a])
		end
	end
end

function Measure_Fluxes!(highway, t, sections, T, flux_local0, flux_local1, flux_local2)

    for (i, section) in enumerate(sections)
      for j = section+4:-1:section
				if highway[j].speed > 0
            add_Fluxes!(flux_local0, highway[j], i, t, j, section, T, tipo=0)
            add_Fluxes!(flux_local1, highway[j], i, t, j, section, T, tipo=1)
            add_Fluxes!(flux_local2, highway[j], i, t, j, section, T)
					end
      end
    end
end

function Measure_Speeds!(highway, t, sections, T, speed_local0, speed_local1, speed_local2)

    for (i, section) in enumerate(sections)
      for j = section+4:-1:section
				if highway[j].speed > 0
            add_Speeds!(speed_local0, highway[j], i, t, j, section, tipo = 0)
            add_Speeds!(speed_local1, highway[j], i, t, j, section, tipo = 1)
            add_Speeds!(speed_local2, highway[j], i, t, j, section)
					end
      end
    end
end


function add_Fluxes!(array2, v, i, t, j, x_section, T; tipo::Int64 = 2)
  if j-v.speed < x_section
## discriminative count
    if tipo != 0 && v.tipo == tipo
      array2[i, t] += 1/T
    end

## tipo == 0 to count vehicles no matter the kind
    if tipo == 0
      array2[i, t] += 1/T
    end
  end
end

function add_Speeds!(array, v, i, t, j, x_section; tipo::Int64 = 2)

	if j-v.speed < x_section
		## discriminative count
    if tipo != 0 && v.tipo == tipo
			push!(array[i, t], v.speed)
    end

		## tipo == 0 to count vehicles no matter the kind
    if tipo == 0
			push!(array[i, t], v.speed)
    end
	end
end

function writing_Arrays!(Lanes, S, num_j, array0, array1, array2, D_array0, D_array1, D_array2, a0, a1, a2)
	for k = 1:Lanes, s = 1:S
		array0[s, k, num_j] = round(mean(Float64[x for x in a0[s, k, 1:end-1]]), 2)
		array1[s, k, num_j] = round(mean(Float64[x for x in a1[s, k, 1:end-1]]), 2)
		array2[s, k, num_j] = round(mean(Float64[x for x in a2[s, k, 1:end-1]]), 2)

		D_array0[s, k, num_j] = round(std(Float64[x for x in a0[s, k, 1:end-1]]), 2)
		D_array1[s, k, num_j] = round(std(Float64[x for x in a1[s, k, 1:end-1]]), 2)
		D_array2[s, k, num_j] = round(std(Float64[x for x in a2[s, k, 1:end-1]]), 2)
	end
end

#################################### Mediciones ######################################

function add!(i, j, t, x_section, v, array, array1, array2, T)

    if v.speed > 0
        if j-v.speed < x_section
            array[i, t] += 1/T

            if v.tipo == 1
                array1[i, t] += 1/T
            end
            if v.tipo == 2
                array2[i, t] += 1/T
            end
        end
    end
end


function add_simple!(array_speed, array_flux, array_density, i, t, T)

    v = ( array_density[i, t] != 0 ? array_flux[i, t]/array_density[i, t] : 0 )
    array_speed[i, t] += v/T
end

function Measure!(C, t, sections, T, flux_local, density_local ,
               speed_local_average, flux_local1, density_local1 ,speed_local_average1,
               flux_local2, density_local2 , speed_local_average2)


    #T = 1.  T es el periodo de tiempo por el cual se mide

    for (i, x_section) in enumerate(sections)

        # Medicion del flux local
        for j = x_section+4:-1:x_section
            add!(i, j, t, x_section, C.highway[j], flux_local, flux_local1, flux_local2, T)
        end


        # Medicion de la density local
        for j = x_section+4:-1:x_section
            add!(i, j, t, x_section, C.highway[j], density_local, density_local1, density_local2,
                    T*C.highway[j].speed)
        end

        # Medicion de la speed average espacial

        add_simple!( speed_local_average, flux_local, density_local, i, t, T )
        add_simple!( speed_local_average1, flux_local1, density_local1, i, t, T )
        add_simple!( speed_local_average2, flux_local2, density_local2, i, t, T )
    end
end

function ET!(X, T, highway, t)

    for v in highway
        if v.tipo == 1 || v.tipo == 2
            push!(X[v.num], v.position)
            push!(T[v.num], t)
        end
    end
end

function ET_tipo!(X, T, highway, t, tipo::Int64)

    for v in highway
        if v.tipo == tipo
            push!(X[v.num], v.position)
            push!(T[v.num], t)
        end
    end
end

function times_exit!(Times_exit::Array{Int64, 1}, Times_exit1::Array{Int64, 1}, Times_exit2::Array{Int64, 1},
                        T0::Array{Any,1}, T1::Array{Any,1}, T2::Array{Any,1},
                        X::Array{Any,1}, X1::Array{Any,1}, X2::Array{Any,1},
                        N::Int64 = 3862)

    for i in 1:length(X)
        if length(X[i]) != 0 && X[i][end] > N-6
            push!(Times_exit, T0[i][end]-T0[i][1])
        end
        if length(X1[i]) != 0 && X1[i][end] > N-6
            push!(Times_exit1, T1[i][end]-T1[i][1])
        end
        if length(X2[i]) != 0 && X2[i][end] > N-6
            push!(Times_exit2, T2[i][end]-T2[i][1])
        end
    end
end

function times_initials!(Times_initials1::Array{Int64,1}, Times_initials2::Array{Int64, 1},
                            T1::Array{Any, 1}, T2::Array{Any, 1}, X1::Array{Any, 1}, X2::Array{Any, 1}, N::Int64 = 3862)

  for i in 1:length(T1)
      if length(T1[i]) != 0 && X1[i][end] > N-6
          push!(Times_initials1, T1[i][1])
      end
  end
  for i = 1:length(T2)
      if length(T2[i]) != 0 && X2[i][end] > N-6
          push!(Times_initials2, T2[i][1])
      end
  end
end

function Times_average(Tf::Int64, Times_exit, Times_initials)

    Ts_average = Any[]

    h = int64(ceil(Tf/900))

    for i = 1:h
        push!(Ts_average, Float64[])
    end

    for (l, lim) in enumerate(linspace(900, Tf, h))
        for i = 1:length(Times_exit)
            if Times_initials[i] <= lim
                push!(Ts_average[l], Times_exit[i])
                Times_initials[i] = Tf+1
            end
        end
    end

    Times_exit_average = Float64[0.]
    Deviations_salida_average = Float64[0.]

    for i = 1:length(Ts_average)
        push!(Times_exit_average, mean(Ts_average[i]))
        push!(Deviations_salida_average, std(Ts_average[i]))
    end

    Ts_average = 0
    return Times_exit_average, Deviations_salida_average
end

function Measurements_DF!(fluxes_sections_average::Array{Float64, 3}, D_fluxes_sections_average::Array{Float64, 3}, density::Array{Float64, 3},
                     flux::Array{Float64, 3}, sections::Array{Int64, 1})

    for k = 1:size(fluxes_sections_average)[3]
        for (i, s) in enumerate(sections[1:end-1])
            for j =s:sections[i+1]
                copy_d = copy([de for de in sub(density, j, :, k)][1:end-1])
                copy_f = copy([fl for fl in sub(flux, j, :, k)][1:end-1])
                fluxes_average, Deviations_fluxes_average = fluxes_average(copy_f, copy_d)
                for l = 1:size(fluxes_sections_average)[2]
                    fluxes_sections_average[i, l, k] += fluxes_average[l]/(sections[i+1]-s+1)
                    D_fluxes_sections_average[i, l, k] += Deviations_fluxes_average[l]/(sections[i+1]-s+1)
                end
                copy_d = copy_f = 0
            end
        end
    end
end

function Measurements_ET!(Measurements_sections_average::Array{Float64, 3}, D_Measurements_sections_average::Array{Float64, 3}, Measurements::Array{Float64, 3},
                     Tf::Int64, T::Int64, sections::Array{Int64, 1})

    for k = 1:size(Measurements_sections_average)[3]
        for (i, s) in enumerate(sections[1:end-1])
            for j =s:sections[i+1]
                 M_average_T, D_M_average_T = fluxes_average_T(Tf, T,
                                                    Float64[m for m in sub(Measurements, j, :, k)])
                 for l = 1:length(M_average_T)
                    Measurements_sections_average[i, l, k] += M_average_T[l]/(sections[i+1]-s+1)
                    D_Measurements_sections_average[i, l, k] += D_M_average_T[l]/(sections[i+1]-s+1)
                 end
                 M_average_T = D_M_average_T = 0
            end
        end
    end
end

function fluxes_average_T(Tf::Int64, T::Int64, fluxes::Array{Float64, 1})

    F_average_T = Float64[0.]
    D_F_average_T = Float64[0.]

    h = int(ceil(Tf/900))
    m = 900/T

    for i = 0:h-1
        push!(F_average_T, mean(fluxes[i*m+1:m*(i+1)]))
        push!(D_F_average_T, std(fluxes[i*m+1:m*(i+1)]))

    end

    return F_average_T, D_F_average_T
end

function fluxes_average(fluxes, densities)

    F_average = Any[]

    h = 20

    for i = 1:h
        push!(F_average, Float64[])
    end

    for (l, lim) in enumerate(linspace(0.05, 1, h))
        for i = 1:length(fluxes)
            if densities[i] <= lim
                push!(F_average[l], fluxes[i])
                densities[i] = 1.1
            end
        end
    end

    fluxes_average = Float64[0.]
    Deviations_fluxes_average = Float64[0.]

    for i = 1:length(F_average)
        push!(fluxes_average, mean(F_average[i]))
        push!(Deviations_fluxes_average, std(F_average[i]))
    end

    F_average = 0
    return fluxes_average, Deviations_fluxes_average
end
