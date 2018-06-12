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

function Measure_Densities!(mean_density, D_mean_density, mean_speed, D_mean_speed, mean_flux, D_mean_flux)

  idx_s = find(mean_speed .== 0)
  idx_f = find(mean_flux .== 0)

  # Normal case
  mean_density = mean_flux./mean_speed
  D_mean_density = (D_mean_flux.*mean_speed - mean_flux.*D_mean_speed)./(mean_speed.^2)

  # Vehicles present but no flux case
  mean_density[idx_s] = 1
  D_mean_density[idx_s] = 0

  # No vehicles case
  mean_density[intersect(idx_s, idx_f)] = 0
  D_mean_density[intersect(idx_s, idx_f)] = 0
end

function Measure!(Lanes::Int64, S::Int64, N::Int64, A::Int64, mean_speed, mean_flux,
									D_mean_speed, D_mean_flux, speeds, fluxes; sense::Int64 = 1)

	mean_speed_n = zeros(S, Lanes, A)
	mean_flux_n = zeros(S, Lanes, A)

	# ensamble averaging
	for t = 1:A, k = 1:Lanes, s = 1:S
    K = (sense == 1 ? k : k+1)
		idx_n = find([f for f in fluxes[s, k, t, :]])
    mean_speed_n[s, k, t] = (length(idx_n) != 0 ? mean(speeds[s, k, t, idx_n]) : 0)
    mean_flux_n[s, k, t] = (length(idx_n) != 0 ? mean(fluxes[s, K, t, idx_n]) : 0)
	end

	# temporal averaging
	for k = 1:Lanes, s = 1:S
		idx_t = find([f for f in mean_flux_n[s, k, :]])

		mean_flux[s, k] = (length(idx_t) != 0 ? mean(mean_flux_n[s, k, idx_t]) : 0)
		mean_speed[s, k] = (length(idx_t) != 0 ? mean(mean_speed_n[s, k, idx_t]) : 0)

		D_mean_flux[s, k] = (length(idx_t) != 0 ? std(mean_flux_n[s, k, idx_t]) : 0)
		D_mean_speed[s, k] = (length(idx_t) != 0 ? std(mean_speed_n[s, k, idx_t]) : 0)
	end
	K = idx_n = idx_t = mean_speed_n = mean_flux_n = 0
end

function Measure_s!(Lanes::Int64, S::Int64, N::Int64, A::Int64, mean_speed, mean_flux,
									D_mean_speed, D_mean_flux, speeds, fluxes; sense::Int64 = 1)

	mean_speed_n = zeros(S, Lanes, A)
	mean_flux_n = zeros(S, Lanes, A)

	# ensamble averaging
	for t = 1:A, k = 1:Lanes, s = 1:S
		idx_n = find(view(fluxes, s, k, t, :))
		if sense == 1
			mean_speed_n[s, k, t] = mean(speeds[s, k, t, idx_n])
			mean_flux_n[s, k, t] = mean(fluxes[s, k, t, idx_n])
		else
			mean_speed_n[s, k, t] = mean(speeds[s, k+1, t, idx_n])
			mean_flux_n[s, k, t] = mean(fluxes[s, k+1, t, idx_n])
		end
	end

	# temporal averaging
	for k = 1:Lanes, s = 1:S
		idx_t = find(view(mean_flux_n, s, k, :))
    idx_s = find(view(mean_speed_n, s, k, :))

		mean_flux[s, k] = mean(mean_flux_n[s, k, idx_t])
		mean_speed[s, k] = 1./mean(1./mean_speed_n[s, k, idx_s])

		D_mean_flux[s, k] = std(mean_flux_n[s, k, idx_t])
		D_mean_speed[s, k] = 1./std(1./mean_speed_n[s, k, idx_s])
	end
	idx_n = idx_t = mean_speed_n = mean_flux_n = 0
end
