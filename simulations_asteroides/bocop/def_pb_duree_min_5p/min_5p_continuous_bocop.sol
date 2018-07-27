# **************************** 
# **************************** 
# *****    DEFINITION    ***** 
# **************************** 
# **************************** 
# # #
# ********************** 
# ** problem.def
# ********************** 
# # #
# # This file defines all dimensions and parameters 
# # values for your problem :
# # #
# # Initial and final time :
# time.free string none
# time.initial double 0
# time.final double 1
# # #
# # Dimensions :
# state.dimension integer 35
# control.dimension integer 9
# algebraic.dimension integer 0
# parameter.dimension integer 5
# constant.dimension integer 20
# boundarycond.dimension integer 41
# constraint.dimension integer 3
# # #
# # Discretization :
# discretization.steps integer 50
# discretization.method string midpoint
# # #
# # Optimization :
# optimization.type string single
# batch.type integer 0
# batch.index integer 0
# batch.nrange integer 1
# batch.lowerbound double 0
# batch.upperbound double 0
# batch.directory string none
# # #
# # Initialization :
# initialization.type string from_init_file
# initialization.file string none
# # #
# # Parameter identification :
# paramid.type string false
# paramid.separator string ,
# paramid.file string no_directory
# paramid.dimension integer 0
# # #
# # Names :
# state.0 string q11
# state.1 string q12
# state.2 string q13
# state.3 string q14
# state.4 string q15
# state.5 string q16
# state.6 string m1
# state.7 string q21
# state.8 string q22
# state.9 string q23
# state.10 string q24
# state.11 string q25
# state.12 string q26
# state.13 string m2
# state.14 string q31
# state.15 string q32
# state.16 string q33
# state.17 string q34
# state.18 string q35
# state.19 string q36
# state.20 string m3
# state.21 string q41
# state.22 string q42
# state.23 string q43
# state.24 string q44
# state.25 string q45
# state.26 string q46
# state.27 string m4
# state.28 string q51
# state.29 string q52
# state.30 string q53
# state.31 string q54
# state.32 string q55
# state.33 string q56
# state.34 string m5
# control.0 string u11
# control.1 string u12
# control.2 string u13
# control.3 string u31
# control.4 string u32
# control.5 string u33
# control.6 string u51
# control.7 string u52
# control.8 string u53
# parameter.0 string dt1
# parameter.1 string dt2
# parameter.2 string dt3
# parameter.3 string dt4
# parameter.4 string dtf
# boundarycond.0 string q11i-qH1
# boundarycond.1 string q12i-qH2
# boundarycond.2 string q13i-qH3
# boundarycond.3 string q14i-qH4
# boundarycond.4 string q15i-qH5
# boundarycond.5 string q16i-qH6
# boundarycond.6 string m1i-m0
# boundarycond.7 string q21i-q11f
# boundarycond.8 string q22i-q12f
# boundarycond.9 string q23i-q13f
# boundarycond.10 string q24i-q14f
# boundarycond.11 string q25i-q15f
# boundarycond.12 string q26i-q16f
# boundarycond.13 string m2i-m1f
# boundarycond.14 string q31i-q21f
# boundarycond.15 string q32i-q22f
# boundarycond.16 string q33i-q23f
# boundarycond.17 string q34i-q24f
# boundarycond.18 string q35i-q25f
# boundarycond.19 string q36i-q26f
# boundarycond.20 string m3i-m2f
# boundarycond.21 string q41i-q31f
# boundarycond.22 string q42i-q32f
# boundarycond.23 string q43i-q33f
# boundarycond.24 string q44f-q34f
# boundarycond.25 string q45i-q35f
# boundarycond.26 string q46i-q36f
# boundarycond.27 string m4i-m3f
# boundarycond.28 string q51i-q41f
# boundarycond.29 string q52i-q42f
# boundarycond.30 string q53i-q43f
# boundarycond.31 string q54i-q44f
# boundarycond.32 string q55i-q45f
# boundarycond.33 string q56i-q46f
# boundarycond.34 string m5i-m4f
# boundarycond.35 string qL21-q51f
# boundarycond.36 string qL22-q52f
# boundarycond.37 string qL23-q53f
# boundarycond.38 string qL24-q54f
# boundarycond.39 string qL25-q55f
# boundarycond.40 string qL26-q56f
# constraint.0 string constraint.0
# constraint.1 string constraint.1
# constraint.2 string constraint.2
# constant.0 string Tmax
# constant.1 string beta
# constant.2 string mu
# constant.3 string muS
# constant.4 string rS
# constant.5 string qH1
# constant.6 string qH2
# constant.7 string qH3
# constant.8 string qH4
# constant.9 string qH5
# constant.10 string qH6
# constant.11 string qL21
# constant.12 string qL22
# constant.13 string qL23
# constant.14 string qL24
# constant.15 string qL25
# constant.16 string qL26
# constant.17 string thetaS0
# constant.18 string omegaS
# constant.19 string m0
# # #
# # Solution file :
# solution.file string problem.sol
# # #
# # #
# ********************** 
# ** problem.bounds
# ********************** 
# # #
# # This file contains all the bounds of your problem.
# # Bounds are stored in standard format : 
# # [lower bound]  [upper bound] [type of bound]
# # #
# # Dimensions (i&f conditions, y, u, z, p, path constraints) :
# 41 35 9 0 5 3
# # #
# # Bounds for the initial and final conditions :
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# 0 0 equal
# # #
# # Bounds for the state variables :
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# -2e+19 2e+19 free
# # #
# # Bounds for the control variables :
# -1 1 both
# -1 1 both
# -1 1 both
# -1 1 both
# -1 1 both
# -1 1 both
# -1 1 both
# -1 1 both
# -1 1 both
# # #
# # Bounds for the algebraic variables :
# # #
# # Bounds for the optimization parameters :
# 0 2e+19 lower
# 0 2e+19 lower
# 0 2e+19 lower
# 0 2e+19 lower
# 0 2e+19 lower
# # #
# # Bounds for the path constraints :
# 0 0 equal
# 0 0 equal
# 0 0 equal
# # #
# ********************** 
# ** problem.constants
# ********************** 
# # #
# # This file contains the values of the constants of your problem.
# # Number of constants used in your problem : 
# 20
# # #
# # Values of the constants : 
# 3673236.22348
# 0.278173
# 0.012151
# 328900.572632
# 389.1724
# 3.172687
# -2.253791
# 0.000242
# -5.046201
# 0.4204
# -0.001436
# 1.155682
# 0
# 0
# 0
# 0
# 0
# 6.084787
# -0.921184
# 10
# # #
# ********************** 
# ** init/state.0.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q11
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 2.349654
# # #
# ********************** 
# ** init/state.1.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q12
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -1.876435
# # #
# ********************** 
# ** init/state.2.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q13
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.000182
# # #
# ********************** 
# ** init/state.3.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q14
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -3.82856
# # #
# ********************** 
# ** init/state.4.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q15
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 1.667103
# # #
# ********************** 
# ** init/state.5.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q16
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.000288
# # #
# ********************** 
# ** init/state.6.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable m1
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 9.984117
# # #
# ********************** 
# ** init/state.7.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q21
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 1.315294
# # #
# ********************** 
# ** init/state.8.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q22
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.758483
# # #
# ********************** 
# ** init/state.9.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q23
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 5.8e-05
# # #
# ********************** 
# ** init/state.10.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q24
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.982341
# # #
# ********************** 
# ** init/state.11.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q25
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 3.231855
# # #
# ********************** 
# ** init/state.12.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q26
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.000293
# # #
# ********************** 
# ** init/state.13.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable m2
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 9.984117
# # #
# ********************** 
# ** init/state.14.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q31
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 1.103967
# # #
# ********************** 
# ** init/state.15.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q32
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.017887
# # #
# ********************** 
# ** init/state.16.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q33
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -6e-06
# # #
# ********************** 
# ** init/state.17.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q34
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.382823
# # #
# ********************** 
# ** init/state.18.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q35
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 1.829182
# # #
# ********************** 
# ** init/state.19.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q36
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.000285
# # #
# ********************** 
# ** init/state.20.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable m3
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 3.800601
# # #
# ********************** 
# ** init/state.21.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q41
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 1.1266
# # #
# ********************** 
# ** init/state.22.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q42
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.003658
# # #
# ********************** 
# ** init/state.23.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q43
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -6.4e-05
# # #
# ********************** 
# ** init/state.24.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q44
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.338775
# # #
# ********************** 
# ** init/state.25.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q45
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 1.771097
# # #
# ********************** 
# ** init/state.26.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q46
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.000139
# # #
# ********************** 
# ** init/state.27.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable m4
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 3.800601
# # #
# ********************** 
# ** init/state.28.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q51
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 1.152458
# # #
# ********************** 
# ** init/state.29.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q52
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.012602
# # #
# ********************** 
# ** init/state.30.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q53
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -6.1e-05
# # #
# ********************** 
# ** init/state.31.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q54
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.006071
# # #
# ********************** 
# ** init/state.32.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q55
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.019332
# # #
# ********************** 
# ** init/state.33.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable q56
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.000119
# # #
# ********************** 
# ** init/state.34.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable m5
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 3.758687
# # #
# ********************** 
# ** init/control.0.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u11
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.390888
# # #
# ********************** 
# ** init/control.1.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u12
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.898171
# # #
# ********************** 
# ** init/control.2.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u13
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.201236
# # #
# ********************** 
# ** init/control.3.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u31
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.153019
# # #
# ********************** 
# ** init/control.4.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u32
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.988223
# # #
# ********************** 
# ** init/control.5.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u33
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 7e-06
# # #
# ********************** 
# ** init/control.6.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u51
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.424876
# # #
# ********************** 
# ** init/control.7.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u52
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# 0.905235
# # #
# ********************** 
# ** init/control.8.init
# ********************** 
# # #
# # Starting point file.
# # This file contains the values of the initial points
# # for variable u53
# # #
# # Type of initialization : 
# constant
# # #
# # Constant value for the starting point :
# -0.005477
# # #
# ********************** 
# ** init/optimvars.init
# ********************** 
# # #
# # Optimization parameters starting point file.
# # This file contains initialization values
# # for all optimization parameters
# # #
# # Number of optimization parameters :
# 5
# # #
# # Initial values : 
# 0.5
# 0.5
# 0.5
# 0.5
# 0.5
# # #
# discretization.stages integer 1
# discretization.steps.after.merge 50
# # #
# # #
# **************************** 
# **************************** 
# *****     SOLUTION     ***** 
# **************************** 
# **************************** 
# # #
# Objective value : 
1.5
# L2-norm of the constraints : 
10072755.3706771
# Inf-norm of the constraints : 
957295.821874272
# Number of stages of discretization method : 
1

