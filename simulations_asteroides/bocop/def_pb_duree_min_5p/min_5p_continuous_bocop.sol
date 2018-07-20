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
# 18366.181117
# 0.278173
# 0.012151
# 328900.572632
# 389.1724
# 3.43772
# -1.82417
# 0.001385
# -4.761338
# -0.497575
# -0.002743
# 1.155682
# 0
# 0
# 0
# 0
# 0
# 2.465318
# -0.921184
# 350
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
# 3.43772
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
# -1.82417
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
# 0.001385
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
# -4.64124
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
# -0.546786
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
# -0.001415
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
# 350
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
# 1.668879
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
# -1.36838
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
# 0.000716
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
# -2.605561
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
# 2.211118
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
# -0.001437
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
# 337.588395
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
# 1.155682
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
# -0
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
# 0
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
# 0.349609
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
# 2.027302
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
# -0.001012
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
# 337.588395
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
# 1.155682
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
# -0
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
# 0
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
# 0.349609
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
# 2.027301
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
# -0.001012
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
# 256.932273
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
# 1.155682
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
# 0
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
# 0
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
# 0.34961
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
# 2.027301
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
# -0.001012
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
# 256.932273
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
# 0.925284
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
# -0.379137
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
# 0.010231
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
# -0.169942
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
# -0.985454
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
# 0.000492
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
# -0.169942
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
# -0.985454
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
# 0.000492
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
1.43940599762446
# L2-norm of the constraints : 
28913.6676249424
# Inf-norm of the constraints : 
24125.745622405
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
3.4311102063417
3.37840085585948
3.31828849569702
3.25160651328102
3.17978015994394
3.10577048438672
3.03362924422539
2.96604818913612
2.90455115695403
2.85000428250191
2.80291784505119
2.76361039625896
2.73228337856905
2.7090662337462
2.69403667309542
2.68723617645285
2.68866712977626
2.69830416999952
2.71609089404716
2.74195235466328
2.77578844447836
2.81749443112205
2.86694234889564
2.92398343428465
2.98841455240958
3.06000169719242
3.13844878630048
3.22340088963974
3.31437650725647
3.41077669191805
3.51182333963589
3.61651544540747
3.72347420954025
3.83089157091193
3.93695826464766
4.04021924698604
4.13957291098134
4.2341984016676
4.32350100146004
4.4070272017198
4.48440658877214
4.55535094934737
4.6196160992415
4.67699122544926
4.7272428221765
4.77019044322857
4.80566521434056
4.83359871109642
4.85394710050253
4.86673766936454
4.871897085859

# State 1
-1.8252406278575
-1.832384374484
-1.84336939582197
-1.85868774106821
-1.87962986067263
-1.90850300614135
-1.94531653905821
-1.98874312398082
-2.0374103182718
-2.09019984358901
-2.1462302895451
-2.204781344615
-2.26523774382965
-2.32705158758718
-2.38970971376993
-2.45271375704494
-2.51558348658077
-2.57786986418566
-2.63915741366464
-2.69905802553693
-2.7572207198452
-2.81333172724861
-2.86709714757242
-2.91820111613416
-2.96630368668645
-3.01104069822889
-3.05204407895153
-3.08890145720389
-3.12116629024656
-3.14833153703886
-3.16987962676296
-3.1852299167639
-3.19381478788312
-3.1952973853743
-3.18990872897605
-3.17811291555394
-3.16046086644897
-3.13747247669095
-3.10960818123126
-3.07728137066778
-3.04087728325504
-3.00076532301461
-2.95729410282112
-2.91084338976475
-2.86182493093209
-2.81066946393109
-2.75774285851043
-2.70328201257907
-2.64729827379608
-2.5896232251044
-2.52993389302457

# State 2
0.000997869090567067
0.000529926574850236
-3.23566588560667e-05
-0.000685952774560798
-0.00142872411930155
-0.00225884572367184
-0.00317297971788352
-0.00416636677481507
-0.00523474304053731
-0.00637414734539124
-0.00758082382548799
-0.00885115449918928
-0.0101816137603247
-0.0115687224875796
-0.0130090040875786
-0.0144989414509353
-0.0160349594005873
-0.0176134433960105
-0.0192307770378293
-0.0208833672084334
-0.0225676555795637
-0.0242801132672034
-0.0260172344567515
-0.0277755256168543
-0.029551497805773
-0.0313416599994994
-0.0331425093535805
-0.0349505201476496
-0.0367621291970002
-0.0385737115327002
-0.040381551531385
-0.0421817928384004
-0.0439703684638932
-0.0457431552542914
-0.0474963823805331
-0.0492265309670218
-0.0509300352493328
-0.0526032351797803
-0.0542423712726329
-0.0558435793164784
-0.0574028843928056
-0.0589161845529262
-0.0603792372841728
-0.0617876540934082
-0.0631367897511557
-0.0644213307137066
-0.0656340599381555
-0.0667631279668725
-0.067789239406612
-0.0686864195951924
-0.0694259392095029

# State 3
-4.77536991951937
-5.68473889360857
-6.54478430823076
-7.27058953762478
-7.71918559533843
-7.6968193794762
-7.30412824838147
-6.69461754339677
-5.96342017228611
-5.16308597243686
-4.32047076710063
-3.45078556481312
-2.56349312823004
-1.66489605165236
-0.759645389456256
0.147962958582581
1.05394255061291
1.95510093063467
2.84884140364146
3.73276764728696
4.60529547448321
5.46542950684436
6.31112084515994
7.13821065958882
7.94183056165443
8.71757260601738
9.45966511733923
10.1577715385791
10.7973842947268
11.3616480035058
11.8287895379608
12.1657930436454
12.3281873218363
12.2819108042469
12.0537628765195
11.6839323726899
11.2060755278015
10.6513183715424
10.0404937652179
9.38495272263382
8.69311022870655
7.97267327034223
7.22770062947206
6.45818019979953
5.66603039203221
4.85667718922371
4.03561992648065
3.20796615568746
2.37655499162738
1.53691671480708
0.666842004094283

# State 4
-0.489160839950263
-0.933524619781674
-1.41008123300578
-2.02801969467142
-2.82528200194616
-3.70225022824355
-4.47747715386778
-5.10525747953373
-5.60111846375792
-5.99236290382207
-6.29900321508115
-6.53449492726188
-6.70775129363603
-6.82421133322398
-6.8860374011914
-6.89429351482887
-6.85168397137372
-6.76209666064105
-6.62860247551029
-6.45412697407644
-6.2432282490348
-5.99983273443085
-5.72365869202642
-5.41094020203005
-5.05853891344104
-4.66523770216698
-4.22856136865887
-3.74284701464457
-3.20226305386444
-2.60385741473446
-1.9468288786136
-1.23368689795957
-0.478474643585121
0.283675227973009
1.01457059727481
1.69460061535052
2.31673075346037
2.8847890441845
3.40503855599838
3.88078521812199
4.31419123040268
4.70837817514457
5.06369647457085
5.37450871276551
5.63610384168332
5.8511267146124
6.02922283288992
6.19294207524993
6.36919575286899
6.57531022789515
6.83028140568978

# State 5
-0.00450981806915175
-0.015208263128888
-0.0255092679449558
-0.0355122450000348
-0.0453315850476096
-0.0549748842617923
-0.0640426514358911
-0.0726074288353532
-0.0807114125835952
-0.0883829639286797
-0.095640866108624
-0.102498252524336
-0.108963356710742
-0.11503931171497
-0.120724197422797
-0.126011735420944
-0.130895732387222
-0.135374372063481
-0.139449593154757
-0.143125494787575
-0.146406244795037
-0.149294973377856
-0.151794229272418
-0.153905002123373
-0.155627897201313
-0.156962473897774
-0.157907053911916
-0.158458787541797
-0.158612605215101
-0.158360305599004
-0.157690328248632
-0.156584466663614
-0.155016458085123
-0.153002878972845
-0.150600200020057
-0.147807971497381
-0.144617117768917
-0.141017583186478
-0.13699844807869
-0.132548111766847
-0.127654385828827
-0.12230153654553
-0.116474922051704
-0.110157035580742
-0.103309608645649
-0.0958221329135901
-0.0873819846932554
-0.0772680651318841
-0.064541607644874
-0.0486520701423165
-0.0295372626423459

# State 6
353.606983078813
361.21302574735
364.738426555581
366.714168709766
367.697023021654
367.875274088458
367.60774923818
367.177183644534
366.708140518244
366.255962583851
365.87278835561
365.570131849564
365.308874749664
365.076005789714
364.913738417359
364.838481555778
364.799562227776
364.77030322225
364.798672045953
364.910125977549
365.043567507241
365.152957001651
365.291494216847
365.50891213622
365.746843494995
365.939714936822
366.138435933164
366.411105701454
366.700509649895
366.905024372182
367.038961785954
367.170312824618
367.23951203608
367.128010771441
366.876090900486
366.653746253764
366.521298788501
366.378189052969
366.203631427025
366.155560148146
366.308130746687
366.513861951002
366.662605100569
366.86623624624
367.180883961121
367.251482896884
366.48253954792
364.327062932332
359.308652029264
346.126600543497
310.937823934178

# State 7
4.867096397947
4.86327804001322
4.85953544935649
4.85590191355079
4.85240132702464
4.8490306419724
4.84576584758799
4.84258775801807
4.8395016391409
4.83653850777458
4.83372175302858
4.83104096069911
4.82845458131262
4.82593008446919
4.8234839897795
4.8211594203296
4.81898815773423
4.81695153019233
4.81499512439207
4.81308135052881
4.81122213133593
4.80947452416666
4.80787673903718
4.80641519342229
4.80502512590823
4.80365805162982
4.80234090220468
4.80113460219613
4.80008082582677
4.79914611931946
4.79826090666617
4.79738454043698
4.79654322331655
4.7958193312031
4.79525924689857
4.7948279503351
4.7944288852872
4.79401120940946
4.79361809877793
4.79333076057052
4.79321106445648
4.79321403909876
4.79325099887723
4.79327534918673
4.79332564626427
4.79349428844698
4.79382189627428
4.79426875289675
4.79473172140746
4.79518129922397
4.7956845683908

# State 8
-2.53032552834033
-2.52106226736534
-2.51191170498055
-2.50287901740827
-2.49394573040902
-2.48508685487044
-2.47629256095898
-2.46757805893796
-2.45896759023913
-2.45046829347213
-2.44205589487501
-2.43369054412926
-2.42536191301219
-2.41709649469293
-2.40893344196637
-2.40087981332669
-2.3928956972332
-2.38493402520924
-2.37697934612962
-2.36906874852284
-2.3612506587616
-2.35353881741709
-2.34589292635593
-2.33824962555462
-2.33059393896689
-2.32296621545171
-2.31542942133798
-2.30798994410053
-2.30059020124044
-2.29317323449942
-2.28572619659954
-2.27830700960266
-2.27097979435591
-2.26375427194102
-2.25656017965221
-2.24931588780342
-2.24201527966079
-2.23472259815316
-2.22752290998852
-2.22041901817266
-2.21333433778562
-2.20618919753368
-2.19896229097978
-2.19172492624665
-2.18454033350297
-2.17739752677585
-2.17019831636272
-2.16283490387395
-2.15527382031549
-2.14753965775311
-2.13963255887106

# State 9
-0.0698193388742992
-0.0702558641056955
-0.0706932183002248
-0.0711314399616309
-0.0715705628888685
-0.0720106145658115
-0.0724516196721661
-0.0728936065683375
-0.0733366099127666
-0.07378066831036
-0.074225815657318
-0.0746720769947252
-0.0751194738629656
-0.0755680339688055
-0.0760177975852854
-0.0764688077695506
-0.0769210998684644
-0.077374696945702
-0.077829617440498
-0.0782858901693144
-0.0787435575725384
-0.0792026694490544
-0.0796632649309144
-0.0801253677237214
-0.0805889945967466
-0.0810541733174756
-0.0815209539286051
-0.0819893887688985
-0.0824595174791901
-0.0829313602980542
-0.0834049334781378
-0.0838802703343017
-0.0843574235653123
-0.0848364548336997
-0.0853174058314312
-0.0858002941907229
-0.0862851300559844
-0.0867719460654692
-0.0872608049392314
-0.0877517699870851
-0.0882448885591048
-0.0887401765128007
-0.089237644759471
-0.0897373298644553
-0.0902392934699605
-0.0907436040032475
-0.0912503022026999
-0.091759403053119
-0.0922709125815903
-0.0927848690164909
-0.0933013390952208

# State 10
0.673969321964009
0.707450166253325
0.740892598248385
0.77422718288184
0.807392081267633
0.840406886706594
0.873359146634757
0.906332312422532
0.939333825172846
0.972290805272627
1.00512145243818
1.03781595883742
1.07047556992975
1.10321077122197
1.13604381918981
1.16889716149004
1.20166842716922
1.2343517152452
1.26703704000211
1.29984950667478
1.33283142462505
1.36591636409691
1.39900756395387
1.43207043140691
1.46520545871849
1.49853179032157
1.53210140965828
1.56584454870412
1.59964929781403
1.6335110482192
1.66751282677267
1.70179655838972
1.73642060409413
1.77132365907425
1.80638538448277
1.84156426148297
1.87697157498148
1.91273311478137
1.94893864764755
1.98554383364391
2.02244040661883
2.05960461849238
2.09708612133525
2.13504410885737
2.17354533998352
2.21253760019568
2.25190584962372
2.29158166121043
2.33161750642045
2.37203587438251
2.41275158099321

# State 11
6.83443400924683
6.83287910511961
6.8312812190252
6.82969139486997
6.82806866671328
6.82633794456878
6.82447289281458
6.82253182179722
6.82060917206765
6.81876098036312
6.81694522414194
6.81506270964345
6.81305642276331
6.81097256930849
6.80893332559201
6.80700426120194
6.80514823703804
6.80325975844094
6.80126513454298
6.79920280982571
6.79717928472903
6.79528453571727
6.79348870483369
6.79169180896164
6.78981523363041
6.78788448276306
6.78602819488909
6.78431725701606
6.78272871273204
6.78115095747246
6.77950578496224
6.7778319508456
6.77623835845731
6.7748325519617
6.77359001758773
6.77240294128963
6.77117204143493
6.76992351494569
6.76878231357776
6.76781599474414
6.76704809008888
6.76638033080072
6.76573161806266
6.76513115961561
6.76467053086686
6.76444127712644
6.76441188381959
6.76451776706968
6.76468233402172
6.76496526638431
6.76548406874374

# State 12
-0.0307743261269904
-0.0319959710345681
-0.0332029382728934
-0.0343953133033922
-0.0355731936991833
-0.0367366828831406
-0.0378858864499567
-0.0390209103900746
-0.0401418604535792
-0.0412488422852216
-0.0423419622349153
-0.0434213287687597
-0.0444870539802959
-0.0455392541112322
-0.0465780482870707
-0.0476035556468951
-0.0486158922382253
-0.0496151688426602
-0.0506014902094638
-0.0515749553759977
-0.0525356586473713
-0.0534836911267116
-0.054419142841429
-0.0553421055328633
-0.0562526751647684
-0.0571509528707423
-0.058037043337234
-0.0589110513758233
-0.0597730783141283
-0.0606232195122119
-0.0614615633960576
-0.0622881915779273
-0.0631031799686862
-0.0639066006456362
-0.0646985248373601
-0.0654790265836809
-0.0662481858343199
-0.0670060890584139
-0.0677528266439234
-0.0684884885792434
-0.0692131602088897
-0.0699269194414463
-0.0706298351759217
-0.0713219668975645
-0.0720033650577049
-0.0726740724427085
-0.0733341266739909
-0.0739835627674147
-0.0746224134794585
-0.0752507046056762
-0.0758684449128967

# State 13
313.461736630378
315.45702583585
317.127476794505
318.577883607022
319.869531673355
321.04144483455
322.120052689368
323.124120290467
324.067480363783
324.960648248163
325.811826906028
326.627559420759
327.413167971191
328.173058294045
328.910936542046
329.629967442664
330.33289215575
331.022117881448
331.699787318992
332.367833552993
333.028024294841
333.681998309537
334.331296117767
334.977386559694
335.621690465699
336.265602453204
336.910511728133
337.557822697402
338.208976186275
338.865472100226
339.528894480774
340.200940092281
340.883451966371
341.578459762198
342.288229437954
343.015325673672
343.762691902995
344.533754976711
345.332564860337
346.163985180266
347.033959362646
347.949892356376
348.921215020827
349.960248669427
351.083586338933
352.314415244739
353.686677222778
355.253148796764
357.102895501191
359.404919689136
362.543645675285

# State 14
4.79279325730707
4.81760760836532
4.84350128795165
4.87042854943243
4.89850007588039
4.92665427040588
4.9553323007963
4.98475025719077
5.01616691315309
5.04446573400649
5.07336159564725
5.09670566323832
5.11569129565259
5.13457574596564
5.15647425830461
5.16826507260157
5.17782367980871
5.18870235804709
5.20202952141172
5.21739499639893
5.23576992981092
5.25463231635957
5.26149171858131
5.25528814691846
5.24929342796859
5.24305889141654
5.22002609433571
5.19961522314223
5.17376714117548
5.13801464993326
5.10188513295587
5.07098210065739
5.03662870543078
4.99279244264699
4.94397875328038
4.89880898784897
4.84721167607642
4.78325982775241
4.72709076727735
4.66032016029976
4.57381859564511
4.47973501110238
4.38720188338141
4.29536872891212
4.20732458245579
4.12215571413426
4.0388615903482
3.9557087699774
3.87496758378603
3.79593089051143
3.7173682128134

# State 15
-2.14094027050655
-2.0703227371945
-2.01498881472364
-1.97039929137247
-1.93101013068354
-1.9037547421144
-1.89112136059531
-1.88380974280315
-1.88169058678309
-1.87601203212592
-1.86081990356375
-1.83850955758228
-1.82290194022191
-1.82287202571972
-1.82166238355064
-1.82078116285475
-1.82342014444601
-1.81778207922541
-1.79186544638975
-1.75893616328779
-1.72681294524442
-1.68313865081504
-1.63154616260991
-1.58456660912319
-1.53880129720088
-1.49670293868771
-1.45457829261565
-1.41789877549688
-1.37040049097205
-1.30498579936518
-1.23612311011422
-1.16366644509024
-1.08801650482783
-1.02808330509081
-0.982597843345598
-0.931729596889652
-0.890466405803544
-0.850405068797322
-0.813560408183426
-0.768657832071962
-0.721334018116336
-0.678916524669958
-0.631918076890806
-0.587416195155222
-0.564865692386237
-0.551389885869225
-0.531262442081748
-0.527105412008277
-0.54235737053509
-0.559577169017964
-0.575740799277162

# State 16
-0.0937118336060117
-0.094969288298265
-0.0962363996278108
-0.0975098373652993
-0.0987863418292809
-0.100064206663544
-0.101341384328479
-0.102613896623947
-0.103880331183222
-0.105136980517032
-0.10638286096151
-0.107612537614213
-0.108824288175826
-0.110018223274239
-0.111190315927853
-0.112335040456297
-0.113454056542605
-0.114546447547836
-0.11560946699118
-0.116641970270028
-0.117642526501516
-0.118607328583321
-0.119529394760405
-0.120405202329982
-0.121235188245774
-0.122017280937113
-0.122744263065174
-0.123422020081522
-0.124046178478037
-0.124613037789524
-0.125124738138065
-0.125579688020618
-0.125970237427306
-0.126293493332798
-0.126548164854396
-0.126731262626606
-0.126839132328362
-0.126867130158829
-0.126824984537922
-0.126701694704493
-0.126489645703707
-0.126191852768041
-0.125806302084636
-0.125329263750456
-0.12476554687105
-0.124107517303681
-0.123346319722462
-0.122486452687635
-0.121529721811776
-0.12046285993915
-0.119275781694412

