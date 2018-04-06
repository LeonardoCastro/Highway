############################################################ Sentido 1: México-Acapulco #############################################################

function Sense1()
   Sense_1 = Highway2D(2, 3640+6)
    return Sense_1, Sense_1.highway
end

Sections1 = [150, 200, 400, 600, 750, 900, 1100, 1400, 1700, 1850, 2100, 2300, 2350, 2600, 2900,
            3100, 3200, 3600 ]

Sections1_CR = [150, 200, 320, 390, 540, 570, 810, 850, 980, 1030, 1400, 1530, 1730, 1810, 2190, 2230,
                 2300, 2345, 2450, 2515, 2940, 2970, 3140, 3175, 3600]


#(xramp, lramp)
S1_in_ramp = [(178, 21), (371, 38), (557, 3), (838, 30), (1015, 31), (1512, 100), (1755, 10), (1791, 10), (2215, 15),
               (2321, 1), (2500, 20), (2958, 6), (3158, 3)]

S1_out_ramp = [(176, 10), (257, 11), (472, 20), (800, 22), (957, 15), (1414, 50), (1628, 15), (1729, 10), (1755, 10),
                (2158, 7), (2321, 1), (2358, 20), (2928, 6), (3115, 10), (3557, 13)]

S1_in_ramp_ampli = [(10, 20), (2500, 20), (2958, 6), (3158, 3)]

S1_ramp = [(371, 38), (557, 3), (1015, 31), (1512, 100),
           (1628, 15), (1791, 10), (2158, 7), (2358, 20),
           (2958, 6), (3115, 10)]
S1_in_ramp_ampli = [(2958, 6), (3115, 10)]

#(p2, p1)
P_ramp_S1 = [
################  12 hours
                (0.445,	0.056),#0.056
                #(0.,	0.001),      # Entrada a Gasolinera
                (0.378,	0.022),    # Entrada de Paloma
                (0.096,	0.009),    # Entrada de Vicente Guerrero
                (0.095,	0.016),    # Entrada de Ahuatepec
                (0.038,	-0.01),    # Entrada de Diana
                (0.067,	0.017),    # Entrada entre Diana y Plan de Ayala
                (0.056,	0.007),    # Entrada después de Plan de Ayala
                (-0.053,	-0.007), # Salida antes de Tabachines
                (-0.144,	-0.019), # Salida de Morelos
                #(-0.332,	-0.014), #
                (0.036,	-0.003),   # Entrada de Burgos
                #(0.01,	0.008),    # Calle entre Burgos y Brisas
                (-0.101,	-0.02)   # Salida de Brisas
#################  8 hours
#                (0.660763888888889,	0.077425),
#                (0.0000638888888888889,	0.00414722222222222),
#                (0.509,	0.0247694444444444),
#                (0.195583333333333,	0.0155638888888889),
#                (0.152130555555556,	0.0355638888888889),
#                (0.0505083333333333,	-0.020925),
#                (0.0936944444444444,	0.0291944444444444),
#                (0.086575,	0.00334166666666667),
#                (-0.0858972222222222,	-0.0129444444444444),
#                (-0.221305555555556,	-0.0275472222222222),
#                (-0.466591666666667,	-0.00745277777777778),
#                (0.0412861111111111,	-0.01275),
#                (0.00284166666666667,	0.00711111111111111),
#                (-0.1455,	-0.0261388888888889)
            ]

P_ampli_S1 = [
#################  12 hours
                (0.445,	0.056)
                #(0.,	0.001)
                (0.237,	0.018)
                (0.01,	0.008)
                (-0.101,	-0.02)

#################  8 hours
#                (0.660763888888889,	0.077425),
#                (0.0000638888888888889,	0.00414722222222222),
#                (0.354983333333333,	0.0268138888888889),
#                (0.00284166666666667,	0.00711111111111111),
#                (-0.1455,	-0.0261388888888889)
              ]


############################################################## Sentido 2: Acapulco-México ##########################################################

function Sense2()
    Sense_2 = Highway2D(3, 3640+6)
    for i = 1:3440 # 3685 = 3863 - 177 - 1
        Obstacle!(Sense_2.highway[1].highway[i])
    end
    return Sense_2, Sense_2.highway
end

Sections2 = [100, 250, 500, 600, 700, 850, 1000, 1300, 1550, 1600, 1700, 2000, 2200,
            2300, 2500, 2700, 2800, 3000, 3300, 3400, 3500, 3600]

Sections2_CR = [190, 230, 500, 580, 790, 825, 900, 950, 1450, 1520, 1565, 1600, 1650, 1700, 2120, 2165, 2450, 2500,
                 2750, 2800, 2890, 2930, 3300, 3400, 3550, 3600]

#(xramp, lramp)
S2_in_ramp = [(214, 8), (562, 35), (810, 5), (920, 4), (1500, 20), (1585, 4), (1686, 5), (2140, 4),  (2479, 10), (2785, 6),
               (2915, 5), (3336, 8), (3378, 6), (3572, 13)]

S2_out_ramp = [(107, 12), (528, 6), (760, 6), (900, 4), (1357, 20), (1571, 4), (1629, 4), (2057, 6), (2107, 4), (2342, 7),
                  (2757, 7), (2871, 22), (3314, 4), (3542, 5)]

S2_in_ramp_ampli =  [(810, 5), (920, 4), (1500, 20), (3600, 20)]

P_ramp_S2 = [
#################  12 hours
                (0.521,	0.08),
                (0.068,	-0.01),
                (0.073,	0.019),
                (-0.026,	-0.013),
                (-0.02,	0.003),
                (0.269,	0.02),
                (0.24,	0.033),
                (0.076,	-0.003),
                (-0.077,	-0.003),
                (-0.048,	-0.014),
                (-0.053,	-0.009),
                (-0.121,	-0.002),
                (-0.063,	-0.005),
                (-0.417,	-0.021),
                (0.02,	0.004)
#################  8 hours
#                (0.794777777777778,	0.125508333333333),
#                (0.0748138888888889,	-0.0263527777777778),
#                (0.121333333333333,	0.0296194444444444),
#                (-0.0185472222222222,	-0.0179722222222222),
#                (-0.0169444444444444,	-0.000222222222222222),
#                (0.372425,	0.0221944444444444),
#                (0.375583333333333,	0.0495916666666667),
#                (0.0768972222222222,	-0.0104361111111111),
#                (-0.143647222222222,	-0.000805555555555556),
#                (-0.0646305555555556,	-0.02475),
#                (-0.0695472222222222,	-0.0111111111111111),
#                (-0.136341666666667,	-0.000936111111111111),
#                (-0.199258333333333,	-0.0170194444444444),
#                (-0.565813888888889,	-0.0180194444444444),
#                (0.0558888888888889,	0.0105916666666667)
            ]

P_ampli_S2 = [
#################  12 hours
                (0.521,	0.08),
                (0.141,	0.009),
                (-0.026,	-0.013),
                (-0.147,	-0.003),
                (0.02,	0.004)
#################  8 hours
#                (0.794777777777778,	0.125508333333333),
#                (0.0748138888888889,	-0.0263527777777778),
#                (0.121333333333333,	0.0296194444444444),
#                (-0.212602777777778,	0.010725),
#                (0.0558888888888889,	0.0105916666666667)
              ]