0
0.01
0.02
0.03
0.04
0.05
0.06
0.07
0.08
0.09
0.1
0.11
0.12
0.13
0.14
0.15
0.16
0.17
0.18
0.19
0.2
0.21
0.22
0.23
0.24
0.25
0.26
0.27
0.28
0.29
0.3
0.31
0.32
0.33
0.34
0.35
0.36
0.37
0.38
0.39
0.4
0.41
0.42
0.43
0.44
0.45
0.46
0.47
0.48
0.49
0.5
0.51
0.52
0.53
0.54
0.55
0.56
0.57
0.58
0.59
0.6
0.61
0.62
0.63
0.64
0.65
0.66
0.67
0.68
0.69
0.7
0.71
0.72
0.73
0.74
0.75
0.76
0.77
0.78
0.79
0.8
0.81
0.82
0.83
0.84
0.85
0.86
0.87
0.88
0.89
0.9
0.91
0.92
0.93
0.940000000000001
0.950000000000001
0.960000000000001
0.970000000000001
0.980000000000001
0.99
1

# State 0
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654
2.349654

# State 1
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435
-1.876435

# State 2
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182
0.000182

# State 3
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856
-3.82856

# State 4
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103
1.667103

# State 5
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288
-0.000288

# State 6
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117

# State 7
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294
1.315294