# State 17
2.42694112970332
2.58369299736955
2.71729271070035
2.80746835074612
2.86283204084765
2.91449155533288
3.03525580081664
3.17709417704769
2.58915211491365
2.68786038529059
2.71667148514061
2.04218035947434
2.02082989080077
2.08575276943242
1.94188016099915
1.23218719730122
1.24099565207931
1.38729313041051
1.50773539359177
1.59900030740354
1.69438977953106
1.57663705082983
0.951707361016252
0.369136152858689
-0.0457361201231942
-0.53285107883108
-1.22021274017366
-1.57155718739442
-1.83354066699997
-2.10794472164158
-2.48023953760481
-3.10370405449082
-3.56435277887623
-3.70126989041856
-3.80576032116437
-3.92659838064215
-4.35694164922053
-5.06565043573697
-5.6419556464341
-6.28173964922179
-6.95385076942843
-7.38536607372395
-7.47807332472583
-7.38469574620406
-7.16167939957698
-6.96704286090112
-6.88237276275638
-6.89278926169327
-6.7660429825003
-6.30983569340548
-5.59153389014365

# State 18
6.77589556235031
5.88128941517707
4.96963443633718
4.04869437804484
3.12285763993113
2.19769599797628
1.27000250035358
0.340163211750992
0.777149528451946
1.56173018738386
2.33784459425309
2.52665793839405
1.64317210022684
0.746990975297695
-0.121250860529853
0.178943632191031
0.989569476841003
1.80762929006448
2.62265022815161
3.44059199395992
4.26054388552611
5.02458460892267
5.21271714308745
4.85209257904101
4.22199237117571
3.66633118482996
3.83795784581537
4.53927094379176
5.29836009478491
6.04268253069509
6.71237462277871
6.95335264392549
6.50972363975929
5.8245956247868
5.11813748521871
4.40772700705506
3.88669810897001
3.98709013093039
4.57591737337373
5.00128331846025
5.08749077688711
4.63863841533344
3.97889560846124
3.28958979283611
2.61177347075807
1.92221449972533
1.2171807697349
0.510617929684285
-0.214647803991817
-0.920489942932129
-1.63614496562085

# State 19
-0.0764775042641385
-0.0772703433362928
-0.0778187631040305
-0.0781152726079475
-0.0781951699071693
-0.0780561859113167
-0.0776914394256755
-0.0771017855668014
-0.0760075602106556
-0.0750265222942454
-0.0738229084774669
-0.0719823168846876
-0.0702705612040739
-0.068357611816378
-0.0661779782388732
-0.0634927107224255
-0.061027620335997
-0.0583925342879227
-0.0555782667518217
-0.052548600057841
-0.0493267107704737
-0.0458498790989591
-0.041802910272983
-0.0374944802401302
-0.0330720859863881
-0.0284088158126203
-0.0234699172757757
-0.0186524644211602
-0.0136995265419323
-0.0086066590188076
-0.00323860002250296
0.00260244556308285
0.00869626796588408
0.0148780366427746
0.0213175237630316
0.0280027538903322
0.0349888317305053
0.0421864783548535
0.0492996479777143
0.0566943764136264
0.0644015146354548
0.07236921585278
0.0805096422621459
0.0889382402791321
0.0975237075829712
0.1064157471452
0.115577831732474
0.124961756908817
0.134542810469434
0.144278811749365
0.154169017414772

# State 20
367.754223018661
360.666372783317
357.700124432747
356.521826168582
356.464734076655
357.19615741581
358.790662772517
361.824728573173
359.976632491906
360.053626950405
361.653376576421
360.561777057593
359.743142023218
359.574602815356
359.503563362677
356.996156622094
354.925798095158
354.196907953827
354.433919899041
354.802922841714
356.03420176806
357.862848234021
358.239528874311
357.741934721664
357.508653173457
357.112758829028
355.755017571496
354.988136427792
355.096673507028
355.428549921572
355.939034697858
356.292313490239
355.965995231304
355.315889454883
355.098439262372
355.301667092484
354.827375924207
354.223293435834
354.568075728649
354.679530823985
354.272080285321
353.837206208185
353.152733171292
351.857925694264
350.587050428581
348.951064923097
345.11459517575
336.885478922925
319.131585068616
281.462408318536
239.074667483267

# State 21
3.70526193015683
3.62141784566049
3.55565381501411
3.48484040847294
3.39904583942144
3.32387576021094
3.25869072774072
3.18023982085218
3.09766060387435
3.02977728993009
2.96075491977378
2.87807947175551
2.80259239240971
2.73802725808223
2.66207703849205
2.58136531900907
2.51444181292524
2.44647619593482
2.36719946685734
2.29483769526171
2.23070486540392
2.1583265970024
2.08310783171968
2.01743090147176
1.95213096309897
1.87874094506204
1.80888148655504
1.7467041140003
1.6788515179876
1.60708562570037
1.54433121492328
1.4825392246074
1.41324563313717
1.34840940760203
1.28943688798552
1.22467076489359
1.15879955022257
1.09968709652353
1.04025754044508
0.977066203397612
0.916821249231997
0.860701457357879
0.80114771359335
0.737792815536057
0.679388093567203
0.621758707179477
0.559019808011199
0.498957320420709
0.441190182551244
0.372848889117097
0.21086322099892

# State 22
-0.576850339271264
-0.613043966023089
-0.645896171574488
-0.660073096394132
-0.679300281651691
-0.708216254528083
-0.724403030237993
-0.732237521992639
-0.750482603142001
-0.768922210976313
-0.77382064668944
-0.780090599452557
-0.795332456137362
-0.80201771469566
-0.800168870344189
-0.806223744604047
-0.8127469094533
-0.808147521671465
-0.804199999652394
-0.80614908323449
-0.801926756683213
-0.791832498266808
-0.785796907790413
-0.780146868189642
-0.767561034321367
-0.753259205331529
-0.742423864518885
-0.72885783933854
-0.709886951883911
-0.692480696141503
-0.676552647240619
-0.655621748877576
-0.632272724307142
-0.61104533456256
-0.587908150469734
-0.560747742032145
-0.533654124183296
-0.507194942583399
-0.478140131383605
-0.446825329632121
-0.415513374470493
-0.383605499875582
-0.349400179452429
-0.313078049917299
-0.276043347393266
-0.239291212458696
-0.200764764157773
-0.158810552496839
-0.117432294459233
-0.077631605870258
-0.0385693725953443

# State 23
-0.119736657012037
-0.118335659080403
-0.116960853286987
-0.115569751992744
-0.114152605060929
-0.112756657655039
-0.111371325780145
-0.109951241792727
-0.108524600106898
-0.107128135858844
-0.105714482106246
-0.104261178989201
-0.102830809978276
-0.101417929450576
-0.099952512621149
-0.0984742750256494
-0.0970389682837957
-0.095573428170502
-0.0940537135956916
-0.0925679958861883
-0.0910984735779633
-0.0895612715122877
-0.0880094944267962
-0.0865070960523315
-0.0849703736433483
-0.0833567969227634
-0.0817764965422983
-0.0802337538929869
-0.078590512211815
-0.0769063059611777
-0.0753213281850426
-0.0736832244779076
-0.0719020804215315
-0.0702044042068131
-0.0685536088309839
-0.0667077927728871
-0.0648433377535428
-0.0631294226691641
-0.0612912541642492
-0.0592782760319716
-0.0573790020128362
-0.0555189244375829
-0.0533674669838604
-0.0510510186029381
-0.0489220127636841
-0.0467759868321655
-0.0442221285022291
-0.0416478388415632
-0.0393301528132219
-0.0365522106766321
-0.0330747177711176

# State 24
-5.59496732188336
-5.55391885537613
-5.52012314236926
-5.51758790788682
-5.49268255548594
-5.44551917871325
-5.42236722480027
-5.40536706650399
-5.36035689104432
-5.31442764186423
-5.28948195440574
-5.25230784304105
-5.1939717243841
-5.15081873221117
-5.11669066119418
-5.05999691365223
-5.00145221799972
-4.96031593570558
-4.90915055414911
-4.84314860215946
-4.78792378706361
-4.73671666782954
-4.67117995035378
-4.604091066585
-4.54624995522093
-4.48427825035246
-4.41269866793778
-4.34484611494062
-4.28147764376416
-4.20923701098639
-4.13307558781744
-4.06403024439274
-3.99265958217427
-3.9142141201418
-3.83938019547077
-3.76670828388683
-3.68826986957317
-3.60858008299148
-3.53168516058585
-3.45321418282793
-3.37244163645747
-3.29314348347714
-3.21580125880935
-3.13806321848857
-3.06087548736467
-2.98734902754616
-2.91727162714212
-2.85178789240059
-2.79553822202153
-2.75295578284488
-2.7355073796721

# State 25
-1.62440677694678
-1.49613061795974
-1.32312734326029
-1.17198062467769
-1.05605297187534
-0.913406679618992
-0.755775044866597
-0.629233073121561
-0.508003297102645
-0.36133160836371
-0.222328836853137
-0.107324715554606
0.0201019453936649
0.160898942859455
0.280467462084566
0.392952472133425
0.52395292083151
0.649042433110478
0.756939589401781
0.87386827823388
0.997947845914053
1.10848497303524
1.21511253027736
1.33105587325159
1.4440185501988
1.54664923435737
1.65155330586258
1.7616279656884
1.86419379215879
1.96110416370091
2.06407200766544
2.16636692601539
2.26018810789228
2.35540720397295
2.45393442447568
2.54669345587883
2.63645629601745
2.72891435720434
2.82001763199393
2.90764121453388
2.99518674997694
3.08336086558758
3.16987750093364
3.2545222443537
3.33901965710613
3.42349468716177
3.50732740560193
3.59118784444405
3.67548093743431
3.75956966408446
3.84321983958048

# State 26
0.154262946012989
0.154412734902799
0.154586288785994
0.154781380355101
0.154997153684381
0.155236669269158
0.155497337817461
0.155779724781441
0.156085691115214
0.156413064524169
0.156763427156776
0.157137161877843
0.157532950137324
0.157953083046952
0.158396660764911
0.158863184844163
0.159355359799594
0.159871679595257
0.16041215407699
0.160979481785591
0.161572480103867
0.162191448186817
0.162838504964086
0.163513554380229
0.164217416237854
0.164951203548121
0.165716179081651
0.166514437602478
0.167346254796583
0.168213805466407
0.169121365043006
0.170069619714492
0.1710610215956
0.172102718415817
0.173198670368988
0.174352369308941
0.175574469192176
0.176876463875519
0.178266095432552
0.179756551056257
0.181368164375545
0.183118315018615
0.185021966046105
0.187109403129983
0.189436954316487
0.192073070740824
0.19512919916198
0.198828758196135
0.203496782833845
0.209668371935978
0.218840386234799

# State 27
240.380092262134
241.594449647078
242.725476243435
243.78287293574
244.776214017204
245.714163983785
246.604275339014
247.453026586208
248.265945855223
249.047753230925
249.802494923543
250.533660270056
251.244280173333
251.93700856178
252.614189374247
253.277911632852
253.930054899341
254.572327056216
255.206296010615
255.83341662219
256.455053914185
257.072503436609
257.687009505498
258.299781936172
258.912011815539
259.52488681521
260.139606531195
260.757398347437
261.379534361561
262.007349986972
262.642264964613
263.285807694027
263.939644048304
264.60561220376
265.285765543602
265.982426464838
266.698255056013
267.436338326889
268.200308305228
268.994501464619
269.824178665179
270.695836016621
271.617656532776
272.600187624027
273.657396280372
274.80838833105
276.080368993248
277.514108244782
279.174985664717
281.178232446478
283.757908536191

# State 28
0.0773044288638361
0.063628493537537
0.05503875853182
0.0428757009012481
0.0246754323074175
0.00208114098412957
-0.0202261326619403
-0.0385053849436703
-0.0495431741262617
-0.0477313689313475
-0.045973189972618
-0.044825234442459
-0.0441201493343643
-0.0435513020648808
-0.0429293985472647
-0.042459425711479
-0.0418879401421289
-0.0408082084706718
-0.0402061672535858
-0.0391191309061091
-0.0373233161899887
-0.0341716100658752
-0.0283544877332616
-0.0165112889611619
0.0111778982843023
0.0266712124712633
0.0338619493640972
0.0373444059784798
0.0388169453031212
0.0388700353978177
0.0363045155792774
0.0311737342046415
0.0256940088924144
0.0187763636225878
0.0197689767432843
-0.0213309425243233
0.0140699029195687
0.0393907414232357
0.0382531198907916
0.036329784248739
0.0292684933990945
-0.00366727587119175
-0.0290160325954903
-0.0417707293730315
-0.0513795905130144
-0.0588450474792829
-0.0675604151140288
-0.0663673035898595
-0.0718191490620692
-0.0646675964646191
-0.0332613867330546

# State 29
-0.0452245208644435
-0.0254008764569386
-0.00308960841761913
0.0180990441179644
0.0334982247182739
0.0398831805233009
0.0366889186995021
0.0221593211890245
-0.0251288765158513
-0.0384725510153225
-0.0445482490385764
-0.0475197414929053
-0.0489757296641886
-0.0497107569313643
-0.0501061037394316
-0.0504187450798668
-0.0507169092505266
-0.0509539101398873
-0.0514394534411295
-0.0518286760458622
-0.0523386845446562
-0.0531982353506585
-0.0547160911848176
-0.0570816788321627
-0.0573428426614695
-0.0540294000894841
-0.05157744651306
-0.0502758828643757
-0.0497319309872617
-0.049514501784892
-0.047282132760299
-0.0421357119226182
-0.0358024189614203
-0.0274810334177037
-0.0124728965111445
0.00966158219654026
-0.0218349394668881
0.0129930023880653
0.0317986415651343
0.0458764492879415
0.058398162796258
0.000812230147605071
0.0512869969499471
0.0562037394046351
0.0576616997112916
0.0587183398375627
0.0638470697916025
0.0391849055799527
0.0487695504590045
0.0571998224826692
0.0299772195195566

# State 30
-0.0321676763847012
-0.0436409392094747
-0.0501813093260578
-0.0516928484362767
-0.0517903909251043
-0.0520063410834933
-0.0533365905269136
-0.0563258776014929
-0.0584109262487078
-0.0553176711544515
-0.0530295860800543
-0.0513958165350103
-0.05022605330652
-0.0493665101784165
-0.0487254995730023
-0.0483582677728351
-0.048134551081771
-0.04789359135441
-0.0481580995498368
-0.048565545760104
-0.0492296384532059
-0.0503358710187196
-0.0521727638128428
-0.0548469319517316
-0.055482882242232
-0.0524741262918677
-0.0497763853302885
-0.0478000123902602
-0.0462485273961441
-0.0446615580224376
-0.0413638393205393
-0.0357758767062532
-0.029201397484355
-0.0209635610451694
0.0119500335889196
0.0116662854423457
-0.00480079648621981
-0.0378081028579503
-0.0375870988679972
-0.033559878419608
-0.0257368863642032
0.000455507586413905
-0.0645195406822368
-0.059340377016225
-0.0548913258472592
-0.0515727709390472
-0.0510401518866697
-0.0414478162150355
-0.0314631543984734
-0.0211636520993088
-0.000847145457747877

# State 31
-2.73064743876944
-2.6724111974878
-2.68585595709333
-2.70037089297938
-2.70633125139157
-2.69575321763602
-2.67924641306604
-2.66440642712094
-2.6511429282106
-2.64511466317019
-2.6536124492788
-2.67053171919394
-2.6851673030216
-2.6911482243436
-2.6903077832778
-2.68874367344583
-2.69004076656406
-2.69760337492559
-2.71143464792381
-2.73430579503869
-2.76017063702643
-2.78316875407954
-2.80514323807034
-2.8279758168098
-2.84663739463684
-2.86296769938902
-2.8837157738696
-2.9099539493637
-2.93655218016609
-2.95062460981778
-2.88427681812588
-2.78487221805787
-2.72027581565197
-2.68263171027165
-2.6364875695811
-2.55948295865001
-2.45725870452677
-2.34573541219374
-2.24061208457544
-2.12161397844893
-2.0503945593752
-2.04971881733912
-2.06234420819513
-2.03404241376496
-1.95274232323129
-1.81776968830367
-1.6449391862477
-1.6171075569213
-1.02889357037427
-0.532880682009658
-0.00244907190060973

# State 32
3.84870810260459
3.35952477162301
3.11682152336561
2.95256641807874
2.78749072494537
2.61913133128124
2.43975041357848
2.30573280367662
2.20809485705442
2.08415365641141
1.98235811901026
1.89920237816344
1.82581779708231
1.75620740510277
1.69404187305759
1.64368584131231
1.59568811996658
1.55340511880257
1.54258770214541
1.52626005010657
1.51439754324039
1.50728612307409
1.50669877288363
1.50945323736208
1.50243461278867
1.49047073703401
1.4749080586029
1.46379047577729
1.46023888380685
1.4629098640533
1.47881131953836
1.50788737640172
1.53976843509059
1.58497315240338
1.64817301270931
1.68483990656239
1.70291066662364
1.7228909685064
1.72290366192593
1.71216224605483
1.69879841187764
1.61437739824062
1.55121018789637
1.4496030964939
1.35809779303572
1.25881571158896
1.16026494561222
1.05414905472931
0.906242544824928
0.638075127553867
-0.00412026279341663

# State 33
0.219984852313818
0.236236751306849
0.254446088995478
0.273980576227155
0.294735743353559
0.316019453943665
0.337490695555112
0.359662883232543
0.382771901071458
0.406418801086636
0.429923217762749
0.453814380426548
0.478153410783778
0.502998137594326
0.528411405869381
0.554442874266722
0.581138795008587
0.608529217410051
0.636605085564714
0.665410181548244
0.694947370049828
0.725255753751018
0.756393343198221
0.788433882278432
0.821491329814482
0.855466996536115
0.890084554029461
0.925545704953493
0.96201284316474
0.999528159177489
1.03821555414495
1.06976709390422
1.08277033804025
1.08027175664964
1.07697814405406
1.07696788375957
1.08511320135533
1.08791441065573
1.0855801640167
1.07671199142907
1.07186667809032
1.06996190122059
1.07227571418001
1.09774746176263
1.11175160694693
1.13021455288975
1.15303858532152
1.16489950330298
1.51741403652567
1.98247836262601
2.45789553370009

# State 34
287.521052392528
274.509585042782
268.468226694227
265.826563570308
264.374080903933
263.266646672762
261.789501831254
260.245690574438
259.602285714289
259.189441517997
258.871010753006
258.362323806871
257.635380484862
256.705644016425
255.212493088805
253.768107163669
252.49603478692
251.43079612965
250.959993303048
250.706488224294
250.354769092551
249.568436989613
248.324952797704
246.838195463128
245.340354763957
243.926260741316
242.469706475614
240.584377145652
236.617510449497
226.295797345895
199.673983412895
155.356670558314
110.873676012887
66.3020918103117
21.6563993793178
-23.1280142674058
-67.9728205027137
-112.997529643447
-158.154537559312
-203.480745188339
-248.970370759914
-294.662415473345
-340.582138731523
-386.761157806526
-433.209823950386
-479.939124643367
-526.964597218153
-575.134170584462
-623.291161397968
-671.758539146643
-720.502918613419

