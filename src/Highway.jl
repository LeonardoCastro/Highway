module Highway

using JLD

import Base:
        show

export
        Vehicle, Highway1D, Highway2D,
        Empty_Cell!, Obstacle!, Change_Vehicle!, Insert_Vehicle!,  Vehicle_Behind, Vehicle_Ahead,
        Pos_next, Pos_right, Pos_left, Pos_left9,
        Merge!, Merge_Left_Right!, Merge_Right_Left!, safe_distance, Ramp!,
        AccelerationNoise, DecelerationMove, AccelerationNoiseS1, AccelerationNoiseS2,
        Measure_Fluxes!, Measure_Speeds!, add_Fluxes!, add_Speeds!, Measure_Densities!, Measure!, Measure_s!,
        Sense1, Sense2, Sections1_CR, Sections2_CR,
        S1_ramp, S1_ramp_ampli, S1_ramp_local, P_ramp_S1, P_ampli_S1, P_local_S1,
        S2_ramp, S2_ramp_ampli, S2_ramp_local, P_ramp_S2, P_ampli_S2, P_local_S2


include("types.jl")
include("aux-functions.jl")
include("AC-functions.jl")
include("merging-ramps.jl")
include("measurements.jl")
include("senses.jl")

end # module Highway