# State 8
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483
-0.758483

# State 9
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05
5.8e-05

# State 10
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341
-0.982341

# State 11
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855
3.231855

# State 12
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293
-0.000293

# State 13
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117
9.984117

# State 14
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967
1.103967

# State 15
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887
-0.017887

# State 16
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06
-6e-06

# State 17
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823
0.382823

# State 18
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182
1.829182

# State 19
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285
-0.000285

# State 20
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601

# State 21
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266
1.1266

# State 22
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658
0.003658

# State 23
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05
-6.4e-05

# State 24
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775
0.338775

# State 25
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097
1.771097

# State 26
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139
-0.000139

# State 27
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601
3.800601

# State 28
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458
1.152458

# State 29
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602
0.012602

# State 30
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05
-6.1e-05

# State 31
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071
0.006071

# State 32
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332
-0.019332

# State 33
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119
0.000119

# State 34
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687
3.758687

# Control 0
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888
0.390888

# Control 1
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171
-0.898171

# Control 2
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236
0.201236

# Control 3
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019
-0.153019

# Control 4
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223
-0.988223

# Control 5
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06
7e-06

# Control 6
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876
0.424876

# Control 7
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235
0.905235

# Control 8
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477
-0.005477

# Parameters
0.5
0.5
0.5
0.5
0.5

# Boundary conditions : 
0 -0.823033 0 4
0 0.377356 0 4
0 -6e-05 0 4
0 1.217641 0 4
0 1.246703 0 4
0 0.001148 0 4
0 9.984117 0 4
0 -1.03436 0 4
0 1.117952 0 4
0 -0.000124 0 4
0 2.846219 0 4
0 1.564752 0 4
0 -5.00000000000001e-06 0 4
0 0 0 4
0 -0.211327 0 4
0 0.740596 0 4
0 -6.4e-05 0 4
0 1.365164 0 4
0 -1.402673 0 4
0 8.00000000000003e-06 0 4
0 -6.183516 0 4
0 0.0226330000000001 0 4
0 0.021545 0 4
0 -5.8e-05 0 4
0 -0.044048 0 4
0 -0.0580850000000002 0 4
0 0.000146 0 4
0 0 0 4
0 0.0258579999999999 0 4
0 0.008944 0 4
0 3e-06 0 4
0 -0.332704 0 4
0 -1.790429 0 4
0 0.000258 0 4
0 -0.0419139999999998 0 4
0 -1.152458 0 4
0 -0.012602 0 4
0 6.1e-05 0 4
0 -0.006071 0 4
0 0.019332 0 4
0 6.084668 0 4