# Control 0
-0.823385592851198
-0.788022971405446
-0.659737207662226
-0.388847718862887
0.0667476690842358
0.428706849391236
0.644133773115766
0.767331176154744
0.838882148036723
0.883490832376445
0.912571601424612
0.931757255522127
0.944062656920562
0.951058393783025
0.95325287178013
0.950997884441824
0.944965717148144
0.935669840451963
0.923500407631148
0.909309920728492
0.893574215654999
0.87518372313591
0.852306263845508
0.824288439146424
0.791403826514943
0.752126836571457
0.702277682098543
0.637889040062472
0.556600599961434
0.453524102211545
0.318350654312589
0.140612744025564
-0.0694895963629768
-0.25440512592211
-0.400719799768946
-0.51446192399734
-0.598026553780034
-0.661074998495063
-0.712494262280281
-0.755476931936994
-0.790918310535162
-0.822009479579084
-0.852220434211619
-0.879953971729528
-0.902019210624369
-0.917497297574247
-0.925295967945347
-0.926473138204347
-0.924047044249527
-0.918791197772546

# Control 1
-0.480741955182587
-0.53706602452563
-0.688703869679229
-0.870683526094528
-0.950693695401092
-0.851125702438246
-0.702453959601945
-0.565376704591127
-0.452549096993409
-0.35782376856599
-0.275387391784451
-0.201115530908718
-0.131814729546439
-0.064483171017431
0.00183345403136365
0.0655727086810693
0.125586311312015
0.182593748371379
0.236717516146149
0.286451061941855
0.332321971877601
0.378198609329748
0.427331668835701
0.479157520661929
0.531729672853877
0.586054317332005
0.645038691642307
0.708797066242028
0.774243519880728
0.838789003662356
0.898811236417219
0.943001079834455
0.950807117191197
0.918862572322531
0.865305418529388
0.803041851958197
0.74297632054849
0.687596742537472
0.634376642065641
0.58271205378046
0.53368549945862
0.484527443347401
0.429463902732464
0.369594074102093
0.311876971030001
0.262755298059841
0.234057523833356
0.229713676458643
0.239240812780967
0.258615686103722

# Control 2
-0.00806963051067262
-0.00789055806192679
-0.00769787148316555
-0.00757405761137856
-0.00743496508182561
-0.00690125000809729
-0.00642700497028422
-0.00599048829147751
-0.00558124032709967
-0.00519113477602015
-0.0048155183729877
-0.00444967017567712
-0.00408810075969478
-0.00372578299574785
-0.00335901647206617
-0.00298777626967175
-0.00261552328438695
-0.00224543744817382
-0.00187982559695624
-0.00151864314475276
-0.00116051131422312
-0.000804663424156521
-0.000449863797102872
-9.56169669765526e-05
0.000259170685488356
0.00061568001620673
0.000974911442257311
0.00133933641621286
0.00171173402308226
0.0020948365958157
0.00249457983981956
0.00291904483897714
0.00332714640234378
0.00367999564723263
0.00403082571553728
0.00438975706557798
0.00475834986892106
0.00513647231690974
0.00552401838396089
0.00592452258943414
0.00634271853066374
0.00677581745920033
0.00722390988248749
0.00770932770929078
0.00830110780110621
0.00918141253382
0.0107132318092161
0.0130637189389287
0.0157592624526672
0.0179725764369382

# Control 3
-0.0405259050337802
-0.0584007788231121
-0.0803621806905703
-0.0785241716840922
-0.0707041592698534
-0.00229257901013183
0.0542567036091067
-0.625518088973962
-0.0119851684504513
-0.085636269731276
-0.741710724494313
-0.141166602375848
-0.0622362385786631
-0.198218291590496
-0.707371355505751
-0.0891381983359864
0.0200123202093563
0.0143748136466867
-0.0360712705107003
-0.0747442505317202
-0.275469875747381
-0.747214490450657
-0.718008878605325
-0.537087405921365
-0.585396790795934
-0.76017615168286
-0.485644475468393
-0.408917288311735
-0.413221036151329
-0.526379420042949
-0.762411970093768
-0.60311742330717
-0.322343492763827
-0.290159372016354
-0.254538633532102
-0.534756464247137
-0.776444866653687
-0.671229991851721
-0.737005682793684
-0.774183909975723
-0.551297042317067
-0.209386774139403
-0.0214049787105037
0.0828908373388703
0.0731964226770591
0.0148659926646178
-0.0725442317660444
0.0434577775786472
0.332231960251092
0.497608659075032

# Control 4
-0.778756661334873
-0.777408632601143
-0.775832465900494
-0.776041752307873
-0.775916288656003
-0.778363416122261
-0.776057213794326
0.466220819763205
0.777249538573413
0.772759138327108
0.233485980833878
-0.764626221853727
-0.775144629191826
-0.753041974169326
0.323585701878659
0.77265572161799
0.777232494316535
0.776528239885342
0.775882967293153
0.77366775595232
0.726749185324996
0.211075609439088
-0.295469888530921
-0.561947507229067
-0.511032328602246
0.158390368984094
0.607287663663485
0.660842923781407
0.657270740013527
0.57108025114433
0.14892556875956
-0.488768575454309
-0.705813758866805
-0.72026664096035
-0.734201514030537
-0.562663558176419
0.00112315764130563
0.392381507058864
0.244294503784304
-0.0512226411414601
-0.546190566551507
-0.74786294739515
-0.776198187643252
-0.771733021311005
-0.7733616495827
-0.776841910661442
-0.772969337982745
-0.775425852770627
-0.702960626912097
-0.598795445956653

# Control 5
-0.000200278088734904
1.38134429729016e-05
0.000229851738316725
0.000411661134728057
0.000596801135571391
0.000790825697848033
0.000986136753410941
0.00144788520787183
0.00132313232567658
0.00151528074574491
0.00209906314186853
0.00196119665715771
0.00212807760329533
0.00235738479513993
0.00281186426289569
0.00257477187942996
0.00270316821147547
0.0028496974685218
0.00303159203220542
0.00319727566437262
0.00343195377387207
0.00396179242734056
0.00419437720495728
0.0042747120007803
0.00447982540681202
0.00471923058955319
0.00457017642990572
0.00467593275016254
0.00479496469411971
0.00503013658997338
0.00545565346557091
0.00568280268813475
0.00575075463713674
0.00596193230761289
0.00615967236993145
0.00643015973345461
0.00660205385593588
0.00649252967976863
0.0067506564251381
0.00702755536816234
0.00723511889688028
0.00736218653743458
0.00759671397284413
0.00770158590378524
0.00792773496464656
0.00810757286912693
0.00820264240945895
0.00815040842002583
0.00779299846207755
0.00689898506917625

# Control 6
0.690745623974454
0.761894406280881
0.725214876351262
0.594016312890042
0.350277202830317
0.0155978866555993
-0.311701460208326
-0.549217624831157
-0.635617725286375
-0.605233486319573
-0.585745516028254
-0.572049602661885
-0.561330402944328
-0.554674787714429
-0.551767001555638
-0.549022792322596
-0.547177517516651
-0.547053170009328
-0.542139417831837
-0.53230228138431
-0.511900779924737
-0.476000025364982
-0.405678885587273
-0.250800111570028
0.115867901344218
0.323776162075077
0.422681466398824
0.474625876082633
0.506077118586592
0.552452389371735
0.567762833838991
0.555702315358682
0.562233727810457
0.591517977504999
0.138500398182456
0.619910781542065
0.474648647009864
-0.749820994836963
-0.662619337297837
-0.579950954614636
-0.44729946416785
0.562572872416198
0.337028907225602
0.428622914955438
0.48751644593586
0.525577821726265
0.721964540544967
0.601265174329048
0.711135821369589
0.715508059595009

# Control 7
-0.656205236842421
-0.345074755970831
-0.00251568946781115
0.306847787437758
0.540837308567957
0.630052687873055
0.569839823843314
0.348601935998948
-0.310097686464422
-0.458505694892223
-0.522815061174095
-0.558182681617939
-0.580633108776419
-0.593358868433087
-0.599420179900919
-0.606201466853214
-0.610415941323048
-0.605281246630961
-0.611746448984258
-0.616046489918982
-0.624076523378001
-0.636880909030417
-0.660032765496893
-0.700948862047883
-0.719308430560315
-0.685959947200493
-0.658993127219121
-0.643761949026449
-0.63709648409228
-0.622310096099327
-0.616975146205404
-0.624771108422505
-0.627176146549152
-0.626336970154082
-0.588295286687044
-0.5844533096584
-0.673823684261863
-0.341350481173221
-0.57102191602935
-0.721291958276814
-0.860688011360585
-0.640215284394111
-0.610886094727933
-0.647461627268301
-0.661210202274631
-0.677063575840103
-0.592928703996927
-0.820559874224313
-0.782386933152534
-0.626790178394159

# Control 8
-0.269777378060396
-0.529742802677671
-0.673571346864447
-0.729494378818955
-0.751080659863401
-0.763379819179362
-0.747593307858062
-0.747118405913384
-0.693694427525475
-0.6359772016015
-0.603227195213439
-0.583987133069324
-0.572397772211683
-0.566166226252582
-0.563239913023236
-0.559148373545112
-0.556521920288781
-0.56211525862111
-0.559434015276943
-0.563756386981693
-0.573951409099191
-0.591589382002251
-0.618851585639809
-0.655482984743768
-0.673229725435823
-0.639006206651082
-0.608348291515447
-0.585443951285441
-0.56628951883748
-0.540282603332929
-0.531866249538435
-0.537337174089005
-0.530678666295629
-0.504111867644859
-0.995637538818829
-0.535595304142057
-0.573657840961538
0.579007151677022
0.506012065171973
0.414381326882049
0.310631761196996
-0.566746746469354
0.756695785077382
0.684642660708663
0.640061289774671
0.602997815640696
0.528625416166613
0.341655006273659
-0.220378315490419
-0.524280774213353

# Parameters
0.448208759676259
0.0714167007163411
0.551974035112154
0.603062257640722
0.439223202836047

# Boundary conditions : 
0 -0.00660979365829695 0 4
0 -0.00107062785749812 0 4
0 -0.000387130909432933 0 4
0 -0.0140319195193692 0 4
0 0.00841416004973722 0 4
0 -0.00176681806915175 0 4
0 353.606983078813 0 4
0 -0.00480068791200416 0 4
0 -0.000391635315761363 0 4
0 -0.000393399664796332 0 4
0 0.00712731786972554 0 4
0 0.00415260355705183 0 4
0 -0.00123706348464452 0 4
0 2.5239126962004 0 4
0 -0.00289131108372764 0 4
0 -0.0013077116354836 0 4
0 -0.000410494510790921 0 4
0 0.0141895487101098 0 4
0 0.0104114936065631 0 4
0 -0.000609059351241864 0 4
0 5.21057734337671 0 4
0 -0.0121062826565663 0 4
0 -0.00110953999410268 0 4
0 -0.000460875317624329 0 4
0 -0.00343343173970734 0 4
0 0.0117381886740713 0 4
0 9.39285982173299e-05 0 4
0 1.30542477886715 0 4
0 -0.133558792135084 0 4
0 -0.00665514826909915 0 4
0 0.000907041386416389 0 4
0 0.00485994090266484 0 4
0 0.00548826302411465 0 4
0 0.00114446607901808 0 4
0 3.76314385633628 0 4
0 0.0332613867330546 0 4
0 -0.0299772195195566 0 4
0 0.000847145457747877 0 4
0 0.00244907190060973 0 4
0 0.00412026279341663 0 4
0 0.00742246629991117 0 4

# Path constraint 0 : 
0 0 4
-0.0465107337131301
-0.0463321442614516
-0.0462571308206456
-0.0464017001766566
-0.0469370259477437
-0.0469773605429761
-0.0469044174786605
-0.0468558147146282
-0.0468184361162641
-0.0467839446776748
-0.0467695281319822
-0.0467745074980975
-0.0467706804314434
-0.0467508042549727
-0.0467394468969096
-0.0467394463507705
-0.0467219874893182
-0.0466776152502001
-0.0466418725947868
-0.0466369793725616
-0.0466301249449019
-0.046594847494406
-0.0465648816213927
-0.0465623409682521
-0.0465554401092693
-0.0465038960665062
-0.0464436005449693
-0.0464290784807024
-0.0464486453325681
-0.0464511065015917
-0.0464723387653194
-0.0465685650377791
-0.0466511404489403
-0.046562043298786
-0.0464036111545238
-0.0462880113962132
-0.0462326207007958
-0.0461468575659812
-0.0460019326225515
-0.0458858389700491
-0.0458447629706417
-0.0457922974651241
-0.0456567194599049
-0.0455482171907882
-0.0455499961836751
-0.0455755996147841
-0.0454999601389657
-0.0453841035689421
-0.0453547984515728
-0.0453365243673612

# Path constraint 1 : 
0 0 4
-0.220189557223322
-0.220400850949197
-0.220016571930912
-0.219995502366405
-0.220868739356867
-0.221632805880593
-0.222047841166029
-0.219848201446739
-0.222656935353173
-0.222508808643287
-0.22240440578543
-0.222449284570471
-0.222358003788607
-0.221303484504417
-0.222124786594289
-0.222215253426866
-0.222505208827709
-0.22333349281531
-0.223273081422992
-0.222723522702815
-0.2227871532704
-0.223534866565952
-0.223561465675042
-0.222654416849885
-0.222913446013581
-0.223483701580168
-0.222394862733389
-0.2228587110832
-0.223611281584846
-0.223319081368716
-0.223159861150729
-0.22367684506083
-0.224041585707218
-0.223461501349694
-0.222903017166565
-0.223729362459171
-0.223526253147561
-0.222468584567357
-0.223531872893952
-0.224091582746225
-0.223916943360536
-0.223343054456037
-0.223469569380922
-0.223789937245088
-0.223141707697174
-0.222973562460161
-0.223590606466855
-0.223314567708044
-0.222444568390162
-0.221400000205585

# Path constraint 2 : 
0 0 4
-0.00979059607958876
-0.0099560057657947
-0.0102316913077795
-0.0104682959281289
-0.0103933757383672
-0.0100715016252446
-0.0096611796521654
-0.00936928088114064
-0.00935252151498955
-0.00954452590334987
-0.0098906894777977
-0.010126459817042
-0.0101182707464955
-0.00990754844644415
-0.00955031642159043
-0.00926635842784007
-0.00917836879744116
-0.00923962416986901
-0.00948736319985555
-0.00970698256975888
-0.00957880902816199
-0.00895443428030063
-0.00843764957027815
-0.00808874063333664
-0.00799785683323673
-0.00818298843487508
-0.00852674894939287
-0.00881697484357169
-0.00869288353969866
-0.0078413485264065
-0.00707771002855317
-0.00608086854490852
-0.00447173302351955
-0.00184154915475054
0.16471791148763
0.00634853706942629
0.00419769670975589
0.00697614519343004
0.0105338316189414
0.0140597038151928
0.0185051568887766
0.0235065812118853
0.0292515806116129
0.0352099955429575
0.0414171456808294
0.0479759052990496
0.073425393981857
0.0731106468392784
0.0800046627405009
0.0861344489917213

# Dynamic constraint 0 (y_dot - f = 0) : 
0 0 4
0.00588682327743806
0.00535974199378719
0.00482683611470414
0.00471670940853386
0.00498525454391752
0.00497186315613529
0.00490084793056678
0.00482438494234261
0.00473745833756745
0.00463972640025201
0.00453425113923478
0.00442751329178526
0.00432083419756202
0.00421685861912957
0.00411172500147616
0.00400739666401284
0.00389943039111174
0.0037928980004942
0.0036839689118171
0.00357993406285173
0.00347387741981864
0.00337536197085475
0.0032774177400241
0.00319389765690969
0.00311415320129615
0.0030545089807501
0.00300168349908692
0.00297070696546831
0.00293861768135617
0.002911339701547
0.00286682149872597
0.00283616156759781
0.00289664164397552
0.0030149600484588
0.00313732655070353
0.00324153144991257
0.00333806515984758
0.00343346707436787
0.00353069881226453
0.00363529648601002
0.0037372583622215
0.00384532586449282
0.00394420115187355
0.00406524588929802
0.0041882580633068
0.0043509383025313
0.00450054941331857
0.00464817197112488
0.00471521407040409
0.00468258866577465

# Dynamic constraint 1 (y_dot - f = 0) : 
0 0 4
0.000725572952206877
0.000437454420453065
-0.000137591134173443
-0.000856247971337432
-0.000424952496014264
0.000112487298714159
0.00043953061059776
0.000646664517697459
0.000795877002091494
0.000911828183546071
0.00100553445125318
0.00108177193924286
0.00114354395807004
0.00119151414640983
0.00122596329807578
0.00124812868764268
0.00125959065819581
0.00126273421879741
0.0012579960774497
0.00124900764934166
0.00123489106621966
0.00121924996790135
0.00119820437004181
0.00117872381899753
0.00115603904108363
0.00114292341972355
0.00113146743260506
0.00113915064196535
0.00114468273673118
0.00115439636026338
0.00109737043088076
0.000912633991233758
0.000611139216881273
0.000431852703652424
0.000348360206617659
0.000327882763424547
0.000325108330453627
0.000325876875804543
0.000326082536993511
0.000322153603061537
0.000321888700724138
0.000320144516540388
0.00032428294094089
0.000320178193771614
0.000317467399293392
0.000306718000324668
0.000302897538450253
0.000302468325801275
0.000323245119037363
0.000373006657134578

# Dynamic constraint 2 (y_dot - f = 0) : 
0 0 4
0.000387315092249522
0.000387515131683063
0.000387802654278011
0.000388109041004146
0.000388201907102283
0.000388326908869237
0.000388526481832762
0.000388780976267405
0.000389076790092723
0.000389407925876907
0.000389769194297035
0.000390157174258686
0.000390567375042962
0.000390996867702269
0.000391441875839777
0.000391900231803924
0.000392368456994769
0.000392844109877097
0.000393323363164898
0.000393803907174587
0.000394282430468611
0.000394756509574906
0.000395222527953615
0.000395677890258489
0.000396119738711592
0.000396545717393393
0.000396953214048527
0.000397340232462962
0.00039770444332083
0.000398043729798694
0.000398350720018828
0.000398613989832056
0.000398820634969689
0.000398995431650256
0.000399139333581489
0.000399248222689545
0.000399313558722227
0.000399329852854451
0.00039929326002619
0.00039919963455861
0.000399047040201883
0.000398831006432239
0.000398549595380313
0.00039819599791717
0.000397768634228399
0.000397260433064123
0.000396672149329175
0.000395997583208893
0.000395232930810077
0.000394370619366854

