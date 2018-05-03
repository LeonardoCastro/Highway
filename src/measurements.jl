function Measure_Densities!(f, v, d, A, Lanes, S, N, flux, speeds)
	for a = 1:A, k = 1:Lanes, s = 1:S
		Idx = find(view(flux, s, k, a, :))
		f[s, k, a] = mean(Float64[x for x in flux[s, k, a, Idx]])
		v[s, k, a] = mean(Float64[x for x in speeds[s, k, a, Idx]])
		if v[s, k, a] != 0
			d[s, k, a] += f[s, k, a]/v[s, k, a]
		end
	end
end

function Measure_Fluxes!(highway, t, sections, T, flux_local0, flux_local1, flux_local2)

    for (i, section) in enumerate(sections)
      for j = section+4:-1:section
				if highway[j].speed > 0
            add_Fluxes!(flux_local0, highway[j], i, t, section, T, Int8(0))
            add_Fluxes!(flux_local1, highway[j], i, t, section, T, Int8(1))
            add_Fluxes!(flux_local2, highway[j], i, t, section, T)
					end
      end
    end
end

function Measure_Speeds!(highway, t, sections, T, speed_local0, speed_local1, speed_local2)

    for (i, section) in enumerate(sections)
      for j = section+4:-1:section
				if highway[j].speed > 0
            add_Speeds!(speed_local0[i, t], highway[j], section, Int8(0))
            add_Speeds!(speed_local1[i, t], highway[j], section, Int8(1))
            add_Speeds!(speed_local2[i, t], highway[j], section)
					end
      end
    end
end


function add_Fluxes!(flux, v, i, t, x_section, T, tipo::Int8 = Int8(2))
  if v.position-v.speed < x_section
		if tipo == Int8(0)
			if v.tipo > Int8(0)
				flux[i, t] += 1/T
			end
		else
			if v.tipo == tipo
				flux[i, t] += 1/T
			end
		end
  end
end

function add_Speeds!(array, v, x_section, tipo::Int8 = Int8(2))

	if v.position-v.speed < x_section
		## discriminative count
    if v.tipo == tipo #tipo != Int8(0) &&
			push!(array, v.speed)
    end

		## tipo == 0 to count vehicles no matter the kind
    if tipo == Int8(0) && v.tipo > Int8(0)
			push!(array, v.speed)
    end
	end
end

function writing_Arrays!(Lanes, S, num_j, array0, array1, array2, D_array0, D_array1, D_array2, a0, a1, a2)
	for k = 1:Lanes, s = 1:S
		idx0 = find(view(a0, s, k, :))
		idx1 = find(view(a1, s, k, :))
		idx2 = find(view(a2, s, k, :))

		array0[s, k, num_j] = round(mean(Float64[x for x in a0[s, k, idx0]]), 2)
		array1[s, k, num_j] = round(mean(Float64[x for x in a1[s, k, idx1]]), 2)
		array2[s, k, num_j] = round(mean(Float64[x for x in a2[s, k, idx2]]), 2)

		D_array0[s, k, num_j] = round(std(Float64[x for x in a0[s, k, idx0]]), 2)
		D_array1[s, k, num_j] = round(std(Float64[x for x in a1[s, k, idx1]]), 2)
		D_array2[s, k, num_j] = round(std(Float64[x for x in a2[s, k, idx2]]), 2)
	end
end

function Measure!(Lanes::Int64, S::Int64, N::Int64, num_j::Int64, mean_speed, mean_flux, D_mean_speed, D_mean_flux, speeds, fluxes)

	mean_speed_t = zeros(S, Lanes, N)
	mean_flux_t = zeros(S, Lanes, N)

	# temporal averaging
	for n = 1:N, k = 1:Lanes, s = 1:S
		idx_t = find(view(fluxes, s, k, :, n, num_j))

		mean_speed_t[s, k, n] = mean(speeds[s, k, idx_t, n, num_j])
		mean_flux_t[s, k, n] = mean(fluxes[s, k, idx_t, n, num_j])
	end

	# averaging with respect to N
	for k = 1:Lanes, s = 1:S
		idx_f = find(view(mean_flux_t, s, k, :))
		idx_s = find(view(mean_speed_t, s, k, :))

		mean_flux[s, k, num_j] = mean(mean_flux_t[s, k, idx_f])
		mean_speed[s, k, num_j] = mean(mean_speed_t[s, k, idx_s])

		D_mean_flux[s, k, num_j] = std(mean_flux_t[s, k, idx_f])
		D_mean_speed[s, k, num_j] = std(mean_speed_t[s, k, idx_s])
	end
	idx_s = idx_f = idx_t = mean_speed_t = mean_flux_t = 0
end

function Measure_D!(Lanes, S, N, num_j, mean_density, D_mean_density, mean_speed, D_mean_speed, mean_flux, D_mean_flux)

	for k = 1:Lanes, s = 1:S
		mean_density[s, k, num_j] = mean_flux[s, k, num_j]/mean_speed[s, k, num_j]

		D_d = (D_mean_flux[s, k, num_j]*mean_speed[s, k, num_j]-mean_flux[s, k, num_j]*D_mean_speed[s, k, num_j])/
					mean_speed[s, k, num_j]^2
		D_mean_density[s, k] = abs(D_d)
	end
end