# Path constraint 0 : 
0 0 4
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07
2.50740468610289e-07

# Path constraint 1 : 
0 0 4
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07
-2.43930529775227e-07

# Path constraint 2 : 
0 0 4
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09
9.06499986186304e-09

# Dynamic constraint 0 (y_dot - f = 0) : 
0 0 4
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382856
-0.0382855999999991

# Dynamic constraint 1 (y_dot - f = 0) : 
0 0 4
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999999
0.0166710299999995

# Dynamic constraint 2 (y_dot - f = 0) : 
0 0 4
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.88e-06
-2.87999999999992e-06

# Dynamic constraint 3 (y_dot - f = 0) : 
0 0 4
2876.27237988981
2876.27242200894
2876.27245750968
2876.27248495082
2876.27250322092
2876.27251158421
2876.27250971069
2876.27249768889
2876.27247602109
2876.27244560105
2876.27240767564
2876.27236379181
2876.2723157317
2876.27226543843
2876.27221493606
2876.27216624706
2876.27212131063
2876.27208190545
2876.27204957973
2876.27202559131
2876.27201086002
2876.27200593409
2876.27201097144
2876.27202573652
2876.27204961246
2876.27208162791
2876.27212049707
2876.27216467155
2876.27221240171
2876.2722618051
2876.27231093952
2876.27235787784
2876.27240078189
2876.27243797268
2876.27246799449
2876.27248967046
2876.27250214769
2876.27250493021
2876.27249789857
2876.27248131541
2876.27245581647
2876.2724223876
2876.27238232815
2876.27233720228
2876.27228877961
2876.27223896746
2876.27218973707
2876.27214304661
2876.27210076375
2876.27206459089

# Dynamic constraint 4 (y_dot - f = 0) : 
0 0 4
-6608.8271726161
-6608.82714379832
-6608.82710712972
-6608.82706409647
-6608.82701644508
-6608.82696610988
-6608.82691513258
-6608.82686557758
-6608.82681944655
-6608.8267785961
-6608.82674466204
-6608.82671899331
-6608.82670259841
-6608.82669610635
-6608.82669974363
-6608.82671332792
-6608.82673627849
-6608.82676764262
-6608.82680613678
-6608.82685020042
-6608.82689806031
-6608.82694780239
-6608.82699744835
-6608.82704503386
-6608.82708868529
-6608.82712669227
-6608.82715757286
-6608.8271801298
-6608.82719349508
-6608.82719716176
-6608.82719100188
-6608.82717527001
-6608.82715059231
-6608.82711794168
-6608.82707860005
-6608.827034109
-6608.82698621079
-6608.82693678175
-6608.82688776048
-6608.82684107355
-6608.8267985613
-6608.82676190648
-6608.82673256848
-6608.82671172556
-6608.82670022737
-6608.82669855972
-6608.82670682304
-6608.82672472562
-6608.82675159221
-6608.82678638746

# Dynamic constraint 5 (y_dot - f = 0) : 
0 0 4
1480.72656726569
1480.72656726568
1480.72656726568
1480.72656726568
1480.72656726569
1480.72656726569
1480.7265672657
1480.72656726571
1480.72656726572
1480.72656726574
1480.72656726576
1480.72656726577
1480.72656726579
1480.72656726582
1480.72656726584
1480.72656726586
1480.72656726588
1480.72656726591
1480.72656726593
1480.72656726595
1480.72656726598
1480.726567266
1480.72656726602
1480.72656726604
1480.72656726606
1480.72656726608
1480.72656726609
1480.72656726611
1480.72656726612
1480.72656726613
1480.72656726614
1480.72656726615
1480.72656726615
1480.72656726615
1480.72656726615
1480.72656726615
1480.72656726615
1480.72656726614
1480.72656726613
1480.72656726612
1480.72656726611
1480.72656726609
1480.72656726607
1480.72656726606
1480.72656726604
1480.72656726602
1480.72656726599
1480.72656726597
1480.72656726595
1480.72656726588

# Dynamic constraint 6 (y_dot - f = 0) : 
0 0 4
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.9539619949
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.9539619949
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.953961995
-10217.9539619947

# Dynamic constraint 7 (y_dot - f = 0) : 
0 0 4
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982341000000009
-0.00982340999999964