# Dynamic constraint 3 (y_dot - f = 0) : 
0 0 4
0.0149402211853378
0.0155325064057701
0.0170651987933388
0.0191134937726254
0.0175356813058096
0.0159172556081284
0.0150879000507329
0.0146444179506116
0.014351471357112
0.0141178214727953
0.0139034351484439
0.0136913587746683
0.013471600179553
0.0132423099782195
0.0130024052749619
0.0127478066054219
0.0124729632733134
0.0121707454794246
0.0118398403152353
0.0114710868544936
0.0110681214943513
0.0106230898290924
0.0101481674137283
0.00962779682086534
0.00907682994034964
0.00846659488991541
0.0078193463564098
0.00709642616644679
0.00634855736684514
0.00556017882025728
0.00488292789355604
0.00444044455703896
0.00420754925706923
0.00370392663223384
0.0030056476423006
0.00218907158253323
0.00135715881438081
0.000538848797468461
-0.000260650167833276
-0.00103652364011531
-0.00180662859638048
-0.00256312981724527
-0.00332365976027216
-0.0040615487032527
-0.00479738417531728
-0.00546439704491064
-0.00602823500608585
-0.00647145187415976
-0.00682570146081529
-0.00710551093704537

# Dynamic constraint 4 (y_dot - f = 0) : 
0 0 4
-0.0101269328028509
-0.0111889740375111
-0.0121799199728287
-0.0120933116277109
-0.0110431929379535
-0.010556069897925
-0.010094993043344
-0.00956383326317312
-0.00899879265216974
-0.00841847462448442
-0.00783094941330553
-0.00723360956730357
-0.00663379642538242
-0.00603353924464134
-0.00544764048724922
-0.0048771450290177
-0.00433564387438423
-0.0038164322222487
-0.00333048013028225
-0.00286621503645712
-0.00243958212996009
-0.00203417833541764
-0.0016659426757446
-0.00131135420218076
-0.00099418340161872
-0.000686759381324009
-0.000417940167140252
-0.0001630050849033
2.99966235131066e-05
0.000167365835995081
0.000201124710114131
0.000182140480265602
0.000250276519691728
0.00033931620129346
0.000356793308951664
0.000270635282466625
0.000110762555504351
-0.000103276192582769
-0.000359598266490124
-0.000642180703512629
-0.00096430872401676
-0.00130414564909742
-0.00168507008489804
-0.00204190296557005
-0.00240601242622596
-0.00269946090887618
-0.00301576728742514
-0.00326679682459119
-0.00359618978764242
-0.00406079444997953

# Dynamic constraint 5 (y_dot - f = 0) : 
0 0 4
0.0017638597370746
0.0017604923820286
0.0017567360994331
0.00175248222709051
0.00174777871862045
0.00174308476593552
0.00173839040357439
0.00173359667893129
0.00172864602827676
0.00172350844621579
0.00171816575556849
0.00171260539048017
0.0017068169842397
0.00170079188788307
0.0016945216278839
0.00168799807361328
0.00168121217593861
0.00167415521986997
0.0016668180183092
0.0016591921098138
0.0016512687449301
0.00164303991971212
0.00163449730351656
0.00162563307551933
0.00161643941111259
0.00160690893724155
0.00159703501178127
0.00158681116438011
0.00157623243327479
0.00156529196269781
0.00155398215404343
0.00154228365331424
0.00153016250172419
0.00151758446789144
0.00150455910270836
0.00149109370969111
0.00147719127200657
0.00146284552244461
0.00144804658440931
0.00143278285081438
0.00141704054062289
0.00140080854806199
0.00138407211624325
0.0013668198582229
0.00134902710307977
0.00133067411348735
0.00131172589173049
0.0012921715901355
0.00127200555600068
0.00125130769747636

# Dynamic constraint 6 (y_dot - f = 0) : 
0 0 4
-51.2513916453847
-47.1775279131105
-45.6262023456488
-44.6286985012214
-43.8219353576516
-43.3799833424533
-43.2197704609687
-43.1831430238152
-43.2017686989719
-43.2725322782466
-43.3538788561668
-43.3951483519875
-43.4237583259224
-43.4952809199903
-43.5828147171881
-43.6191241005615
-43.6295247951629
-43.6890473900926
-43.7735594338519
-43.7954526247985
-43.7713370758358
-43.8016026715484
-43.8812909366378
-43.9012137828771
-43.8557539085203
-43.8631339035239
-43.9391036822868
-43.9557923114576
-43.8697269025905
-43.7992186272259
-43.796981895662
-43.7331291457087
-43.5508012727472
-43.4130277567636
-43.4481954330735
-43.542207108148
-43.5334512234182
-43.5056971087985
-43.6387208630468
-43.8447340205797
-43.8997888419719
-43.8452895792487
-43.9065046731542
-44.0228937273392
-43.7792218079782
-42.9390877689053
-41.5562801740928
-38.6985409216126
-30.535627339583
-8.52850626220317

# Dynamic constraint 7 (y_dot - f = 0) : 
0 0 4
0.00479474263510671
0.00476672410948886
0.0047053012538063
0.00461980939639073
0.00453717226522787
0.00447840747730321
0.00443877070887932
0.00439385458455099
0.00431788113910958
0.00421841548032376
0.0041292296003812
0.00408149114942269
0.00406627809078586
0.00403459934193862
0.00395983892589324
0.0038532783119809
0.00376532358932202
0.00373175562294481
0.00373582984628751
0.00372811436877729
0.00366347907220277
0.00356072623288206
0.00347161461369083
0.00344733052449619
0.00347168377839857
0.00346931798328232
0.00340627403356297
0.00330175996723092
0.00323084640566496
0.00322968797154388
0.00326941757042132
0.00328328803759526
0.00321516051381465
0.00310100853577033
0.00302217324499132
0.00304016896114589
0.00310935980910543
0.00313580400720337
0.00308158356271804
0.00296604251141552
0.0028959641288111
0.00291503973097207
0.00298117651274143
0.00300936455892309
0.00294584503154915
0.00284241780190353
0.00277935301224996
0.00281997615221119
0.00289062565823617
0.00289468642873558

# Dynamic constraint 8 (y_dot - f = 0) : 
0 0 4
0.000482298576674367
0.000592760575385043
0.000708336361081585
0.000805389213815566
0.000877354884247339
0.000939350652601867
0.00101643697792131
0.00111772182417758
0.00122616844185242
0.00131037430927128
0.00135470142801797
0.00138860974906008
0.00144891901739319
0.00154835305161161
0.00165490514719435
0.00172161524265757
0.00174127851003725
0.00174544519902176
0.00178663600660345
0.00187624467718939
0.00197965236321762
0.00204285738431631
0.00204275058927816
0.00202766898634321
0.00205291479116321
0.00214113710312791
0.00223584270615396
0.00227308104194801
0.00225345792965159
0.00222101132380326
0.00224648336899325
0.0023361167608078
0.00243557288447738
0.00246493341551624
0.00241281361160839
0.00235468214247359
0.00236083180709423
0.00245209346361142
0.00254627706374633
0.00256403278081496
0.00250234503188107
0.00241952619738406
0.00240813848133792
0.00246010071748692
0.00250123184157136
0.0024444078145347
0.00228003638155272
0.00208247440322262
0.00190971162238762
0.00173731039421821

# Dynamic constraint 9 (y_dot - f = 0) : 
0 0 4
0.000392425264604979
0.000391510428836866
0.000390655048017732
0.000389854287418806
0.000389101689878366
0.000388394303183215
0.000387735656705801
0.000387131895752874
0.000386586814447018
0.000386095553343249
0.000385649106813463
0.000385243819017486
0.000384885692290102
0.000384587119935831
0.000384350710707526
0.000384168584461012
0.000384028297141764
0.000383925071756289
0.000383869138047041
0.000383873977225932
0.000383946811727084
0.000384076846497258
0.000384248530827858
0.000384454799100029
0.000384706507990537
0.000385025778109227
0.000385414748500026
0.000385860572446037
0.000386343710098297
0.00038686004673523
0.00038742651999174
0.000388062394596086
0.000388776523768383
0.000389548837345197
0.000390355181052446
0.000391187963992207
0.00039206955838951
0.000393029907972936
0.000394069464030214
0.000395172139488892
0.00039630632955702
0.000397466986900269
0.000398679667898777
0.000399969359383731
0.000401342770938978
0.000402772155744899
0.000404231711799069
0.000405712429479579
0.000407246447774443
0.000408862213944622

# Dynamic constraint 10 (y_dot - f = 0) : 
0 0 4
-0.0070045769688194
-0.00693928499126095
-0.00689735274524372
-0.00683033121026544
-0.00672781827564084
-0.00662148702924725
-0.00655980616586238
-0.00655692821728959
-0.00657634470081914
-0.0065573666798292
-0.00647306066041398
-0.00638743286103582
-0.00637070982791221
-0.00644193118255432
-0.00653559259410486
-0.00656134327486746
-0.00651477422819835
-0.00646030351994864
-0.00649922888569376
-0.00664584099782584
-0.00682702979571603
-0.00693994801135278
-0.00694428861933605
-0.00694509199345039
-0.00704717709830982
-0.0072883591788504
-0.0075496451173338
-0.00770487408455245
-0.00776945202058177
-0.00783285672942613
-0.00803830987811249
-0.00838935211316882
-0.00876938302885533
-0.00901609855219765
-0.00911547757670239
-0.00923865683617442
-0.00952433421618037
-0.0100148284503927
-0.0105245234185833
-0.0108826402622144
-0.011101494616987
-0.0113113373841696
-0.0117337806628881
-0.0123397307006394
-0.0129555586214933
-0.0133815777977944
-0.0136041200507675
-0.0138242552649275
-0.0141741727309928
-0.0145800101743419

# Dynamic constraint 11 (y_dot - f = 0) : 
0 0 4
-0.00406529457729743
-0.00401934246691038
-0.00403471502053687
-0.0040946530725261
-0.00415312013840374
-0.00417577150189707
-0.00417328032886743
-0.00418826509813019
-0.00426446838454719
-0.00438565457564177
-0.00449195594491947
-0.00453108323638318
-0.00452196678011241
-0.00455322631751987
-0.00466739578033604
-0.00484098136183597
-0.00498353450626876
-0.00503416782266708
-0.00502817500751451
-0.00505433562678448
-0.00519139269431346
-0.00539870815601518
-0.00558283944991178
-0.00565408922658506
-0.00564717951936355
-0.00570445208981685
-0.00587967598091321
-0.0061330230231631
-0.0063237508905587
-0.00639132141778731
-0.00639723340318277
-0.00646497745115937
-0.00669755546457385
-0.00701731254576021
-0.00727006137122999
-0.00734273365617177
-0.00733363135943499
-0.00742852571084285
-0.00768630757918309
-0.00806889022317936
-0.00835886852259904
-0.00847839487581936
-0.00852332434853409
-0.00866193528069914
-0.00900093865030449
-0.00942076447456053
-0.00976193794449909
-0.00989042876284429
-0.00997449520893046
-0.0102192590065711

# Dynamic constraint 12 (y_dot - f = 0) : 
0 0 4
0.00122234567844165
0.00120768537379025
0.00119310318231986
0.00117861281231455
0.00116422319527477
0.00114993998750906
0.00113576661787669
0.00112170500790498
0.00110775609653627
0.00109392022686835
0.00108019741019537
0.00106658743654364
0.00105308981715074
0.00103970366281776
0.00102642761507741
0.00101325994743562
0.00100019874757629
0.000987242103656888
0.000974388213436095
0.000961635450232118
0.000948982442823161
0.000936428148848853
0.00092397189220414
0.00091161320414921
0.000899351515939895
0.000887185788149385
0.000875114352423094
0.000863135036946662
0.00085124546143963
0.000839443329999974
0.000827726585387989
0.000816093541519042
0.000804542965537988
0.000793074189089915
0.000781687068801232
0.000770381700379533
0.000759157864037255
0.000748014458913121
0.000736949297763495
0.000725959254564354
0.000715040665866459
0.000704189629147201
0.000693402156852596
0.000682674112646345
0.000672001043766524
0.000661377846480488
0.000650797983992396
0.000640252051956489
0.000629725604487166
0.000619196552623061

# Dynamic constraint 13 (y_dot - f = 0) : 
0 0 4
-1.99527819548217
-1.67043996519601
-1.45039583355623
-1.2916371005424
-1.17190220755236
-1.07859691244903
-1.00405666920966
-0.943349151165933
-0.893156971272049
-0.851167753129175
-0.815721617727718
-0.785597660542749
-0.759879439478993
-0.7378673705594
-0.719020028540683
-0.702913845818557
-0.689214862696076
-0.677658578274304
-0.668035377935382
-0.660179888466985
-0.653963163483411
-0.649286958677408
-0.646079593524462
-0.644293058249957
-0.643901139891739
-0.644898426953546
-0.647300120427644
-0.651142638658087
-0.656485061853004
-0.663411526052869
-0.672034754096956
-0.682501013239289
-0.694996931001185
-0.70975880641447
-0.727085361306877
-0.747355349274358
-0.771052187450323
-0.798798990543673
-0.831409419409624
-0.86996327377949
-0.915922076376376
-0.971311737635858
-1.03902271157204
-1.12332672145959
-1.23081794586221
-1.37225100521448
-1.56646058712477
-1.8497357020596
-2.30201316795592
-3.138714944936

# Dynamic constraint 14 (y_dot - f = 0) : 
0 0 4
0.00278178485789482
0.0032224379786685
0.0034040886018607
0.00315458402389091
0.00364022599243796
0.00398489443642625
0.00479585703518381
0.000311421982256199
0.000680266467098178
0.000808994787623973
0.00283338518632092
0.00330065511502475
0.00351409821028525
0.000260135091221692
0.00572745388569906
0.00392642370575036
0.00343891425717491
0.00266904819983438
0.00179585943707039
-0.000336395658568023
-0.000904506617759537
0.0070374003796676
0.0133563987853744
0.00769680959081942
0.00300949017559216
0.0133733703360477
0.00485412381063721
0.0069414822452325
0.0140418304168923
0.0108073309464185
7.3647158923329e-05
-0.00238824937960036
0.00367338479439283
0.00720751586293389
0.0024974513565077
0.00585098770086745
0.0119369692568325
-0.00302342808314116
0.000888334081354358
0.0133629148274164
0.0148056234769527
0.0104788789195016
0.00986030897894352
0.00767208609891945
0.00707799609419091
0.00691160397689483
0.00711045962831713
0.00520579350553252
0.00677294295936859
0.0128940036784937

# Dynamic constraint 15 (y_dot - f = 0) : 
0 0 4
-0.000857327466112778
0.00445361122867682
0.00507959643048195
7.62808446013175e-05
0.00199358214182177
0.0063911410889177
0.00147290530201505
0.00390323519533298
0.00710508098444507
0.00621048575791416
0.00445272767037053
0.00732883715314347
0.0130789302654588
0.00211041599796569
-0.000632878208878918
0.00901482408438303
0.00973135269549008
-0.00153756337692545
0.00045268258240716
0.0102712528508384
0.00744494853485
0.00487274977687213
0.00861749111196519
0.00429975415982664
0.00135082682363397
-0.000675570071120513
0.00950595301350132
0.00678054645874271
-0.00273195062441167
0.00161720530841802
0.00292656953303183
-0.00144204640756862
0.00809065783818697
0.0148909438214899
0.00160031078090028
0.00443269022855941
0.00340649797344761
0.0102143553249087
0.00778395335543225
0.00835316403788033
0.0112888699672294
0.000530821988863117
-0.00443468292306104
0.00992969001090382
0.0114400361799551
-0.00292549772004247
0.005242314506544
0.0167017037985484
0.0107701446667858
0.00195497795595967

# Dynamic constraint 16 (y_dot - f = 0) : 
0 0 4
0.000411829933277263
0.000413996957869062
0.000415574347780681
0.000416479978973011
0.000418083999500218
0.000420092944336731
0.000420612698497719
0.000423745772148737
0.000425334637736946
0.000426548503769109
0.000427069037578526
0.000428670037251375
0.000430777228707935
0.00043144442768854
0.000430852052291458
0.000433492587972067
0.000434954997818468
0.000435584274287318
0.000437240938077746
0.000439738814386123
0.000440897405510288
0.000439604787966105
0.000439371320489726
0.000441657043287996
0.000443846881097096
0.000441656900632456
0.000446198359073585
0.00044646613055585
0.000444520667550297
0.000446997721809603
0.000452059580181768
0.000453499481629732
0.000453887516582652
0.000454855267096044
0.000455648602742331
0.000455821584996519
0.000454141294737309
0.000462909814809925
0.000461785534780351
0.000456284708172383
0.000456933531946035
0.000457997338686011
0.00045792802072929
0.000465074287201953
0.000467092799819283
0.000463508621749278
0.000467141115420414
0.000474810196848252
0.00047117670600183
0.000459209160216675

# Dynamic constraint 17 (y_dot - f = 0) : 
0 0 4
-0.00655471047564404
-0.024222903426228
-0.0265977644859512
-0.00843842442764497
-0.0153700095188869
-0.0319504559723724
-0.0115932912270096
-0.0195022992152398
-0.030066872599507
-0.0252767729315613
-0.0179015771309388
-0.0277702448311978
-0.050779585138824
-0.0100921638154563
-0.000966626004824445
-0.036309286605849
-0.0384513606341723
0.00190927544626329
-0.00498352376159805
-0.0372198523698872
-0.0264911646674175
-0.0181241999465422
-0.0315155765063371
-0.0178490553021171
-0.00856045023130703
-0.00177279180238421
-0.0353787700882837
-0.0256996258104445
0.00374848369851088
-0.0092248994105999
-0.0118731802489362
0.00210659618337949
-0.0233761420951311
-0.0413623319634278
-0.00282512781164668
-0.0108949859284655
-0.00720600845764707
-0.0231229093276824
-0.0160727952545523
-0.0167295551462212
-0.0227932926198875
0.00213491419769518
0.0136540284833719
-0.018307700401075
-0.021008623679597
0.0114136263376707
-0.0064368484519095
-0.0322180409122126
-0.0185877355819732
0.00160229733794282

# Dynamic constraint 18 (y_dot - f = 0) : 
0 0 4
-0.0113720573938894
-0.0108775992961769
-0.0107030724816761
-0.0117011902871731
-0.0106743403130016
-0.00976404912919726
-0.00711197812831871
-0.0180246958912467
-0.0165488209339351
-0.016126823970346
-0.0110169381874536
-0.010120617277515
-0.00958729280407544
-0.0170919762312901
-0.00428984032195975
-0.00830234610576075
-0.00919466905171062
-0.0108817226955331
-0.013429568248263
-0.0191567126875665
-0.0219031173082493
-0.00451450177401647
0.00896156106216761
-0.00540120672645461
-0.0173828759323849
0.00607445888563918
-0.0146005967270471
-0.0101237555514038
0.00684775045485431
-0.000910451713586724
-0.0280587990397816
-0.0351468976985583
-0.0206827867660815
-0.0120055902150513
-0.0269114177372627
-0.0186157046032798
-0.00147276681958219
-0.0455831376020832
-0.0359136227575405
-0.00301487043628867
-0.000976108248466723
-0.0141728186650618
-0.0161398111705
-0.0228747859033755
-0.0241572817440905
-0.0244720419739113
-0.0240603955632743
-0.0305510767657166
-0.0268416442242939
-0.00841498286053732

