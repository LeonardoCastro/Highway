############################################################ Sentido 1: México-Acapulco #############################################################

function Sense1()
   Sense_1 = Highway2D(2, 3640+6)
    return Sense_1, Sense_1.highway
end

Sections1_CR = [150, 350, 535, 750, 1000,
                1250, 1490, 1600, 1770, 2000,
                2140, 2340, 2560, 2740, 2940,
                3100, 3300, 3640]

#(xramp, lramp)
S1_ramp = [(371, 38), (557, 3), (1015, 31), (1512, 100),
           (1628, 15), (1791, 10), (2158, 7), (2358, 20),
           (2580, 10), (2958, 6), (3115, 10)]

S1_ramp_local = [(371, 38), (557, 3), (1015, 31), (1512, 100),
          (1628, 15), (1791, 10), (2158, 7), (2358, 20),
          (2358, 20), (2580, 10), (2958, 6), (3115, 10)]

S1_ramp_ampli = [(371, 38), (2358, 20), (2580, 10),
                 (2958, 6), (3115, 10)]

#(p2, p1)
P_ramp_S1 = [
################  12 hours
                (0.445,	0.056),#0.056
                #(0.,	0.001),      # Entrada a Gasolinera
                #(0.378,	0.022),    # Entrada de Paloma
                (0.096,	0.009),    # Entrada de Paloma
                (0.096,	0.009),    # Entrada de Vicente Guerrero
                (0.095,	0.016),    # Entrada de Ahuatepec
                (0.038,	-0.01),    # Entrada de Diana
                (0.067,	0.017),    # Entrada entre Diana y Plan de Ayala
                (0.056,	0.007),    # Entrada después de Plan de Ayala
                (-0.053,	-0.007), # Salida antes de Tabachines
                (-0.144,	-0.019), # Salida de Morelos
                (-0.332,	-0.014), # Salida carretera libre
                (0.036,	-0.003),   # Entrada de Burgos
                #(0.01,	0.008),    # Calle entre Burgos y Brisas
                (-0.101,	-0.02)   # Salida de Brisas
                ]

P_local_S1 = [
################  12 hours
                (0.445,	0.056),
                #(0.378,	0.022),    # Entrada de Paloma
                (0.096,	0.009),    # Entrada de Paloma
                (0.096,	0.009),    # Entrada de Vicente Guerrero
                (0.095,	0.016),    # Entrada de Ahuatepec
                (0.038,	-0.01),    # Entrada de Diana
                (0.067,	0.017),    # Entrada entre Diana y Plan de Ayala
                (0.056,	0.007),    # Entrada después de Plan de Ayala
                (-0.053,	-0.007), # Salida antes de Tabachines
                (-0.144,	-0.019), # Salida a Morelos
                (-0.011, 0.006),   # Salida al puente
                (-0.332,	-0.014), # Salida carretera libre
                (0.036,	-0.003),   # Entrada de Burgos
                (-0.101,	-0.02)   # Salida de Brisas
                ]

P_ampli_S1 = [
#################  12 hours
              (0.445,	0.056),    # Flujo inicial
              (0.096,	0.009),    # Entrada de Paloma
              #(0.378,	0.022),    # Entrada de Paloma
                #(0.,	0.001)
                #(0.237,	0.018)
                #(0.01,	0.008)
              (0.155, 0.013),    # Antes del puente
              (-0.332,	-0.014), # Salida carretera libre (después del punte)
              (0.036,	-0.003),   # Entrada de Burgos
              (-0.101,	-0.02)   #Salida de Brisas
              ]

############################################################## Sentido 2: Acapulco-México ##########################################################

function Sense2()
    Sense_2 = Highway2D(3, 3640+6)
    for i = 1:3440 # 3685 = 3863 - 177 - 1
        Obstacle!(Sense_2.highway[1].highway[i])
    end
    return Sense_2, Sense_2.highway
end

Sections2_CR = [150, 350, 550, 790, 880,
                1100, 1300, 1480, 1660, 1900,
                2080, 2200, 2320, 2550, 2850,
                3050, 3290, 3520, 3640]

#(xramp, lramp)
S2_ramp = [(562, 35), (810, 5), (900, 4), (1500, 20),
           (1686, 5), (2107, 4), (2342, 7), (2871, 22),
           (3314, 4), (3542, 5)]

 S2_ramp_local = [(562, 35), (810, 5), (900, 4), (1500, 20),
            (1686, 5), (2107, 4), (2342, 7), (2871, 22),
            (3314, 4), #=(3450, 20),=# (3542, 5)]

S2_ramp_ampli =  [(562, 35), (810, 5), (900, 4), (1500, 20),
                     (3450, 20), (3542, 5)]

P_ramp_S2 = [
#################  12 hours
                (0.521,	0.08),     # Flujo Inicial
                (0.068,	-0.01),    # ITESM/Emiliano Zapata
                (0.073,	0.019),    # Brisas
                #(-0.026,	-0.013), #### Entre Brisas y Burgos
                (-0.02,	0.003),    # Burgos
                #(0.269,	0.02),   #### Entrada carretera libre
                (0.24,	0.033),    # Después del puente
                (0.076,	-0.003),   # Tabachines
                (-0.077,	-0.003), # Plan de Ayala
                #(-0.048,	-0.014), #### Entre Plan de Ayala y Diana
                (-0.053,	-0.009), #  Diana
                (-0.121,	-0.002), # Ahuatepec
                (-0.063,	-0.005), # Vicente Guerrero
                (-0.063,	-0.005)  # Paloma
                #(-0.417,	-0.021), # Paloma
                #(0.02,	0.004)     # Gasolinera
            ]

P_ampli_S2 = [
#################  12 hours
                (0.521,	0.08),     # Flujo Inicial
                (0.068,	-0.01),    # ITESM/Emiliano Zapata
                (0.073,	0.019),    # Brisas
                #(-0.026,	-0.013), #### Entre Brisas y Burgos
                (-0.02,	0.003),    # Burgos
                #(0.269,	0.02),   #### Entrada carretera libre
                (0.24,	0.033),    # Después del puente
                (-0.238, -.022),   # Termina Express
                (-0.063,	-0.005)  # Paloma
                #(-0.417,	-0.021), # Paloma
              ]

P_local_S2 = [
#################  12 hours
                (0.521,	0.08),     # Flujo Inicial
                (0.068,	-0.01),    # ITESM/Emiliano Zapata
                (0.073,	0.019),    # Brisas
                #(-0.026,	-0.013), #### Entre Brisas y Burgos
                (-0.02,	0.003),    # Burgos
                #(0.269,	0.02),   #### Entrada carretera libre
                (0.24,	0.033),    # Después del puente
                (0.076,	-0.003),   # Tabachines
                (-0.077,	-0.003), # Plan de Ayala
                #(-0.048,	-0.014), #### Entre Plan de Ayala y Diana
                (-0.053,	-0.009), #  Diana
                (-0.121,	-0.002), # Ahuatepec
                (-0.063,	-0.005), # Vicente Guerrero
                #(0.238, 0.22),      # Entrada Express
                (-0.063,	-0.005)  # Paloma
                #(-0.417,	-0.021) # Paloma
                #(0.02,	0.004)     # Gasolinera
            ]