# Dynamic constraint 8 (y_dot - f = 0) : 
0 0 4
0.0323185500000001
0.0323185500000001
0.0323185499999999
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185499999999
0.0323185499999999
0.0323185499999999
0.0323185499999999
0.0323185499999999
0.0323185499999999
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185499999999
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185500000001
0.0323185499999992

# Dynamic constraint 9 (y_dot - f = 0) : 
0 0 4
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.92999999999999e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.93e-06
-2.92999999999992e-06

# Dynamic constraint 10 (y_dot - f = 0) : 
0 0 4
0.0739853803114269
0.07397212120774
0.0739634155337471
0.0739596201753592
0.073960896603016
0.07396720360246
0.0739782981258427
0.073993744300022
0.0740129302942384
0.0740350924208825
0.0740593455352332
0.0740847185268313
0.074110193469486
0.0741347468298735
0.0741573910349118
0.0741772146712502
0.0741934196385508
0.0742053537004772
0.0742125370684972
0.0742146819054494
0.0742117039369771
0.0742037256956229
0.0741910712791279
0.0741742528648874
0.0741539495701754
0.0741309795670312
0.0741062666376063
0.0740808025785687
0.0740556070228988
0.0740316863383489
0.0740099932814818
0.0739913890354175
0.0739766091421269
0.0739662346630426
0.0739606696739058
0.0739601259319405
0.0739646152576229
0.0739739498620888
0.0739877505372404
0.0740054623210679
0.0740263769668646
0.0740496612918956
0.0740743902671549
0.0740995835418417
0.0741242439789797
0.0741473967151849
0.0741681272490796
0.0741856171085582
0.0741991757446537
0.0742082674451879

# Dynamic constraint 11 (y_dot - f = 0) : 
0 0 4
0.0143776555410353
0.0143560243733498
0.0143321669822543
0.0143070315253868
0.014281619876765
0.0142569476733216
0.0142340035690016
0.0142137093428238
0.0141968824934495
0.0141842028702208
0.0141761847410238
0.0141731554856239
0.0141752418371506
0.0141823642849244
0.0141942399118693
0.0142103935842202
0.0142301770560196
0.0142527952122684
0.0142773383681738
0.0143028192819812
0.0143282133375275
0.01435250021914
0.0143747053418628
0.014393939316566
0.0144094338209722
0.0144205724091226
0.0144269150151399
0.0144282151814035
0.0144244293533959
0.0144157179190176
0.0144024380140166
0.0143851284523175
0.0143644874563007
0.0143413441447291
0.0143166249742892
0.0142913165160827
0.0142664260750527
0.0142429417248859
0.0142217933328266
0.0142038160898443
0.0141897179457273
0.0141800521819557
0.0141751961451404
0.0141753369191511
0.0141804644444723
0.0141903723088004
0.0142046661437618
0.0142227792788883
0.0142439950352951
0.0142674747967972

# Dynamic constraint 12 (y_dot - f = 0) : 
0 0 4
-1.76063785255892e-07
-1.76067570544056e-07
-1.76071348231529e-07
-1.76075080396008e-07
-1.76078729356157e-07
-1.76082258062835e-07
-1.76085630492124e-07
-1.76088812035532e-07
-1.76091769881848e-07
-1.76094473386152e-07
-1.76096894419632e-07
-1.76099007696145e-07
-1.76100791069291e-07
-1.76102225795923e-07
-1.76103296761125e-07
-1.76103992661277e-07
-1.76104306141964e-07
-1.76104233887641e-07
-1.76103776662671e-07
-1.76102939301783e-07
-1.76101730650657e-07
-1.76100163458101e-07
-1.76098254220847e-07
-1.76096022984384e-07
-1.76093493103023e-07
-1.76090690963372e-07
-1.76087645675609e-07
-1.76084388737649e-07
-1.76080953677416e-07
-1.76077375678516e-07
-1.76073691194429e-07
-1.76069937557e-07
-1.76066152583363e-07
-1.76062374186551e-07
-1.76058639993909e-07
-1.76054986977109e-07
-1.76051451097079e-07
-1.76048066967026e-07
-1.76044867535366e-07
-1.76041883791472e-07
-1.76039144494673e-07
-1.76036675928739e-07
-1.76034501681846e-07
-1.76032642452983e-07
-1.76031115885157e-07
-1.76029936425361e-07
-1.76029115211442e-07
-1.76028659985795e-07
-1.76028575035844e-07
-1.76028861161351e-07

# Dynamic constraint 13 (y_dot - f = 0) : 
0 0 4
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 14 (y_dot - f = 0) : 
0 0 4
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.0038282300000001
0.00382822999999988

# Dynamic constraint 15 (y_dot - f = 0) : 
0 0 4
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.01829182
0.0182918199999995