# Dynamic constraint 19 (y_dot - f = 0) : 
0 0 4
0.000592908151466259
0.000576911619475817
0.000561105251311422
0.00054550596887247
0.000530200133737932
0.000514982048825621
0.00049974942154854
0.000484857724841234
0.000470535070425729
0.000456644079207105
0.000442909117258472
0.000429093641656775
0.000415029533875108
0.00040062304882528
0.00038752747810139
0.000373722199281473
0.000361263886186507
0.000348866536015319
0.000335098866804551
0.000322021430808631
0.000310675493800636
0.000298913752604893
0.000285394058612103
0.00027061253091612
0.000257498842426328
0.000245291897487784
0.000230966156028026
0.000219420947671391
0.000206776208130196
0.000191553303905421
0.000177992310768195
0.000167454069137494
0.000157620391580305
0.000144106356333423
0.000128659010768618
0.000117026795369894
0.000103614595619299
8.88139542752214e-05
7.85600140488646e-05
6.64626442873628e-05
5.02756263675436e-05
3.34318929770955e-05
2.09579796309478e-05
9.67037466048648e-06
-7.09122235986737e-06
-2.3795618175157e-05
-3.56101508488527e-05
-5.14354506717662e-05
-7.16431024523068e-05
-8.94728328219574e-05

# Dynamic constraint 20 (y_dot - f = 0) : 
0 0 4
-36.9204558024369
-41.0448192719821
-42.8423805263
-43.9568783964489
-44.7114591290893
-45.5337237207299
-46.931752625921
-41.9892682414738
-43.9275084077389
-45.4505879666373
-42.7519656458475
-43.0488725528299
-43.7111547461524
-43.809129544932
-41.3536992212826
-41.7908222948057
-43.1297990813424
-44.0820541560416
-44.1969494847567
-45.061093427815
-45.6606984763784
-44.2009497717248
-43.3378719541344
-43.6160555031971
-43.4454348526177
-42.471883123941
-43.0661939842306
-43.9329782190511
-44.1396267569655
-44.3152518718777
-44.1603573403284
-43.4809805017134
-43.1680023860059
-43.6173031768623
-44.0383696543254
-43.3482489538364
-43.2186825787642
-44.1651788599057
-43.9119877061
-43.3906501334987
-43.375120549031
-43.1289088018277
-42.5254564564246
-42.5674547953464
-42.2058939397951
-39.9968579132768
-35.6094471004614
-26.0978777112339
-6.19774438372252
-1.53166939753061

# Dynamic constraint 21 (y_dot - f = 0) : 
0 0 4
0.0164234324812886
-0.00120666101468192
0.00427011318360693
0.0193440079401856
0.00900505624895276
-0.000428220509962163
0.0131716086877001
0.0175301893741326
0.00335237399275856
0.00506511445929547
0.0190642208791276
0.0123211000902228
0.00209174769813414
0.0140321427398806
0.019231213359181
0.00611107138829237
0.00786874896870415
0.0197147512149645
0.0134178376264842
0.00597551211492009
0.0149170335145934
0.0183953195372335
0.00963381988703471
0.0100770169617059
0.0188906329956025
0.0161099180496664
0.00928929543520529
0.0158005974441342
0.0204931181656902
0.0123505921911526
0.0123116262204224
0.0206640908791489
0.017072538594378
0.0121523392176042
0.0188603400163803
0.0208523329204402
0.0150367539764444
0.0163180242206464
0.0210164464988242
0.0190163594232082
0.0158621488524352
0.0202543123012419
0.0249858307677189
0.0209616527502423
0.0211030445424027
0.0270802717390277
0.0252138331884015
0.023654324094313
0.0348281982519324
0.128834906509428

# Dynamic constraint 22 (y_dot - f = 0) : 
0 0 4
0.0174174699377725
0.0156265968742517
-0.00103081578930497
0.00585231606430126
0.016981099475882
0.00593095372141195
-0.000550794574769919
0.0114212844040151
0.0130751263939208
0.00125906764467298
0.00431035606550789
0.0146901079368401
0.00764332183825833
0.000780702935816224
0.0101444929689101
0.0119703201257155
0.00239246404006543
0.0045501338774816
0.0117647713303718
0.00698028265857142
0.0025822920966736
0.00798633810553673
0.00965291940585133
0.00408860706238245
0.00373123624878757
0.00844050425457743
0.00695845632161196
0.00286427936494971
0.00566727930378474
0.00831067308054945
0.00453074139200982
0.00333754075123305
0.00659299072213493
0.00581980138017879
0.00296960196745066
0.00415464261382437
0.00586777195992028
0.0043731430689109
0.00320584902003029
0.00426450152842328
0.00471617332821678
0.00347360835893007
0.0023976941018215
0.00270305586633279
0.00399915874623513
0.00324131751537055
0.000826634694810452
0.00241412785008444
0.00500529083009708
0.0067544385111358

# Dynamic constraint 23 (y_dot - f = 0) : 
0 0 4
0.000459480087442191
0.00048749963767053
0.000473307759015218
0.000449629654967948
0.000473457796698412
0.000486965783778298
0.000455372805550164
0.000452251865580344
0.00048612589357945
0.00047289902188398
0.00043750573216482
0.000464964334118481
0.000487242942659075
0.00043979807499453
0.000432356724395566
0.000480940723328438
0.000456661161455124
0.000408751232543358
0.000449309457052308
0.000472366547211556
0.00041187736736796
0.000404827483612119
0.000462046412345818
0.000435904768730191
0.000367612456463398
0.000409808868139655
0.000456649679112409
0.000365859648550043
0.000335040862446984
0.000444833322698901
0.000402753562829511
0.000271313019311561
0.000366923469989136
0.000426533964243983
0.000244967257999162
0.00024056430455939
0.000406165597841207
0.000297991727184983
0.000140465633465821
0.00027275362867258
0.000332045984270307
6.25930981690212e-05
-7.83839267696138e-05
0.000135533986131503
0.000148237054780093
-0.00022537600423797
-0.000205170891116546
0.000101618227439898
-0.000293515592065606
-0.000900631458668935

# Dynamic constraint 24 (y_dot - f = 0) : 
0 0 4
-0.0341824753125666
-0.0291763844539457
0.00930258566593967
-0.00771687246711483
-0.0332168579330805
-0.00718393996149302
0.00690085784691696
-0.0208949615134841
-0.0237254610217343
0.00332538087774736
-0.00454828682075004
-0.0277553743722772
-0.0105873361899356
0.00424121173718195
-0.0174950508170513
-0.0202141577330774
0.00119139508638977
-0.00498236968968158
-0.0205825905883241
-0.00884442329113622
-0.000120310162635029
-0.0130886715491876
-0.0154801919464953
-0.0029839811076835
-0.00386103236577817
-0.0139850498174301
-0.00916539731791666
-0.00126013081060172
-0.00912813809664126
-0.0130926733422028
-0.00386350280298231
-0.00403760853920643
-0.0108695688747757
-0.00668284992411694
-0.00248381168474276
-0.0071977209011278
-0.0086770702009642
-0.00489256458350118
-0.00511384391271985
-0.00768775981891334
-0.00643669366187005
-0.00388963979456491
-0.00492645876491915
-0.00631523637094711
-0.00471110846227019
-0.00452186860631354
-0.00594726000160684
-0.00562262365420851
-0.00502602537503671
-0.00485648566912911

# Dynamic constraint 25 (y_dot - f = 0) : 
0 0 4
0.00305653685545249
-0.0463104437660191
-0.0292328690461259
0.0102942278245919
-0.015651688255792
-0.0372295642164436
-0.00611640635321664
0.00322410774975224
-0.0262545524574873
-0.0227633895325287
0.00428392904300882
-0.00816554994958736
-0.0266925703200074
-0.00605654219108326
0.00312498804489492
-0.0182354599843605
-0.015940652087309
0.00238657924469032
-0.00643568183977883
-0.0176495282185475
-0.00563715654942176
-0.000223318887617063
-0.0118681430346435
-0.0123485456405608
-0.00145793453590959
-0.00403909085874532
-0.0125984473018148
-0.00640916348567555
-0.000444009226984843
-0.00846880615544965
-0.0102586462508034
-0.00228775474671572
-0.00427634608177163
-0.00977275296514835
-0.00561379210282809
-0.00280495595362362
-0.00666206533049785
-0.00734447063867538
-0.00447548109065998
-0.00476316035651303
-0.00697627493760811
-0.00638653124013144
-0.0047241200500765
-0.00531456584714496
-0.00612604982567078
-0.00556407969763928
-0.00527712127093904
-0.00563919266569846
-0.00566209294218112
-0.00555240997513806

# Dynamic constraint 26 (y_dot - f = 0) : 
0 0 4
-0.00011470457790333
-0.000135579445079248
-0.000156282919261702
-0.000176674044737951
-0.000197140587912592
-0.000217643497917114
-0.000238116319645543
-0.000258484058217628
-0.00027887464852977
-0.000299520186623853
-0.000319981894151777
-0.000340291587321101
-0.000361015416291161
-0.000381682369452824
-0.00040201324388292
-0.000422668697151685
-0.000443523306838001
-0.000464046211974684
-0.000484588917339518
-0.000505509374557372
-0.000526377016390689
-0.000546937111029433
-0.000567755475342296
-0.000588926754438029
-0.000609693590876315
-0.000630283660700282
-0.000651496697068071
-0.000672653769127785
-0.000693167229307207
-0.000714144529949584
-0.000735711461270078
-0.000756492889560478
-0.000777012664857774
-0.000798532724493706
-0.000819737342595106
-0.000839870010295035
-0.000860859284352589
-0.000882653234201392
-0.000903185639383991
-0.000923338620988756
-0.00094484655934704
-0.000965921882816606
-0.000984797346830102
-0.0010038762557697
-0.0010253985022132
-0.00104626636851129
-0.00106489260010775
-0.00108661404852953
-0.00111071862660014
-0.00113173825715759

# Dynamic constraint 27 (y_dot - f = 0) : 
0 0 4
-1.21434637212252
-1.13101562725126
-1.05738574549179
-0.993330148723118
-0.937939044619384
-0.890100442577051
-0.848740343040248
-0.812908372775865
-0.781796486870007
-0.754730810709162
-0.731154471041719
-0.710609033763319
-0.692717524405623
-0.677169953413454
-0.663711404058319
-0.652132415966832
-0.642261309897833
-0.633958110487754
-0.627109770252986
-0.6216264527867
-0.617438684854221
-0.614495232486149
-0.612761594960773
-0.612219043870198
-0.612864163915333
-0.614708879491445
-0.617780978531357
-0.622125174712323
-0.627804783810859
-0.63490413335893
-0.643531881952981
-0.653825503131657
-0.665957300111245
-0.680142479776976
-0.696650055914972
-0.715817720053565
-0.738072393393452
-0.763959093917151
-0.794182267434564
-0.829666300450413
-0.871646442534313
-0.921809597775734
-0.982520162689184
-1.05719771684636
-1.15098109943483
-1.27196969833903
-1.43372827410354
-1.66086642786462
-2.00323577383364
-2.57966506449145

# Dynamic constraint 28 (y_dot - f = 0) : 
0 0 4
-0.0100810247034687
-0.0149629524406095
-0.0115120955233017
-0.00556617449311195
-0.00115384585472972
-0.00132300814821903
-0.00521280551781525
-0.0123290460300499
-0.0250914862755469
-0.0250472841761326
-0.02454848524247
-0.0242440286155532
-0.0241981400255642
-0.0242735496419429
-0.0241108427615634
-0.0242109672693702
-0.024757863478466
-0.0243739125081057
-0.0250198813533465
-0.0259423971360059
-0.0275125166946046
-0.0303749484151889
-0.0365970809784166
-0.0526241844779781
-0.0405814087981987
-0.0324419011306156
-0.0289401138883569
-0.0271621987135129
-0.0259212255084755
-0.0230729426415092
-0.0197797946154108
-0.0187105941846133
-0.0168236357455413
-0.0243645767234209
0.0182632956500764
-0.0574500199181093
-0.0464232392375495
-0.0190142887034988
-0.017245284799603
-0.0112724153853169
0.014912508284406
0.00726919061283791
-0.00525272768506115
-0.00791408237680187
-0.00910653826072125
-0.00650444962593924
-0.0155301926997334
-0.00617881770199437
-0.0140194482068096
-0.0337621588558522

# Dynamic constraint 29 (y_dot - f = 0) : 
0 0 4
0.0118109803489638
0.0061088916255962
0.0054452211019925
0.00978772617339252
0.0173357746257862
0.0253859319974533
0.0353433630298303
0.0670828526260103
0.032164841694589
0.0239064703038825
0.0199905294716054
0.0177878846502418
0.0164391634684688
0.0155209331423353
0.0149442002076651
0.0144978926792399
0.0140403605948181
0.0140557948467852
0.0138403435104628
0.0138374157471628
0.0141036672308248
0.0147281236497045
0.0155852600806024
0.0134623161664869
0.00980519017813294
0.0105463186313563
0.0115794066302948
0.0122724609498424
0.0125950730258976
0.0106620355586516
0.00794637872321009
0.00702802852564622
0.00537920965478662
-0.000829495968253607
-0.00751415015134349
0.0463531500525064
-0.0198024171215747
-0.00368658183158638
0.000991536611266414
0.00244089110679947
0.0721145227707677
-0.0365897880550027
0.00824817541011947
0.0108530691002982
0.0104160951341085
0.00547604982945689
0.034365925712169
-0.000995250399460988
-0.00166375280540646
0.0299871631066181

# Dynamic constraint 30 (y_dot - f = 0) : 
0 0 4
0.0134697049487677
0.00868594983472942
0.00382408757746928
0.00258792294483747
0.00289095641254165
0.00419250630570546
0.00604235839089762
0.00533647567793512
0.000364398388172885
0.00137727265235841
0.00223919624594764
0.00291451196404708
0.00344027055833242
0.00387908442137318
0.00437834135893013
0.00475296035805799
0.00497282632267847
0.00572137495716012
0.00611355138422875
0.00662587797935722
0.00733022288109324
0.00833000800564604
0.00944392161989848
0.00769121126486465
0.00434134627181307
0.00495370492508945
0.00598212928186113
0.00672213887368403
0.00701090267616768
0.00563452425813254
0.00365291192948504
0.00286215360419854
0.00124496054328217
-0.0234518133446201
0.00973047567619163
0.0259411863780471
0.0425255396385931
0.00929988815384766
0.00544670762973036
0.00159137368461756
-0.0168043706129215
0.0743597582281426
0.00432287155020891
0.00522894860149349
0.00650048461524646
0.00946567791814121
0.000558111859056978
0.0017664410594734
0.00504038544251758
-0.000846737412451355

# Dynamic constraint 31 (y_dot - f = 0) : 
0 0 4
-0.00497454950333864
-0.0049071526920943
-0.00484110652899084
-0.00481391671536624
-0.00483584222580014
-0.00488234698019641
-0.00491580491564703
-0.00491001232625932
-0.00485665572765015
-0.00478056126400128
-0.00470878425945731
-0.00464137508311024
-0.00457711896695523
-0.00451485775470362
-0.00445424534451266
-0.00439463378504978
-0.00433473407900742
-0.00427569407840478
-0.00421694771376702
-0.00415666599389874
-0.00409337189965564
-0.0040244075400464
-0.00394502377121908
-0.00384709532180905
-0.00374412306802041
-0.00365494739446781
-0.00357540970232817
-0.00350057377404545
-0.00342802900850003
-0.00335916546283688
-0.00329874572556488
-0.00324550126531831
-0.0031971085246596
-0.00312550892788721
-0.00316980928640209
-0.00320017506619763
-0.0030642158348555
-0.00296234782245364
-0.00289289793013348
-0.00284321304772694
-0.00291981045188772
-0.00304813173886709
-0.00310175046550754
-0.00307219779356704
-0.00301909044983795
-0.00295885285253061
-0.00287600072685645
-0.00277767498010872
-0.00266541882081839
-0.00248668567773491

# Dynamic constraint 32 (y_dot - f = 0) : 
0 0 4
-0.00549382328810344
-0.00547525972474983
-0.00543445012369492
-0.0054104168356397
-0.00542516788210179
-0.00547212385253637
-0.00554027771555354
-0.00563701502866643
-0.00573208548803184
-0.00578973687288653
-0.00582613899711193
-0.00584777717188123
-0.00585880753942991
-0.00586196227598834
-0.00585936218183192
-0.00585269444876713
-0.00584251350131892
-0.00583013617142947
-0.00581697915825696
-0.00580267480962049
-0.00578853986106442
-0.00577632592962174
-0.00576768845886066
-0.00575575168525289
-0.00572812198481532
-0.00569243647809725
-0.00566308121257886
-0.00563961605100372
-0.00561974273311194
-0.0055944527321059
-0.00555371515993008
-0.0055013986785839
-0.00544032451493681
-0.00534411777657873
-0.00519270957936313
-0.0051503732434266
-0.00507317813662467
-0.00487685031992346
-0.00475843705650281
-0.00467229659527191
-0.00469360093762661
-0.00460938906517439
-0.00445828673878101
-0.00443612819209349
-0.00442169528374814
-0.00438493823664921
-0.00441689398048939
-0.00438429359419623
-0.00426087644068518
-0.0042292866802259

# Dynamic constraint 33 (y_dot - f = 0) : 
0 0 4
-0.00120513245509388
-0.00130658441552961
-0.00137639932574374
-0.00142368611607741
-0.00146834079638508
-0.00152105740187902
-0.00158791880255682
-0.00166067397277242
-0.00171065237302881
-0.00174509218750157
-0.00178898726318283
-0.00184080025607658
-0.00189903118373158
-0.0019626486398775
-0.00203153391688282
-0.00210542738911346
-0.00218319739063233
-0.00226637580260314
-0.0023556852504224
-0.0024501792060142
-0.00255106829836127
-0.00266012046169728
-0.00277866560576889
-0.00289698115268311
-0.00299794328398961
-0.00309036784708139
-0.00319191567697996
-0.00330316255890195
-0.00342130650764993
-0.00353825977487143
-0.00364492046094012
-0.0037438332780857
-0.00383708293913565
-0.00383397552036113
-0.00384027872181814
-0.00401760218265257
-0.00426626648367412
-0.00448269805429669
-0.00463640026766643
-0.00477189549796742
-0.00483297309302455
-0.00500666306776032
-0.00527318652922593
-0.0054737672276961
-0.00570609635301889
-0.00598154630098313
-0.00625674195522619
-0.00650556130300517
-0.00680300984342908
-0.00712324442973999

# Dynamic constraint 34 (y_dot - f = 0) : 
0 0 4
-31.427996329131
-38.3908703942971
-41.7784473852493
-42.9571222305865
-43.3054601939779
-42.9500193519845
-42.9016084447877
-43.8149572483601
-44.0465623924683
-44.1325677443275
-43.9268179698302
-43.697993458288
-43.4955759053133
-42.9416253734811
-43.0064292424695
-43.1914917035605
-43.4022752841586
-43.9939601951951
-44.2001343799699
-44.0920603011047
-43.6632029939101
-43.2340795907456
-43.0139834513798
-43.0184874999728
-43.1062149356626
-43.0555565577657
-42.6113553263744
-40.5167296689383
-34.1673060009829
-17.9052998358341
-0.244144700128942
-0.121344450104885
-0.0965036929844558
-0.0919237856142239
-0.0213585111166879
-0.0284721494464293
-0.0284943502860955
-0.026175019185871
-0.023277126905981
-0.0203981805586579
-0.0177206573013677
-0.0152980056987531
-0.0130980766275002
-0.0111012615652157
-0.00926623630488166
-0.00756029748526998
-0.00595126025177706
-0.00441607522736831
-0.00292806766981357
-0.00146349557235226

# Dimension of the constraints multipliers : 
3691

# Constraint Multipliers : 