# Dynamic constraint 16 (y_dot - f = 0) : 
0 0 4
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.84999999999999e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.85e-06
-2.84999999999992e-06

# Dynamic constraint 17 (y_dot - f = 0) : 
0 0 4
-2957.79021783583
-2957.79020945275
-2957.7902044703
-2957.79020308532
-2957.79020535253
-2957.79021118244
-2957.79022034479
-2957.79023247758
-2957.79024710114
-2957.79026363695
-2957.79028143023
-2957.79029977564
-2957.79031794504
-2957.79033521616
-2957.79035090117
-2957.79036437406
-2957.79037509553
-2957.7903826347
-2957.79038668652
-2957.79038708429
-2957.79038380672
-2957.79037697923
-2957.79036686934
-2957.79035387641
-2957.79033851601
-2957.79032139952
-2957.79030320979
-2957.79028467392
-2957.79026653396
-2957.79024951709
-2957.79023430623
-2957.79022151236
-2957.79021164974
-2957.79020511504
-2957.79020217114
-2957.7902029365
-2957.79020738026
-2957.79021532356
-2957.79022644682
-2957.79024030273
-2957.79025633445
-2957.79027389826
-2957.79029228963
-2957.79031077172
-2957.79032860514
-2957.79034507766
-2957.79035953277
-2957.79037139586
-2957.79038019703
-2957.79038558951

# Dynamic constraint 18 (y_dot - f = 0) : 
0 0 4
-19102.1248492442
-19102.1248329215
-19102.1248152622
-19102.1247969663
-19102.1247787586
-19102.1247613604
-19102.1247454614
-19102.1247316921
-19102.1247205995
-19102.1247126251
-19102.1247080876
-19102.12470717
-19102.1247099122
-19102.1247162091
-19102.1247258144
-19102.1247383501
-19102.124753321
-19102.1247701343
-19102.1247881225
-19102.1248065702
-19102.124824742
-19102.1248419121
-19102.1248573934
-19102.1248705649
-19102.1248808969
-19102.1248879727
-19102.1248915052
-19102.1248913492
-19102.1248875075
-19102.1248801308
-19102.1248695123
-19102.1248560758
-19102.1248403588
-19102.124822991
-19102.1248046689
-19102.1247861275
-19102.1247681106
-19102.124751341
-19102.1247364907
-19102.1247241544
-19102.1247148252
-19102.1247088747
-19102.1247065386
-19102.1247079071
-19102.1247129216
-19102.1247213775
-19102.1247329328
-19102.124747122
-19102.1247633751
-19102.1247810403

# Dynamic constraint 19 (y_dot - f = 0) : 
0 0 4
0.135308848022093
0.135308848022029
0.135308848021993
0.135308848021984
0.135308848022004
0.135308848022052
0.135308848022127
0.135308848022228
0.135308848022356
0.135308848022508
0.135308848022683
0.135308848022879
0.135308848023095
0.135308848023328
0.135308848023576
0.135308848023837
0.135308848024108
0.135308848024386
0.135308848024669
0.135308848024954
0.135308848025238
0.135308848025518
0.135308848025791
0.135308848026055
0.135308848026307
0.135308848026544
0.135308848026764
0.135308848026965
0.135308848027144
0.1353088480273
0.135308848027431
0.135308848027535
0.135308848027613
0.135308848027662
0.135308848027683
0.135308848027674
0.135308848027637
0.135308848027572
0.135308848027479
0.135308848027359
0.135308848027213
0.135308848027044
0.135308848026852
0.13530884802664
0.13530884802641
0.135308848026164
0.135308848025905
0.135308848025636
0.135308848025358
0.135308848025072

# Dynamic constraint 20 (y_dot - f = 0) : 
0 0 4
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074707
-10217.9489074704

# Dynamic constraint 21 (y_dot - f = 0) : 
0 0 4
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991
0.00338774999999991

# Dynamic constraint 22 (y_dot - f = 0) : 
0 0 4
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.01771097
0.0177109699999995

# Dynamic constraint 23 (y_dot - f = 0) : 
0 0 4
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.39e-06
-1.38999999999996e-06

# Dynamic constraint 24 (y_dot - f = 0) : 
0 0 4
0.032702314977427
0.0327039013424632
0.0327091782475182
0.0327179301334591
0.0327298037431779
0.032744322542975
0.0327609059543031
0.0327788926092986
0.0327975666941839
0.032816186333277
0.0328340128964136
0.032850340085852
0.0328645216754046
0.0328759968332752
0.032884312058134
0.0328891388912887
0.0328902867312545
0.0328877102645174
0.0328815112310293
0.0328719344576563
0.0328593583098396
0.032844279923455
0.0328272957777648
0.0328090783493194
0.0327903497391336
0.0327718532857149
0.0327543242597911
0.0327384607793501
0.0327248960835994
0.0327141732609821
0.032706723440204
0.0327028483267974
0.0327027078050487
0.03270631313171
0.0327135260307193
0.0327240637652954
0.0327375100242763
0.0327533312230653
0.0327708975958407
0.0327895082543855
0.0328084192189202
0.0328268732955366
0.0328441305895434
0.0328594984087396
0.0328723593276455
0.0328821962530669
0.0328886134506549
0.0328913526566523
0.0328903036019056
0.0328855085077631