# Multipliers associated to the boundary conditions : 
-232.831785376183
-41.4544675640303
-13.9723358101884
-411.357428032718
276.245502905511
-63.5317294234623
991.405942498286
-167.877820439431
-14.2660907072494
-14.1993251542567
242.35352208746
147.730808332427
-44.5687347406989
995.355835698191
-103.33241818421
-44.2838997792553
-14.8151073100291
415.320428468253
332.913494211396
-21.9740650519674
998.994014051825
-400.996289580095
-44.0243113683184
-16.6144390636374
-48.7402333860871
369.596178062417
3.38590579179013
1005.52044377769
-902.498513135778
-227.542838090539
32.7880411745367
169.938644338901
191.30854685331
41.2732420160071
996.490483919363
666.809916912799
-639.524841815564
30.5442509349389
87.7484444774427
145.567634980664
251.008955171746

# Path constraint 0 multipliers : 
-746.397323630145
-745.755497276033
-745.771451915699
-746.293116448527
-747.26092517328
-747.013965057842
-746.678553020407
-746.466103068158
-746.287467980189
-746.117056314381
-746.040916195869
-746.057840900751
-746.039800863715
-745.950391280004
-745.900894556184
-745.902743306831
-745.828933662451
-745.636062764494
-745.490289198876
-745.490142949998
-745.489419188389
-745.36397333349
-745.272235465816
-745.309971469547
-745.334597085681
-745.155578384942
-744.937020072238
-744.914253935848
-745.025949758479
-745.014127006041
-745.022449967986
-745.270692752138
-745.498661396406
-745.155853649763
-744.526922315466
-744.058722012083
-743.839225231061
-743.450717342161
-742.77862879176
-742.228350059382
-742.026130794787
-741.770874573123
-741.114675770907
-740.575474730728
-740.539799944315
-740.625365209346
-740.233815669463
-739.693110082228
-739.571788206071
-739.557503938775

# Path constraint 1 multipliers : 
-935.741929592436
-937.033815212505
-936.189118265579
-935.250808436281
-936.657097792949
-937.276198230847
-935.952347049482
-936.654636943956
-936.099683446586
-936.958003021157
-937.313173722619
-937.509134069306
-937.844338366095
-935.019667690514
-937.959368491428
-935.318987414457
-936.711071877142
-938.809130391044
-936.658920873177
-935.241196442025
-937.552642423833
-938.695582207059
-938.191640330082
-935.67213150809
-935.911159785467
-938.609037708607
-934.855214879548
-937.647923902324
-938.936424892822
-936.155894813194
-935.009765819566
-936.166067039868
-938.94308081019
-938.272164404741
-934.611332134209
-937.674167427847
-937.93940107363
-934.566090368275
-938.050325901382
-939.128446033741
-937.5539860298
-935.006539463789
-936.081923070534
-939.301505592039
-937.133854663866
-934.612932775325
-938.350257590814
-938.868237390494
-935.666202142656
-934.241062654831

# Path constraint 2 multipliers : 
-317.029899465239
-321.247062922235
-328.271309964219
-334.280181723941
-332.408887644741
-324.198335763912
-313.482213341902
-305.743610267988
-305.110996174702
-310.158332187651
-319.32552623202
-325.483282115246
-325.265715744959
-319.752368379917
-310.267143372949
-302.599928830069
-300.201426566658
-301.873268163053
-308.578323661393
-314.450069885301
-311.030944312764
-294.050686255763
-279.596497550205
-269.665321830295
-267.102559578537
-272.370006454693
-282.154097368642
-290.326424479384
-286.957456761831
-262.702961531874
-239.987084652759
-210.503375749014
-164.516418919339
-111.764682174559
-57.3952582026926
-2.49650564281636
137.846003679751
231.996026952605
336.347109365523
419.340616790372
501.61069288971
572.836351111118
634.256458524017
682.679725881776
721.586450599533
753.77699173922
830.807792530443
830.138581152081
843.553277534748
853.880747127884

# Dynamic constraint 0 (y_dot - f = 0) multipliers : 
206.810817113948
187.826564600901
168.627965588801
164.528159016491
174.112575622565
173.867879322901
171.629149594937
169.19843541846
166.376071188447
163.142958757039
159.606924863346
156.003276428283
152.381404339731
148.839785554293
145.23822009101
141.649518110364
137.911130137086
134.211043496208
130.409183526433
126.776373561108
123.057737496708
119.609063492512
116.173079958099
113.266823151227
110.495771267749
108.470832738622
106.697986121572
105.73988503822
104.733779049117
103.89296501258
102.370021003696
101.293674089072
103.51306338403
107.80178757296
112.174611869298
115.818655591833
119.143186967913
122.399533985216
125.701543369628
129.254927024876
132.688367672096
136.324720768244
139.600994015772
143.670694586191
147.788134796883
153.322704947815
158.345604688946
163.258396413669
165.237349133185
163.633573002304

# Dynamic constraint 1 (y_dot - f = 0) multipliers : 
28.0599705135635
16.8526038707741
-5.51102990754264
-33.5743888611029
-17.35705809976
3.00073871995901
15.3115387833506
23.0540237839599
28.600521411515
32.8898966871609
36.3405619137302
39.1340925233189
41.3869825407356
43.1274149028896
44.3687197535443
45.1572237345018
45.550022401362
45.634843703904
45.4257761298168
45.0599733197306
44.5024261645632
43.8917401917838
43.0805690329682
42.3386850117438
41.4847374996202
41.0124263596265
40.6231760477496
40.9961087180018
41.3206502505509
41.8483917948081
39.8574262411564
32.9936041555123
21.6412359584321
14.970681607965
11.9575661984413
11.3386562634954
11.3735046185984
11.5216000089756
11.6288232799061
11.5590075860488
11.6169037596078
11.6036841202565
11.8016273988038
11.6621148811855
11.5591354349854
11.1308569417325
10.9640907165069
10.9323681938905
11.7307745019302
13.6655467871563

# Dynamic constraint 2 (y_dot - f = 0) multipliers : 
13.9793700310506
13.9869104138903
13.9977425520349
14.009240051621
14.0124404850482
14.0167584123806
14.02385328192
14.0329784327878
14.0436192169397
14.0555518190433
14.0685841391147
14.0825906948314
14.0974056650009
14.1129217934049
14.129000121748
14.1455619217707
14.1624799193096
14.1796654725907
14.196978717789
14.2143361618122
14.2316179547988
14.2487361296767
14.265559503512
14.2819934286475
14.2979361217728
14.3133020272741
14.3279996017503
14.3419577481192
14.3550967072351
14.3673412108325
14.3784182280862
14.3878951504686
14.3952884777078
14.4015561451888
14.406734322082
14.4106687319051
14.413035133214
14.4136314135686
14.4123152744863
14.4089380382768
14.4034305788371
14.3956329403988
14.3854746893472
14.3727063773855
14.3572703590777
14.3389079925238
14.3176489175556
14.2932688736106
14.2656215313077
14.2344398630173

# Dynamic constraint 3 (y_dot - f = 0) multipliers : 
431.638660955139
445.081571766754
479.847946989759
527.976832240068
495.154195807267
459.466150677733
441.002161551955
431.168038219479
424.728246340592
419.64151345539
415.005026226618
410.431815281163
405.67788055909
400.685640303021
395.416046645203
389.764442931328
383.59112089574
376.701441803438
369.038902888975
360.318606026577
350.588681818795
339.559183562245
327.499631075479
313.865892949966
299.006961492941
281.927390269662
263.190231287516
241.396441441324
218.08462403992
192.657220412679
170.441510759619
156.182699330574
149.465059448943
132.77468491539
108.576513722902
79.5594966969462
49.6100161695752
19.9489148571397
-9.08081906488773
-37.157431794075
-64.8488014014421
-91.7399233799778
-118.388057445012
-143.699732278996
-168.375314127325
-190.136990504818
-208.116979285698
-221.971542871799
-233.006106865784
-241.880047405566

# Dynamic constraint 4 (y_dot - f = 0) multipliers : 
-322.471895939393
-351.711171412183
-380.142808969819
-379.802777001728
-351.443352051385
-338.519630653758
-326.289114923114
-311.927353584642
-296.355339960124
-280.012723933901
-263.066695504842
-245.373021300782
-227.132347496404
-208.39696821906
-189.688086167027
-171.079704595244
-153.109987511925
-135.594188229804
-118.992888171145
-102.926685743211
-88.0429878147083
-73.7600241080715
-60.717248216349
-48.0341483505529
-36.6400005139584
-25.4772504088465
-15.6643159538415
-6.24702903519593
0.918834845790122
6.07435410193178
7.34900593938099
6.65132976049784
9.28875540188623
12.761132673634
13.5607435034867
10.4689014333641
4.64397062151544
-3.16562151479685
-12.5104413189794
-22.7783442181705
-34.4869908292821
-46.7937323523341
-60.5919151265332
-73.3792821652598
-86.365297962527
-96.608796638962
-107.673652883364
-116.42858298828
-128.273138570045
-145.273148714749

# Dynamic constraint 5 (y_dot - f = 0) multipliers : 
63.4268000276103
63.3068186028002
63.1725506546109
63.019808097349
62.8503554921565
62.6816823679707
62.5134767545293
62.3419944626607
62.1650605168779
61.9815457470153
61.790768500931
61.592258874034
61.3856296696476
61.1705595686334
60.946735706421
60.713861441625
60.4716077143238
60.2196592515129
59.9576821835494
59.6853693954355
59.4024017060534
59.108487817398
58.8033234946579
58.4866238279927
58.1581037238126
57.8174955788656
57.4645602287479
57.0990658757339
56.7208398547951
56.3296389383915
55.9251945969387
55.5067932918944
55.0731693622329
54.6230387781317
54.1567751200589
53.6746680811797
53.1768454740062
52.6630834549574
52.133021963595
51.5862362778439
51.0222197425644
50.4405704755849
49.8407478795155
49.2223423847835
48.584436549403
47.926307689216
47.2466552449804
46.5451226474291
45.8215682388307
45.0791011388976

# Dynamic constraint 6 (y_dot - f = 0) multipliers : 
-996.726228906002
-998.422717330964
-1002.37042895025
-1007.52721441712
-1003.41754926309
-1000.21887442169
-999.318670085808
-999.228316809396
-999.272150381884
-999.29982421738
-999.291597013542
-999.286501003774
-999.279207496661
-999.291832442508
-999.286013466155
-999.285555857858
-999.245724343408
-999.215461457358
-999.148111747806
-999.115702524759
-999.037758435312
-999.004079432859
-998.915163509418
-998.907800746577
-998.840131913955
-998.903038439704
-998.933976818229
-999.199024829273
-999.468495390928
-1000.00582723797
-1000.28381859806
-999.870437449075
-998.570880043436
-998.208065109892
-998.28374970125
-998.595878460216
-998.840807246071
-999.002167711164
-999.111410139946
-999.13656042274
-999.213201736014
-999.240556151937
-999.407150055581
-999.404041984236
-999.473814250835
-999.203384854152
-999.000687919221
-998.524701735199
-998.26775380572
-998.255347884224

# Dynamic constraint 7 (y_dot - f = 0) multipliers : 
167.89462710656
167.117656217579
165.132795434633
162.270132711335
159.498169539945
157.579077262558
156.347035818618
154.912109161601
152.338282401942
148.889606472056
145.80209624285
144.221025110896
143.825097532932
142.832413519927
140.244926801474
136.481911502679
133.390495650325
132.287752695691
132.568316356974
132.403624747547
130.135169118736
126.440991408473
123.261292331242
122.486631001564
123.507745476316
123.539357312625
121.28502377217
117.479454593335
114.909639916544
114.946625949457
116.523228912976
117.128296801501
114.67722073857
110.489960876643
107.617146450724
108.344816764362
110.985266969851
112.027789742294
110.022685439058
105.757180704941
103.189356883628
103.967134678206
106.512813864287
107.612749932628
105.252734650288
101.36641599313
99.0225165569797
100.559931836143
103.243346759933
103.419016896981

# Dynamic constraint 8 (y_dot - f = 0) multipliers : 
17.4994875727877
21.5049591275854
25.7131279095194
29.2134928299942
31.7516406525462
33.914148182226
36.666783264835
40.3605693262358
44.3351847144647
47.3796441817616
48.8992843180198
50.0154362001244
52.1527581216698
55.7964136315801
59.7158197159066
62.1197492279994
62.7274061127021
62.7559650640044
64.198926624886
67.4952059838095
71.3154926656817
73.5941997346099
73.4680621053101
72.7753504275376
73.6458741970858
76.9153432564203
80.4369966237957
81.7770918770287
80.9344083486531
79.6136564050925
80.4908879665929
83.8171398763969
87.5194833132085
88.5781278697596
86.5570571416661
84.3008047995612
84.4990710306769
87.9021280540742
91.409879992279
92.0222146832901
89.6255295270247
86.4666661740617
86.007117551682
87.9648794691254
89.5123892329269
87.3421777268028
81.0940888026653
73.5901059022647
67.04236761986
60.5018104775798

# Dynamic constraint 9 (y_dot - f = 0) multipliers : 
14.1640901849297
14.1310296887098
14.1001395280216
14.0712329973535
14.0440602701876
14.0185073962819
13.9947100986737
13.9729065684678
13.9532415836745
13.9355278788996
13.9194167604467
13.9047650872312
13.8918059699372
13.8810156600843
13.8724981764713
13.8659481666248
13.8608855625628
13.8571280152363
13.8550667135598
13.8552231040562
13.8578716229439
13.8625974455128
13.8687957652229
13.8761955820782
13.88522170203
13.896722052923
13.9107867083762
13.9269141309677
13.9443487649551
13.9629296837196
13.9833070592867
14.0062311074592
14.0320375679393
14.0599579680951
14.0890559859283
14.1190414597901
14.1507754711422
14.1854070840507
14.2229631430136
14.2628055205053
14.3037260056892
14.3455321695514
14.3892044283371
14.4357162867275
14.4853211347163
14.536949687124
14.5895882578816
14.6429016982132
14.6981229639084
14.7563529005092

# Dynamic constraint 10 (y_dot - f = 0) multipliers : 
-238.501158624558
-236.541129952311
-235.340980036179
-233.282944001906
-230.00526610447
-226.577781529374
-224.638967653495
-224.679504067723
-225.461902097237
-224.919060114
-222.143428571725
-219.272372578078
-218.723578966543
-221.14348730734
-224.296135060426
-225.130269373344
-223.474351414513
-221.540313361008
-222.721467891925
-227.500655866517
-233.380339171883
-236.884325449657
-236.730943424167
-236.428752128236
-239.508788732994
-247.110046835583
-255.277823199456
-259.889913382248
-261.42626986333
-262.908455345766
-268.86325868443
-279.3297469327
-290.513181916916
-297.395564250856
-299.652556137855
-302.542574089469
-310.280580946167
-323.800914260911
-337.50441050714
-346.499215965124
-351.310988920285
-355.871473361996
-366.022642347003
-380.762176804291
-395.213828439055
-404.244408362531
-407.868588850876
-411.323998099725
-417.824166822295
-425.326632757874

# Dynamic constraint 11 (y_dot - f = 0) multipliers : 
-144.40024930724
-142.59204782145
-143.037318495685
-145.11039186981
-147.11468478674
-147.79208113792
-147.536669487795
-147.922281235683
-150.532834766982
-154.778935622257
-158.465967575416
-159.694538692557
-159.166551871575
-160.071607296713
-163.967210170739
-169.966721519416
-174.822778470684
-176.381221518371
-175.911115797659
-176.5963549148
-181.192471138034
-188.255922824736
-194.414723652391
-196.553022713546
-195.961664934095
-197.595837555348
-203.357331141444
-211.768848785716
-217.977640267818
-219.889689434772
-219.645867832865
-221.516964148747
-228.902358183536
-239.151341161976
-247.048746697246
-248.94719639234
-248.13737794124
-250.720877717937
-258.622053571173
-270.32930766764
-278.918924172426
-281.975402554274
-282.640636024526
-286.271981488709
-296.043377187888
-308.183045194214
-317.623442426172
-320.578055535567
-322.114111510877
-328.327983340254

# Dynamic constraint 12 (y_dot - f = 0) multipliers : 
44.0411424681436
43.5153540497909
42.9921680953587
42.4721180437897
41.9555537790071
41.4426992820975
40.9336928535248
40.4286147830257
39.9275075032379
39.430390457553
38.9372702507826
38.448144891241
37.9630015812098
37.4818120054747
37.0045296951962
36.5310938935855
36.0614365905864
35.5954896822735
35.1331891876271
34.6744778031568
34.2193079728395
33.7676447507411
33.3194672132691
32.8747623869632
32.4335133590304
31.99568501856
31.5612179357014
31.1300331904259
30.702043747752
30.2771657219973
29.8553243858576
29.4364592158318
29.0205271199139
28.6075067007608
28.1973967701904
27.7902053038065
27.3859280650066
26.9845268282561
26.5859213791233
26.1899952544328
25.7966111600969
25.4056225340438
25.0168794230418
24.6302260821527
24.2454945273638
23.862491590762
23.48096877197
23.100566862665
22.7207321042596
22.340615638106

# Dynamic constraint 13 (y_dot - f = 0) multipliers : 
-993.445262821102
-991.924500470229
-990.605903492837
-989.414150072169
-988.317296144841
-987.300398704612
-986.355396503392
-985.477191144724
-984.662098744129
-983.90721413425
-983.210131358615
-982.568807136143
-981.981484627802
-981.446644831292
-980.962972206517
-980.529328691639
-980.144733315153
-979.808345897955
-979.519453934423
-979.277462043089
-979.081883557439
-978.932333940729
-978.828525794512
-978.770265295202
-978.757449946227
-978.790067581104
-978.868196595035
-978.992007426187
-979.16176535395
-979.377834729403
-979.64068481646
-979.950897495164
-980.309177176551
-980.7163634078
-981.173446830658
-981.681589413309
-982.242150272088
-982.856719019672
-983.527159622285
-984.255669644132
-985.044863472258
-985.897895947814
-986.818660457574
-987.812137242614
-988.885070096227
-990.047408054796
-991.315614350424
-992.720689943605
-994.328419786202
-996.292103947498

# Dynamic constraint 14 (y_dot - f = 0) multipliers : 
99.2938756548618
115.909831076914
122.779242859822
113.456933990489
131.791012720898
144.841120399487
175.619716451585
6.09973028065555
19.9251433009619
24.7625576844822
99.4151462840709
116.688500550289
124.594675019235
4.09424114541441
204.636586154015
138.672780004155
120.880205162714
92.6595781632012
60.6227761940261
-17.6966569066139
-38.530155169511
251.235765890306
476.947421485269
271.907243216783
103.802119467201
468.249252427716
168.354071790762
241.1562821103
488.453702413595
374.715553232427
3.00296684033316
-79.8629039199937
126.87284085559
246.344771119217
87.3671141315479
200.003998001612
400.065270084281
-91.3969674105995
38.2108401130311
439.09961852877
482.446769805276
345.195893823711
325.795331145346
256.520466079014
237.765805235304
232.580383886107
238.793091106207
178.538436267248
228.290351512846
426.471222019068

# Dynamic constraint 15 (y_dot - f = 0) multipliers : 
-37.6502576746949
161.097431163478
183.286335073056
-2.64786244468416
67.852347927114
227.785994760969
48.7492980881564
137.096000280736
253.779399662219
221.403386985358
157.764479575995
261.442739619458
467.207976069697
71.7483369223122
-26.6422845214037
319.836833062209
346.171136156517
-59.7048684144737
11.9253189282738
367.015043590788
265.268778220761
172.222458331029
306.810816790558
150.088578808418
44.8193333202686
-27.3296880226173
336.062922207755
239.490384994752
-102.697322469795
53.9467921865434
101.32889318423
-56.2223370478245
286.085464171425
526.112580499379
54.0581672646291
153.535406813644
117.566986818371
357.497864707756
272.768539758577
293.078027355245
395.179295932198
17.1523918172364
-154.106632345904
342.227739743026
391.658852932714
-95.8212461871568
179.68857255446
560.504143027148
360.993349223888
71.976097882741

# Dynamic constraint 16 (y_dot - f = 0) multipliers : 
14.8624061279368
14.9419274186959
14.9987876961714
15.0297853785677
15.0878483673689
15.1616115622927
15.1779212356108
15.2957288738917
15.3535847815284
15.3970307319619
15.4141758988027
15.4725862381322
15.5505692011943
15.5730461593774
15.5473410991308
15.6461555872114
15.6994964611983
15.7207111889597
15.7816238522606
15.8750599604532
15.9168470940072
15.864198315956
15.8524813997028
15.9378547418424
16.0196367019298
15.9325391702327
16.1051520583814
16.112769131617
16.0349612721187
16.1279358090419
16.3209637836853
16.3740024302208
16.3863029119258
16.4210376605321
16.4489901261969
16.4532526567255
16.3862832985574
16.7225526818977
16.6770260858056
16.4626952217907
16.4855665093554
16.5243494535321
16.5191987654353
16.7926426224916
16.868185735843
16.7274366446215
16.8655605824303
17.1594240604303
17.0164770968432
16.5516797469377

# Dynamic constraint 17 (y_dot - f = 0) multipliers : 
-253.068742924899
-617.881811183106
-656.225193078919
-306.348370273478
-435.883557854478
-722.394286140893
-374.453128169451
-508.716123956266
-700.711788412352
-618.094607631051
-483.950970179043
-662.583001381673
-1060.90481313432
-347.643263367711
-183.657960375437
-814.856419631943
-865.574928011581
-108.432852089999
-234.612587476092
-872.228429770546
-663.842243573891
-495.148276254175
-763.270379538725
-484.726602671522
-308.269557507442
-174.147653212299
-843.282672379936
-659.140363596701
-18.8264079256401
-302.991272761459
-364.745793111518
-27.0521297626776
-644.540333606994
-1081.64544521068
-146.55439351452
-341.243599176046
-248.42833662145
-669.877265166871
-491.724180768283
-520.341964012558
-708.150428332908
41.5846803038341
390.596905796871
-578.557951467456
-658.24020383647
312.250398701752
-218.708018041225
-961.039080996324
-561.721073020505
-2.81784165669717

# Dynamic constraint 18 (y_dot - f = 0) multipliers : 
-358.268685671609
-343.004384345689
-337.377892764245
-363.621916112554
-335.804593865749
-311.457771681338
-241.036160890399
-547.130220811581
-505.821579857239
-493.212313720738
-354.00252092438
-326.726185859474
-310.677391595019
-535.15713095954
-149.725657317301
-275.846652637797
-303.550157553852
-354.95102970207
-430.619095026247
-597.306355598353
-667.840601073317
-162.359503437555
229.298623259423
-188.859271730843
-532.98947660308
145.293119843881
-452.701532763414
-323.083365706464
133.637218705146
-83.8332722886472
-774.654263466
-934.553014534265
-568.496077471745
-366.603538115299
-685.997002305631
-507.090932266094
-142.102935841599
-1076.17680627414
-867.435623863071
-180.876521787559
-142.184031896989
-412.627015819769
-450.786783639756
-576.970123203991
-597.346802287371
-601.40368423534
-594.45541941898
-714.058350719284
-642.838986564697
-312.056875914049

# Dynamic constraint 19 (y_dot - f = 0) multipliers : 
21.3927998836433
20.8167015615023
20.2471751595793
19.684908974153
19.1332708354667
18.5843534536608
18.0342402152775
17.4966934316579
16.9806117750119
16.480641636032
15.9861840647562
15.488248819378
14.9802726539227
14.4586600131841
13.9873032639345
13.4882770052666
13.040913328117
12.5955712799699
12.0969884432883
11.624781180394
11.219195106547
10.7973352336817
10.3075030111955
9.76891100006612
9.294713303902
8.85555419334268
8.33460078153509
7.9210274684699
7.46496770288547
6.90929511315255
6.41786862017361
6.04340528183591
5.69637493729863
5.20734976921524
4.64388003571169
4.22808952301776
3.74385002803275
3.2063208455022
2.84471954504665
2.41224295791079
1.82216937676705
1.20715350754809
0.761454149963638
0.362126340732337
-0.248178454572189
-0.855698301216091
-1.27364997957113
-1.84593881258689
-2.5868565743612
-3.23519327575522

# Dynamic constraint 20 (y_dot - f = 0) multipliers : 
-1017.27635035665
-986.604218287396
-984.10862058674
-1016.73229733965
-1002.21364623887
-968.34381641684
-983.024050764245
-1005.39732898256
-1019.25161443868
-1015.97298565054
-1007.84600280241
-994.734782020179
-957.086998637392
-1027.2140824422
-970.701825999932
-1026.86011343272
-1032.20403321754
-963.003462415972
-977.276393332121
-1040.11597271488
-1029.92930115365
-988.58345005475
-951.466528325094
-997.346278839561
-1028.76022237792
-953.812114915056
-1037.56011316972
-1017.76303074483
-946.793438821574
-976.99829170636
-1032.34804900134
-1055.83197667574
-989.262222440878
-943.847460317795
-1033.25409342687
-999.263540448377
-956.583227806806
-1052.72488648747
-1028.78113397781
-967.585899898513
-951.992755709661
-1020.99987462315
-1053.61870400868
-967.310878286778
-962.280149649361
-1055.68070671195
-1006.0216795109
-928.543922072871
-958.904459276338
-1033.50646294959

# Dynamic constraint 21 (y_dot - f = 0) multipliers : 
536.506292256252
-24.4461510194149
149.384048077548
618.283261755551
296.303132568397
8.60277186485388
420.273789414193
548.07369679496
127.457042517564
178.483145067262
582.726900596919
386.837021574156
97.3125569428315
432.520697745263
574.191015671656
212.911497856161
261.302796005109
577.22537071749
408.313655042313
213.629812460748
445.017677271614
533.102249712298
309.009062863526
320.317974526523
536.974957029103
466.618054395589
302.292789776882
456.528729028931
564.752994021834
374.744977437364
373.728176933574
562.95630544391
479.658114158966
370.126762243973
513.907430337155
554.050387808359
430.832325771411
457.002474849642
554.172377806989
511.199569090146
445.781005180214
527.544715196462
607.06249183121
531.418965323778
530.556585797511
623.387510179056
592.958755071462
567.457044844917
679.835185867563
899.672903393203

# Dynamic constraint 22 (y_dot - f = 0) multipliers : 
576.883958337804
517.165468365912
-24.5918551801441
199.062545003028
560.756495968443
201.678558475482
-10.0602539698
381.798764178734
435.946472208668
48.8552772559599
148.68814402246
488.780042794966
257.959958456257
32.2316464917371
341.96074628287
404.023264911651
84.0988979381099
156.37416519375
398.25041025444
237.868863267433
90.354772998777
272.13596747449
329.950008566599
140.876404772096
128.652142850196
292.443495488935
241.068505417483
98.5065397950355
196.38891606678
288.946759442188
156.983266148064
115.199967706217
231.585938928285
205.076034986376
102.691580779183
145.679373341627
208.001848293836
153.919621086313
111.612710544862
150.619097654583
168.046325173116
123.070400789638
83.6570466378022
95.5009106513778
144.919577901846
117.503026799472
26.5425244415869
86.1204189543314
179.640824204727
230.54444035218

# Dynamic constraint 23 (y_dot - f = 0) multipliers : 
16.5598057272075
17.6411163922205
17.0933626014181
16.1796590477588
17.1005640714702
17.6238380321716
16.4060597321362
16.2880102561232
17.5990280898666
17.0915825748612
15.728885577626
16.7935537118921
17.6583646424442
15.8322130224524
15.551638658669
17.4344748560787
16.5048893992461
14.6630332000364
16.237171670665
17.1367583538562
14.8099731389458
14.5473332118973
16.7699746923279
15.7749883694644
13.1540752933805
14.799754983149
16.6234668746415
13.1336684734603
11.9598830717569
16.2139370511774
14.6078844817328
9.56046685014426
13.2876819629449
15.6323474285006
8.65426329141975
8.51536322876225
14.9465213111256
10.792809970147
4.72940297362669
9.91243955313956
12.3164091781191
2.05975247207797
-3.2255089009659
5.15504931903948
5.77400621419434
-8.52202377971636
-7.67560330230014
4.18829998591629
-10.5120848666603
-32.5632035442173

# Dynamic constraint 24 (y_dot - f = 0) multipliers : 
-983.246560788293
-843.443082855577
204.679079028163
-257.599786731838
-955.798462564709
-242.008985337494
150.608367583292
-628.058492446314
-709.104059784487
54.7230121745621
-166.598927097377
-822.729701812098
-337.287727860297
87.4836437053347
-542.148953535258
-628.200223192428
11.5433924674275
-173.74267560123
-642.862045361997
-289.701053857122
-27.7534250050202
-418.75357377698
-497.066355478911
-108.011304273163
-134.399887428439
-463.832978707664
-306.726432814436
-49.5556054007968
-305.143876421713
-433.834505457629
-133.941174026874
-139.192764456813
-370.317750949427
-229.86933845171
-85.6115210145845
-247.502730928826
-297.802508764967
-168.110018894146
-175.639253974456
-264.776495439983
-223.036774377742
-134.602875349097
-171.912114303575
-221.16330053597
-163.797291443406
-156.735779625837
-206.396472834331
-195.103042257265
-174.885260857411
-169.774048114922

# Dynamic constraint 25 (y_dot - f = 0) multipliers : 
-84.4604601301697
-1057.83756459994
-730.25963445608
120.766303505174
-449.543358524549
-966.443922156791
-223.403413579766
15.5043268048853
-743.743775258288
-661.497434104445
72.9404150039936
-268.51838435842
-801.021643735483
-207.109043103242
67.1245142411433
-574.937410024767
-510.485002606432
59.0097048231115
-217.408318187835
-578.450666894267
-192.11261817931
-16.1563311234035
-396.965735282881
-414.713283372311
-53.3781638232077
-139.314841665137
-429.868022394971
-220.224411903753
-15.9402750379007
-291.334770708269
-352.715738664302
-79.1389551757792
-147.559456245155
-338.338238360425
-194.466149634736
-96.5496627277121
-231.816842063359
-255.731082653093
-154.8434662325
-164.72275914285
-241.67964690728
-221.395273583041
-163.664191238946
-184.53520732604
-213.327651112091
-193.769742147739
-183.538977562958
-195.96794601024
-196.915453774784
-193.493874757836

# Dynamic constraint 26 (y_dot - f = 0) multipliers : 
-4.13721330147136
-4.89227931322723
-5.64065681277455
-6.37689617894532
-7.11597259730716
-7.85637480382545
-8.59553194823444
-9.33054049790428
-10.066339877534
-10.8118897681196
-11.5502338116739
-12.2825994738606
-13.0308478113147
-13.7767814985109
-14.5096214008086
-15.2548785680679
-16.007701887778
-16.7475888865691
-17.4881043107809
-18.2430609459186
-18.9958276340787
-19.7365637264883
-20.4871225872828
-21.2511708134702
-21.9994849404955
-22.7408507442059
-23.5061044861377
-24.2690325716542
-25.0069599998482
-25.7625827115034
-26.5407447627255
-27.2884787362251
-28.0260718066366
-28.8022404577509
-29.5662254039349
-30.2887822186139
-31.0442253322518
-31.8304685867476
-32.5677712266748
-33.2903866085398
-34.0656430521852
-34.8250969863566
-35.5009210376746
-36.1853984542338
-36.9644626166503
-37.7188325934142
-38.3868956891743
-39.1730363314581
-40.0523997621455
-40.8222410941887

# Dynamic constraint 27 (y_dot - f = 0) multipliers : 
-994.723979728137
-990.116945690071
-987.854644338094
-986.490219300331
-985.481968461929
-984.628898986196
-983.857614791827
-983.142069895479
-982.47349619858
-981.849231213978
-981.268633670412
-980.731636256031
-980.238265404655
-979.788506013471
-979.382282415981
-979.019473634776
-978.699934970737
-978.423517445476
-978.190083314428
-977.999517961331
-977.85173898252
-977.746703253748
-977.684412634203
-977.664918817262
-977.688327723122
-977.754803744649
-977.864574104183
-978.017933547511
-978.215249587263
-978.456968513576
-978.743622407755
-979.075837432411
-979.454343729599
-979.87998733643
-980.353744649656
-980.876740129298
-981.450268167141
-982.075820377046
-982.755120053347
-983.490166267112
-984.283291181267
-985.137235906242
-986.055253039648
-987.041248783609
-988.099985878638
-989.237384029654
-990.460984885358
-991.780713183187
-993.210216505188
-994.769463521014

# Dynamic constraint 28 (y_dot - f = 0) multipliers : 
-325.099564451514
-436.770578321811
-361.133280245419
-193.315101807313
-41.5713146049036
-47.62575559278
-181.752842276521
-380.319987885041
-590.09985187934
-589.621151851997
-583.878802063872
-580.301294091891
-579.76273905697
-580.664968199723
-578.735181047861
-579.935263327486
-586.352821071037
-581.878268063306
-589.376330561986
-599.662764014227
-616.107278248385
-643.033767198061
-690.717153825885
-770.786704098355
-715.268977933128
-660.346080004966
-629.999031198572
-612.553229102946
-599.421851850146
-565.857083133815
-520.487070796642
-503.739062620822
-471.637949263815
-751.796897892905
666.747540264876
-791.067260156673
-743.00106332984
-508.659922669038
-479.281368705921
-355.37854937902
435.843899393332
246.553068326006
-183.225736525906
-265.528366539142
-299.287274902351
-223.123069360173
-448.049008128905
-212.931474666828
-417.751713278128
-670.617216590519

# Dynamic constraint 29 (y_dot - f = 0) multipliers : 
368.413476750032
210.71682920368
189.499240888636
317.639428899885
480.946068777065
593.492368758513
682.098937941234
814.528525937569
658.111691661852
576.317334986494
523.700960172384
488.737306579731
465.077250185386
447.892864982576
436.627815076239
427.650124400129
418.204326445884
418.527733138375
413.997072161709
413.934658700135
419.525206086613
432.308195656631
449.126029281928
405.917993155605
318.141357817857
337.376801472104
362.940934888413
379.289974073169
386.679843567073
340.209966426893
266.480663198078
239.129405176783
187.139047260773
-28.6691173101953
-263.02837222996
753.957424073485
-521.181796180922
-130.726000766713
35.7048943515842
87.4355309130091
825.987862969387
-690.526260091303
275.187398412432
345.100900823222
334.044620079863
190.521639691242
674.992954212885
-35.8778470799359
-59.8417217257389
639.6023069553

# Dynamic constraint 30 (y_dot - f = 0) multipliers : 
406.071243995495
287.625671395301
135.514479166729
92.6215522864798
103.249884123272
148.030422749771
208.632314485715
185.978261650511
13.1528281055079
49.5976510815884
80.3149231100625
104.076058474615
122.337125163463
137.39369188387
154.297057321841
166.809515884472
174.081564398904
198.412096743455
210.885899182282
226.883306684651
248.307166318746
277.549382762018
308.482332687226
259.017069043415
153.056227560951
173.45268852411
206.728482274045
229.845288745031
238.644090143111
195.479102754412
129.623037043753
102.201521045946
44.538072723766
-814.930820900543
313.238440851671
597.318795265054
732.447604308804
304.670205072674
189.542825444393
57.2488314287191
-471.484234302745
830.74102865523
152.445881897982
182.489294478991
223.003972148229
309.061765083936
20.1472394261494
63.5014446041526
176.300653368899
-30.5282786174601

# Dynamic constraint 31 (y_dot - f = 0) multipliers : 
-173.797117689551
-171.636744566667
-169.498515929393
-168.630438427379
-169.379324708514
-170.93472300807
-172.05423324134
-171.875489697951
-170.122735380441
-167.611325202041
-165.235757791864
-162.99915766536
-160.862123724979
-158.786652495915
-156.761629001159
-154.765744941149
-152.755985793753
-150.771104864434
-148.792321709575
-146.757988825404
-144.617832107309
-142.28107180655
-139.585006837819
-136.25008846294
-132.733500546471
-129.680460754014
-126.951758424457
-124.379934877333
-121.883119162521
-119.509575585116
-117.424232529371
-115.584965905191
-113.913806308366
-111.318244049071
-112.867132053981
-114.054020897322
-109.312713940403
-105.754113964784
-103.322403004012
-101.580572415906
-104.255766960764
-108.731488148545
-110.60033640584
-109.575578594764
-107.729925158914
-105.633397428107
-102.745630799567
-99.3094215162134
-95.3715322055739
-89.0786338599477

# Dynamic constraint 32 (y_dot - f = 0) multipliers : 
-191.340183704501
-190.646111360558
-189.263932641707
-188.445258318097
-188.898065691447
-190.402825861786
-192.59557539531
-195.705846538615
-198.753633325232
-200.596901507858
-201.759102389248
-202.449507953751
-202.801618711596
-202.902867092345
-202.820820884934
-202.609179826999
-202.285575713361
-201.891643064147
-201.472376573538
-201.016126324292
-200.564925288528
-200.174765666861
-199.898653560983
-199.516781795111
-198.632115074157
-197.48824021645
-196.546465408591
-195.793342765648
-195.15546507038
-194.343007867657
-193.031826767068
-191.344702478693
-189.370459022521
-186.254251977833
-181.300981053643
-179.89952453551
-177.376417919353
-170.907938800277
-166.985164838155
-164.120660301297
-164.827773184125
-162.021417867091
-156.967755637907
-156.22322329522
-155.737130748187
-154.500685432676
-155.570337989861
-154.471863735596
-150.314510307463
-149.25045367142

# Dynamic constraint 33 (y_dot - f = 0) multipliers : 
-43.4435723864495
-47.0784469729689
-49.5777522684213
-51.2695599102024
-52.8670330620248
-54.7526629783133
-57.1431713452038
-59.7424501130075
-61.5266442349103
-62.7555018176359
-64.3210073990144
-66.1677434659853
-68.241650622487
-70.505412603686
-72.954195910538
-75.5781073724609
-78.3363155078327
-81.2823899950888
-84.4409127532394
-87.7773098675329
-91.3330630922873
-95.1687615191484
-99.328883820433
-103.470833045195
-106.997208870109
-110.218797695752
-113.750850532572
-117.611080778029
-121.700142433773
-125.737813956898
-129.412699762654
-132.816403416726
-136.023713408447
-135.762042421302
-135.939472772212
-142.125565240632
-150.53663700837
-157.810246468443
-162.942386731086
-167.445739611743
-169.468835916246
-175.201378800993
-183.93041706341
-190.444123842773
-197.927716867296
-206.7132005363
-215.393977822274
-223.153086699334
-232.310114024504
-242.019036260526