# Dynamic constraint 25 (y_dot - f = 0) : 
0 0 4
-0.00692790452326864
-0.00694666027261381
-0.00696471414794453
-0.00698134852362631
-0.00699590364061198
-0.00700780360704223
-0.00701657897124397
-0.00702188500174628
-0.00702351498426346
-0.00702140804499507
-0.00701565122508629
-0.00700647575434399
-0.0069942476949747
-0.00697945334006778
-0.00696267994919864
-0.00694459257798319
-0.00692590790371272
-0.00690736606043618
-0.00688970157033975
-0.00687361449155466
-0.00685974289454516
-0.0068486377302035
-0.00684074106437427
-0.00683636852864589
-0.00683569668007267
-0.00683875577834869
-0.00684542828419499
-0.00685545316451019
-0.00686843586601205
-0.00688386359790072
-0.00690112535385889
-0.0069195359127161
-0.00693836289309369
-0.00695685580729233
-0.00697427596950373
-0.00698992606759696
-0.00700317820915197
-0.00701349930207784
-0.00702047272711703
-0.00702381540079067
-0.00702338950786108
-0.00701920839533243
-0.00701143635685497
-0.00700038228737898
-0.0069864874423422
-0.00697030778253471
-0.00695249161412792
-0.00693375343295677
-0.00691484504389628
-0.00689652514270223

# Dynamic constraint 26 (y_dot - f = 0) : 
0 0 4
3.33994752258407e-06
3.3399444264595e-06
3.33994136209018e-06
3.33993835990312e-06
3.3399354495812e-06
3.33993265977945e-06
3.33993001785579e-06
3.33992754961851e-06
3.33992527909173e-06
3.33992322830071e-06
3.3399214170778e-06
3.33991986289025e-06
3.33991858069037e-06
3.33991758278858e-06
3.33991687875008e-06
3.33991647531501e-06
3.33991637634264e-06
3.33991658277934e-06
3.33991709265094e-06
3.33991790107892e-06
3.33991900032076e-06
3.33992037983432e-06
3.33992202636589e-06
3.339923924062e-06
3.3399260546043e-06
3.33992839736754e-06
3.33993092959937e-06
3.33993362662194e-06
3.33993646205359e-06
3.33993940804993e-06
3.33994243556255e-06
3.33994551461348e-06
3.3399486145836e-06
3.33995170451225e-06
3.33995475340575e-06
3.33995773055129e-06
3.33996060583347e-06
3.33996335004957e-06
3.33996593522006e-06
3.33996833489042e-06
3.33997052442053e-06
3.33997248125749e-06
3.33997418518813e-06
3.33997561856791e-06
3.33997676652226e-06
3.33997761711765e-06
3.33997816149984e-06
3.3399783939967e-06
3.33997831218451e-06
3.33997791691614e-06

# Dynamic constraint 27 (y_dot - f = 0) : 
0 0 4
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 28 (y_dot - f = 0) : 
0 0 4
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05
6.07100000000749e-05

# Dynamic constraint 29 (y_dot - f = 0) : 
0 0 4
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.00019332
-0.000193319999999995

# Dynamic constraint 30 (y_dot - f = 0) : 
0 0 4
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.19e-06
1.18999999999997e-06

# Dynamic constraint 31 (y_dot - f = 0) : 
0 0 4
8304.33512835015
8304.33511663537
8304.33510208425
8304.33508528173
8304.33506690269
8304.33504768456
8304.33502839746
8304.33500981312
8304.33499267386
8304.33497766277
8304.33496537647
8304.33495630149
8304.33495079508
8304.33494907133
8304.33495119308
8304.33495706991
8304.33496646218
8304.33497899103
8304.33499415382
8304.3350113444
8304.33502987737
8304.33504901537
8304.33506799831
8304.33508607335
8304.33510252452
8304.33511670095
8304.3351280421
8304.33513609994
8304.33514055626
8304.33514123516
8304.33513810986
8304.33513130377
8304.33512108567
8304.3351078592
8304.33509214716
8304.33507457106
8304.33505582679
8304.33503665734
8304.33501782361
8304.33500007437
8304.33498411668
8304.33497058774
8304.33496002951
8304.33495286686
8304.33494939038
8304.33494974437
8304.33495392062
8304.33496175831
8304.33497294991
8304.33498705283