# Dynamic constraint 34 (y_dot - f = 0) multipliers : 
-998.138469614887
-998.855533655798
-999.131468091058
-999.238586622738
-999.279813812339
-999.289698389017
-999.287726543623
-999.291433744209
-999.310035713916
-999.299183889318
-999.295972129572
-999.295947356615
-999.29726409764
-999.299444092461
-999.299282695581
-999.298445372924
-999.297856882318
-999.293585554337
-999.292644562991
-999.292477813261
-999.292036100966
-999.287024385166
-999.269812024558
-999.237268901881
-999.151842092258
-998.893467329402
-998.226647669276
-996.488692308903
-991.936055431053
-980.016372218543
-948.988475618355
-927.288473752225
-939.501534037613
-1022.88945737067
-507.587326951214
-588.56675250113
-605.199982820579
-591.52992736389
-563.076796928925
-526.82458806002
-486.055750595078
-442.739324705844
-397.484706120565
-351.031413597086
-303.5122928355
-255.069330605812
-205.69465458043
-155.532906941835
-104.531834393721
-52.6784896753213

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
78.7553068331045
65.6075919774863
40.8518358606531
22.711693787536
12.986860727459
9.69402731375598
8.42385652878208
7.83665130326685
7.53171726949959
7.35332836074897
7.24151686506035
7.16959485351985
7.12421314399792
7.09866907067856
7.09069468405222
7.09889141633511
7.12091002243041
7.15511093042034
7.20038517617485
7.25390971418316
7.31420396924715
7.38595732237012
7.47721131628163
7.59209558111439
7.73153053737639
7.90494385407575
8.13657083198319
8.45663716843997
8.89851682254616
9.52984653259168
10.5071201749793
12.143778988803
14.8842855725211
18.5779228151375
23.1187893707464
28.5418022675471
34.483445969957
40.906741751065
48.2325146885234
56.7219885168074
66.3502076482152
77.9564710577813
93.9132587925265
115.62688116201
141.671357724427
168.237969287622
185.789322359573
188.784141738673
182.798003982427
171.042844074991

# z_L corresponding to control variable 1 : 
26.7575394876966
30.0409139283583
44.8837384086851
108.851887326819
281.514787963854
93.0533857709823
46.5477908268946
31.8674569375392
25.2993727361839
21.5672779157179
19.1135544791519
17.3365818270212
15.9527660874518
14.8046261890512
13.8246360022185
12.9976959459202
12.3047119819242
11.7115974582283
11.1991045284442
10.7662140149113
10.3956032351196
10.0496205965146
9.70373425005011
9.36378021040438
9.04241810323005
8.73270590140666
8.41956262977773
8.1053608236724
7.80630242368207
7.53219993709143
7.29403096386791
7.12810879895788
7.09958466102376
7.21777896492499
7.42505176904413
7.68152310310402
7.94631943590005
8.20715878649316
8.47448587061722
8.75119174866517
9.03101398962903
9.33014131926841
9.68962547770407
10.1132467445867
10.5582012298206
10.9688869789043
11.2239433174741
11.2636563570181
11.1772116156505
11.0054336901864

# z_L corresponding to control variable 2 : 
13.9626148102928
13.9600946242406
13.9573835041827
13.9556423104311
13.9536882004149
13.9461894141271
13.9395326064659
13.9334110369316
13.9276767952234
13.922215172885
13.9169604513028
13.9118461908398
13.9067954351532
13.9017379007833
13.8966220130853
13.8914475541709
13.8862628474759
13.8811121567547
13.8760274847468
13.8710080678346
13.8660346327482
13.8610964454517
13.8561763091088
13.8512673234748
13.8463543328088
13.841421014574
13.8364535867735
13.8314179914344
13.8262760132106
13.8209902120343
13.8154790921106
13.8096319148069
13.8040148064905
13.7991619916588
13.7943403343354
13.7894108152852
13.7843522488418
13.7791667405595
13.7738560416909
13.7683720626069
13.7626505056688
13.7567300500212
13.7506100061176
13.7439862696166
13.7359198269837
13.7239380131585
13.7031383142902
13.67134468372
13.6350649749433
13.6054193852549

# z_L corresponding to control variable 3 : 
14.4360183114535
14.7104140059405
15.0627792218618
15.0315387111336
14.9039715220137
13.883514829921
13.1389546803047
37.4090960097938
14.0230659757963
15.1583234782685
53.5692279262589
16.1393529352963
14.7782210998162
17.3055343989355
47.2924378517178
15.2142030468387
13.5840443673871
13.6574709722075
14.3704870349127
14.9762975375384
19.1388651301907
54.7747329220802
49.1122454697165
29.9204847972802
33.3856569790967
57.7431784639881
26.9518092056518
23.4597113227874
23.6207251794923
29.2435524711897
58.2964589574539
34.8903936040659
20.4322701841035
19.5148178642955
18.58038843638
29.7572723714258
62.0195691790234
42.1141839208176
52.6553234166167
61.4121419865636
30.9049308883275
17.5185461914664
14.1509991372387
12.7893130544983
12.905262829579
13.6466121248057
14.9311297140389
13.27458863165
10.3973695036249
9.24909059354611

# z_L corresponding to control variable 4 : 
62.649513440998
62.2736340439213
61.8265163235142
61.8909176918937
61.8632540141206
62.5257805030529
61.8817710423496
9.5183320653313
7.7933390667906
7.81341739442809
11.2575237909638
58.9535341178271
61.6559832658627
56.2156475398448
10.4849820893809
7.81375652343759
7.79338246335256
7.79649665179192
7.79931286271355
7.80924769686241
8.02282414085228
11.4443206333996
19.6645956190034
31.6785607785075
28.3843698872512
11.9636814863371
8.62140655826775
8.34240547502224
8.35992076714373
8.81937043125135
12.0639244911206
27.1013310613659
47.1495658774097
49.5364029930002
52.1384858785462
31.6927218480409
13.8425724866415
9.95828793561631
11.1416561807472
14.6082282813493
30.4943931984307
54.913306851283
61.921397504669
60.6968949718624
61.1576482053073
62.1008207615662
61.0530781501839
61.7061796852019
46.6559953516352
34.5138896714085

# z_L corresponding to control variable 5 : 
13.8527174021964
13.8497514292902
13.8467601982138
13.8442441717822
13.8416816922084
13.8389982548845
13.8362989886396
13.8299199802549
13.8316430528283
13.8289880798863
13.8209312609289
13.8228329729611
13.8205296560153
13.817373993932
13.8111058100791
13.8143771960924
13.8126057068568
13.8105825254595
13.8080829519473
13.8058069404664
13.802571732644
13.7952831515263
13.7920893980115
13.7909943819767
13.7881777791055
13.7848827685998
13.7869422953534
13.7854811829706
13.7838430206341
13.7806287479806
13.7748021036218
13.7716852445482
13.7707406763474
13.7678534609863
13.765165385072
13.7614501101265
13.7591001206535
13.7606149566489
13.757069059105
13.7532795591658
13.7504527219445
13.7487339701454
13.7455275672663
13.7440757441136
13.7410062428487
13.738570907159
13.7372511018283
13.7379609369229
13.7428503511042
13.7550544650318

# z_L corresponding to control variable 6 : 
8.19158670487582
7.86079077851042
8.02792213353368
8.6886757366133
10.2571231003181
13.6377030900609
20.1243164074524
30.731106911722
38.0146086004305
35.0854402806
33.4342467205794
32.3640344459168
31.5731063868537
31.1011880882749
30.8994166169489
30.7113908570981
30.5862457830731
30.5778517531822
30.2497044473226
29.6134593526183
28.375667364967
26.4315984607373
23.3043288207458
18.4869929941473
12.412207631235
10.4624973042916
9.73509961208688
9.39217181151244
9.19604815930617
8.92134312969094
8.8341962963996
8.90281579068752
8.86632630502139
8.70700034696763
11.3829135281217
8.54514324320618
9.39240643373855
55.4100309105686
41.0624019345711
32.9730458512033
25.0588854839625
8.86351974030956
10.3588514862194
9.69467135206335
9.31080414569971
9.07849220015944
8.04307339782555
8.64934312062129
8.09397382039205
8.07334423738446

# z_L corresponding to control variable 7 : 
40.2878510345771
21.1475739308949
13.8848206575551
10.597950359725
8.98857244585374
8.49659386335497
8.82250265037467
10.2699812243293
20.0753496106175
25.5774514151014
29.0245565209951
31.3480414003644
33.0262771424786
34.0598607609755
34.5752548067653
35.1706651778178
35.5511487705175
35.088686201616
35.6729939426049
36.0725225416126
36.8430855677893
38.1423247272881
40.7400402174214
46.3144260309195
49.3434386013087
44.1035307792592
40.61565404718
38.8790212054135
38.1648869711719
36.6706651881053
36.1600748826019
36.9113159510372
37.1487208382489
37.0641780958698
32.6156320531285
33.1577457941535
42.469291106207
21.0476787001733
32.302315943374
49.6994869515324
99.4226549987034
38.4957829713948
35.5981039245037
39.2907105825562
40.8838282100967
42.8906388310039
34.0239146527783
77.1877368371636
63.6468210348575
37.1109449282543

# z_L corresponding to control variable 8 : 
18.966983765746
29.4524033447895
42.4296360865756
51.2014505984815
55.6418402339608
58.53430714827
54.8743641897746
54.7734943214576
45.2205257196234
38.0482640647839
34.9071963745506
33.292606704782
32.3902078399424
31.9249356010682
31.7110314042528
31.4167166949715
31.2306514484971
31.6295856181645
31.4370871006478
31.7485771636868
32.5083113675846
33.9122749193729
36.3379785857662
40.2017813992937
42.3855086961986
38.3673558839463
35.3639751560289
33.4102895942441
31.9352785409356
30.129251187682
29.5876779143085
29.9444466850413
29.5542295053877
28.1709156936504
62.5566929808319
29.8865625175618
32.4864770347281
8.7713226689524
9.19646914620377
9.79227780453826
10.5674609715748
31.9677324345665
7.88405667128672
8.22126532387072
8.44474754728312
8.6400047846931
9.06036612357845
10.3230164364289
17.7659344805636
29.1150127182238

# z_L corresponding to parameters : 
30.9010442032814
192.57072510052
25.0973429101078
22.9875533713507
31.5331835033714

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
7.5965214934642
7.74706025125067
8.34742034526068
9.97976856056859
14.8471872068021
24.2434385829825
38.9212733913035
59.5363864740498
85.9795746291691
118.89737863593
158.439689854399
202.979409069146
247.640453661268
283.069306006044
296.403324177184
282.800555032797
251.828285132384
215.458851966522
181.203031021945
152.866653378429
130.278435969343
111.094154941712
93.8931976135769
78.925715361868
66.4846898945488
55.9492651463157
46.5785195229508
38.2916437633989
31.266001008549
25.3627345551472
20.327468413703
16.1185142180148
12.9500205696622
11.0415245113118
9.88843585940804
9.14580589645766
8.66748488218486
8.33841505524491
8.08796753848115
7.88986703593667
7.73367604546894
7.6016623171558
7.47762793027046
7.36727303367053
7.28177003262061
7.22296837210401
7.19369924300886
7.18930548322067
7.19837954774151
7.21812045368105

# z_U corresponding to control variable 1 : 
9.35565002018794
9.0126655336079
8.20287566746011
7.40402358498279
7.10003159836573
7.48190529928504
8.13527593233565
8.84768484640626
9.53493511243317
10.2001035251641
10.8593883531205
11.5308879668735
12.2369389448494
13.0109826097005
13.8754333343666
14.8219396637151
15.8392950423648
16.9441401984082
18.1459907547029
19.4113453784012
20.7458601384406
22.2778944018033
24.1914321384108
26.6019686481893
29.593615733314
33.4852598242124
39.0619603701139
47.6346551855965
61.4722198757461
86.1085728918039
137.088325373266
242.97166802885
281.649396522652
170.710236747197
102.91445067328
70.4067267709983
53.9533233127944
44.3838396454165
37.9182241348028
33.2191982727566
29.7235162916074
26.8864827838089
24.2891655848021
21.9799623823612
20.134277808242
18.791274577169
18.0864905028753
17.9847829633534
18.2109892546608
18.6892719361026

# z_U corresponding to control variable 2 : 
13.7390748740073
13.7415158841203
13.7441437869954
13.7458326073616
13.7477289123353
13.7550157388598
13.7614974405051
13.7674688505017
13.7730719038014
13.7784171137663
13.7835677151704
13.7885880782759
13.7935533211719
13.7985324315797
13.8035763399658
13.8086855310664
13.8138124587176
13.818913317107
13.823956210253
13.8289416260458
13.8338884831221
13.8388072996679
13.8437151065883
13.8486187396379
13.8535333376806
13.8584752953474
13.8634585506806
13.868517507344
13.8736909586872
13.8790171550849
13.8845790936205
13.8904899235536
13.896177643609
13.9010989462808
13.9059955384718
13.9110087798574
13.9161607513247
13.9214499016765
13.9268750463527
13.9324860420897
13.9383497119684
13.9444275603579
13.9507213857789
13.9575459366113
13.9658748583929
13.978283037032
13.9999270530737
14.0332691909878
14.0717018805646
14.103416681783

# z_U corresponding to control variable 3 : 
13.3121693053102
13.0869110764787
12.8198813052371
12.8423318226227
12.9365320322104
13.8189973523113
14.6452622322075
8.52399245946374
13.6897620453502
12.7604094858058
7.95173738299211
12.141576419808
13.0415091175988
11.5639754884195
8.11181569318664
12.7206924354464
14.1339956339621
14.0551629071006
13.371387200089
12.8888372326231
10.8603676761043
7.9268707066401
8.06147614793096
9.00997123685134
8.73592238226833
7.86870092527638
9.32334589997066
9.83090028775049
9.80189190045134
9.07435627604574
7.85855270520477
8.63995097687537
10.4741637199538
10.7342714739533
11.0393051141376
9.02464133930903
7.79695351861653
8.28698256136244
7.97329613688007
7.80709046735689
8.92844380479043
11.4510659845117
13.5609469552659
15.1025159389412
14.9391592913581
14.0591715810628
12.9141659019287
14.4780379151424
20.7387342494596
27.5921827205163

# z_U corresponding to control variable 4 : 
7.78667449432108
7.79264012601137
7.79958763099666
7.79860311611151
7.79916033910615
7.78838383945233
7.79840260032045
26.3188847072369
62.2292653810956
61.0112626915548
18.127863579802
7.84965013654524
7.80280634706202
7.9023399128826
20.5473853525435
61.0059008492137
62.2141870936472
62.0160957188972
61.8578384074742
61.2471142440691
50.7723741044587
17.572900898123
10.6935353446399
8.87033454785213
9.16867515606363
16.4717412210375
35.3856024437509
40.9152184819229
40.5210587034511
32.3965254908204
16.2876615674397
9.30236410717807
8.11975641279454
8.0519498490881
7.9867987717297
8.86295506184949
13.8746987628214
22.8552654537214
18.3471149132984
13.1813946826336
8.95745906443881
7.92410417026837
7.79777926875226
7.81752303784248
7.8102740953593
7.79494031034938
7.81206033547585
7.80126211836588
8.13273589346246
8.66266597522537

# z_U corresponding to control variable 5 : 
13.847169520305
13.8501343870903
13.8531270759953
13.8556463321799
13.8582139850332
13.860904880067
13.8636137557605
13.8700239016323
13.8682912437182
13.8709613313361
13.8790766024711
13.8771593835384
13.8794816174641
13.8826657147981
13.8889990427501
13.8856922143729
13.8874825026408
13.8895282768866
13.8920574294015
13.8943619603808
13.8976403641191
13.9050375327185
13.9082837954623
13.9093975264611
13.9122638782921
13.915620074079
13.9135219270774
13.9150103065427
13.9166798074992
13.9199578818781
13.9259078733291
13.9290949974607
13.9300614793367
13.9330171025595
13.9357710615744
13.9395812000574
13.9419931849866
13.9404382068182
13.9440792473967
13.9479746111077
13.9508833404137
13.9526528442041
13.9559565839861
13.9574536286763
13.9606206491931
13.9631350756437
13.9644989758126
13.9637654377327
13.9587175527732
13.9461496330518

# z_U corresponding to control variable 6 : 
44.7846743048189
58.1677668639771
50.404576002002
34.1149774161549
21.317150694417
14.0698932170526
10.5590380757674
8.94007741894516
8.46772989731149
8.62797618999551
8.73400138328956
8.81009071087965
8.87057469865607
8.90854947576583
8.9252427649602
8.9410546632626
8.95171869292896
8.95243828904545
8.98096440412239
9.03862161707898
9.16058971551457
9.38340790406651
9.85284904220702
11.0729733733729
15.6658170365364
20.4819204795711
23.9907416327898
26.3628718416294
28.0420369125277
30.9482852322048
32.0436682864356
31.1783596242952
31.6654319842277
34.0308557131974
3.82219258146541
37.3695226415518
26.3801084359944
7.91523907247397
8.33027359493972
8.76603737378255
9.56947536353504
31.6627414184562
20.8919330076524
24.241237071898
27.0266972096233
29.1947388727476
49.8148533814123
34.735377297119
47.9473406269023
48.6842143511923

# z_U corresponding to control variable 7 : 
8.36243103862195
10.2967664191725
13.81513650592
19.9811740820798
30.1646508742081
37.4384703388742
32.1982233977799
21.2632793364806
10.5716682214689
9.49595076170041
9.09492924519066
8.88849167026787
8.76224398370479
8.69226187317542
8.65932083369355
8.62276155187301
8.60019561878988
8.62770476841309
8.5930962132154
8.5702312661491
8.52785668847105
8.46114812372768
8.34314417514313
8.14245059837961
8.05549942568523
8.21483943890761
8.34837140197382
8.42572817197148
8.46003432832945
8.5371430859998
8.56531191993984
8.52422153494751
8.51164956006026
8.51616403940085
8.71786889369332
8.73824457683049
8.27452878291517
10.3269969036778
8.81611956705206
8.04623843809434
7.44342358067213
8.44394671099474
8.59774908279411
8.40684639695991
8.33725148180449
8.25843386045949
8.69460912947913
7.60748630635966
7.77041533332999
8.51363031771656

# z_U corresponding to control variable 8 : 
10.9073931222807
9.05374876932568
8.27564938273375
8.00805486436469
7.9093364255504
7.85417148329213
7.92512507693296
7.92728703251277
8.17734659575507
8.46582956319661
8.63876139307786
8.74369135933287
8.80813625732723
8.84318248002567
8.85973659486469
8.88298658133141
8.89797568748718
8.86611532204284
8.88135948061745
8.85681040858652
8.79944143873752
8.70192558202964
8.55538062681121
8.36607196950431
8.27734140369007
8.45018168161262
8.61125955400493
8.73566935795121
8.84251308368892
8.99183534785358
9.04124260520909
9.00922334579838
9.04908780273639
9.21250684436261
6.34045240581839
9.03610301022014
8.80118118960545
32.8980851875535
28.0385291332696
23.6512241993756
20.09151740077
8.83990589143139
56.9259465348258
43.9193753440779
38.4799080940189
34.8874457756448
29.3826140072861
21.0377552442498
11.3491372995644
9.08621615521705

# z_U corresponding to parameters : 
0
0
0
0
0

# Cpu time : 
322.263

# Iterations : 
1000