# Dynamic constraint 32 (y_dot - f = 0) : 
0 0 4
17693.1035993063
17693.1036147356
17693.1036275212
17693.1036371518
17693.1036432437
17693.1036455558
17693.1036439991
17693.10363864
17693.1036296972
17693.1036175327
17693.1036026365
17693.1035856074
17693.1035671276
17693.1035479363
17693.1035287992
17693.1035104784
17693.1034937019
17693.1034791347
17693.1034673531
17693.1034588214
17693.1034538744
17693.1034527044
17693.1034553537
17693.1034617139
17693.1034715296
17693.1034844095
17693.1034998414
17693.1035172131
17693.1035358358
17693.1035549718
17693.1035738632
17693.1035917618
17693.1036079582
17693.1036218101
17693.1036327671
17693.1036403931
17693.1036443829
17693.103644575
17693.103640958
17693.1036336713
17693.1036230002
17693.1036093648
17693.1035933038
17693.1035754533
17693.1035565221
17693.1035372634
17693.1035184451
17693.1035008191
17693.1034850911
17693.1034718922

# Dynamic constraint 33 (y_dot - f = 0) : 
0 0 4
-107.049692693686
-107.049692693687
-107.049692693688
-107.049692693689
-107.049692693691
-107.049692693693
-107.049692693695
-107.049692693698
-107.0496926937
-107.049692693703
-107.049692693706
-107.049692693709
-107.049692693712
-107.049692693715
-107.049692693718
-107.049692693721
-107.049692693724
-107.049692693727
-107.049692693729
-107.049692693732
-107.049692693734
-107.049692693737
-107.049692693739
-107.04969269374
-107.049692693742
-107.049692693743
-107.049692693744
-107.049692693745
-107.049692693745
-107.049692693745
-107.049692693745
-107.049692693744
-107.049692693744
-107.049692693742
-107.049692693741
-107.049692693739
-107.049692693738
-107.049692693735
-107.049692693733
-107.049692693731
-107.049692693728
-107.049692693725
-107.049692693722
-107.049692693719
-107.049692693716
-107.049692693713
-107.04969269371
-107.049692693707
-107.049692693705
-107.049692693699

# Dynamic constraint 34 (y_dot - f = 0) : 
0 0 4
-10217.9514925667
-10217.9514925667
-10217.9514925667
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925667
-10217.9514925667
-10217.9514925667
-10217.9514925667
-10217.9514925667
-10217.9514925667
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925667
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925668
-10217.9514925665

# Dimension of the constraints multipliers : 
3691

# Constraint Multipliers : 

# Multipliers associated to the boundary conditions : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Path constraint 0 multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Path constraint 1 multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Path constraint 2 multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 0 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 1 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 2 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 3 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 4 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 5 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 6 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 7 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 8 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 9 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 10 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 11 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 12 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 13 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 14 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 15 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 16 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 17 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 18 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 19 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 20 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 21 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 22 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 23 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 24 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 25 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 26 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 27 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 28 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 29 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 30 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 31 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 32 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 33 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Dynamic constraint 34 (y_dot - f = 0) multipliers : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# Coefficients of discretization method : 

# a(i,j) by column : 
0.5

# b  : 
1

# c  : 
0.5

# z_L and z_U : 

# z_L corresponding to state variable 0 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 1 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 2 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 3 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 4 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 5 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 6 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 7 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 8 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 9 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 10 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 11 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 12 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 13 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 14 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 15 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 16 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 17 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 18 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 19 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 20 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 21 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 22 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 23 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 24 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 25 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 26 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 27 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 28 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 29 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 30 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 31 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 32 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 33 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to state variable 34 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_L corresponding to control variable 0 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to control variable 1 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to control variable 2 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to control variable 3 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to control variable 4 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to control variable 5 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to control variable 6 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to control variable 7 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to control variable 8 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_L corresponding to parameters : 
1
1
1
1
1

# z_U corresponding to state variable 0 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 1 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 2 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 3 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 4 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 5 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 6 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 7 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 8 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 9 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 10 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 11 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 12 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 13 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 14 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 15 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 16 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 17 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 18 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 19 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 20 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 21 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 22 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 23 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 24 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 25 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 26 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 27 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 28 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 29 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 30 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 31 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 32 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 33 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to state variable 34 : 
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0
0

# z_U corresponding to control variable 0 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to control variable 1 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to control variable 2 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to control variable 3 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to control variable 4 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to control variable 5 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to control variable 6 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to control variable 7 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to control variable 8 : 
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1
1

# z_U corresponding to parameters : 
0
0
0
0
0

# Cpu time : 
2.20909

# Iterations : 
1
