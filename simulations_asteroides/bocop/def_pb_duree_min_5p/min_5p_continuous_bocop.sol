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
# 3.122559
# -2.322743
# 0.00176
# -5.216904
# 0.816549
# -0.002421
# 1.155682
# 0
# 0
# 0
# 0
# 0
# 5.406835
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
# 2.332281
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
# -1.907398
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
# 0.001333
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
# -3.846369
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
# 1.937963
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
# -0.002135
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
# 9.650854
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
# 1.348842
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
# -0.746027
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
# 0.000453
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
# -0.935025
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
# 3.407403
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
# -0.002178
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
# 9.650854
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
# 0.413442
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
# 2.140795
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
# -0.001284
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
# 4.026494
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
# 0.413443
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
# 2.140795
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
# -0.001284
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
# 4.026494
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
# -0
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
# 0.115502
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
# 0.598068
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
# -0.000359
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
# 3.398912
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
# 0.826557
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
# -0.562849
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
# 0.002338
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
# -0.189622
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
# -0.981857
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
# 0.000589
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
# -0.189622
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
# -0.981857
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
# 0.000589
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
0.343039530764988
# L2-norm of the constraints : 
10649962.6801102
# Inf-norm of the constraints : 
997409.018595208
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
3.11752933380696
3.08811638839123
3.05874807077299
3.02944492008558
3.00021817009979
2.97107792251682
2.94203236803533
2.91308737975855
2.88424628821881
2.85550983980777
2.82687633511204
2.79834189551573
2.76990079549371
2.74154580267313
2.71326848684804
2.68505948194498
2.65690869687331
2.62880547860534
2.60073873457325
2.57269702247629
2.5446686150023
2.51664154591976
2.48860364277567
2.460542550278
2.43244574724684
2.40430055929466
2.37609416901913
2.34781362489365
2.31944584943588
2.29097764674869
2.26239570912441
2.23368662208005
2.20483686675743
2.17583281772168
2.14666073280646
2.11730673002549
2.08775674408741
2.05799644945263
2.02801112733252
1.99778543968478
1.96730305266173
1.93654602690839
1.90549384619188
1.87412193518527
1.84239945415265
1.81028605884523
1.77772718076189
1.74464705297881
1.71093800050768
1.67644302747921
1.64092428379188

# State 1
-2.31482423177924
-2.30644611666983
-2.29778560345552
-2.28887823040446
-2.27974987776582
-2.27042307200875
-2.26091490174047
-2.25123690473694
-2.24139589879879
-2.23139511093814
-2.22123525772121
-2.21091543811951
-2.20043380364714
-2.18978802768089
-2.17897561985082
-2.16799412831675
-2.15684126714297
-2.1455149957679
-2.13401356936568
-2.12233557334807
-2.11047995013561
-2.09844602258429
-2.08623351595356
-2.07384257878062
-2.0612738020446
-2.0485282354276
-2.03560739909109
-2.02251328895741
-2.0092483730601
-1.99581557615747
-1.98221824959447
-1.96846012357937
-1.9545452398503
-1.9404778642359
-1.92626238040229
-1.91190316785843
-1.8974044674373
-1.88277023495487
-1.8680039752172
-1.85310852827523
-1.83808575242883
-1.82293600271461
-1.80765724332097
-1.79224358823881
-1.77668299256653
-1.76095376711913
-1.74501958325586
-1.72882264539981
-1.7122747309993
-1.69524589162278
-1.67755093833438

# State 2
-0.0413534417519972
-0.0540538257501297
-0.0568818048304041
-0.0570305959857781
-0.0562797469374848
-0.0551849758689632
-0.0539583999512249
-0.0527019651768948
-0.0514753778582892
-0.0503167284001676
-0.0492492314094078
-0.0482840654476292
-0.0474223036436605
-0.046656727248957
-0.0459736045455414
-0.0453543141815534
-0.0447766750491047
-0.0442158915539587
-0.0436450792100261
-0.0430353777859212
-0.0423556815622738
-0.041572021110176
-0.0406466242627714
-0.0395366719903525
-0.0381927540246535
-0.0365570262376769
-0.0345610847934308
-0.032123612704267
-0.0291479417051019
-0.0255198336376365
-0.0211060517744942
-0.0157546764759619
-0.00929855738878704
-0.00156353677809067
0.00761741836119844
0.0183849900393218
0.0308334773667903
0.0449973318268667
0.0608506362444301
0.0783195091369962
0.0973005938094959
0.117677799890296
0.139333622024791
0.162155594997628
0.186040620930516
0.210901270741531
0.236681743889575
0.263404215117203
0.291311044627864
0.321324726656372
0.356684177553884

# State 3
-11.8041162639201
-5.21623316571425
-4.14148928942098
-3.75460126789562
-3.6137640025861
-3.56210766648701
-3.54305915542877
-3.53600631825195
-3.53338605806576
-3.53240926539499
-3.532043553997
-3.5319057114276
-3.53185317270649
-3.53183278973991
-3.53182469490934
-3.53182141792122
-3.5318201067534
-3.53181962878249
-3.53181949154631
-3.53181944288719
-3.53181932527148
-3.53181902478169
-3.53181845518639
-3.53181755486483
-3.5318162875072
-3.53181464352459
-3.53181264105853
-3.53181032614171
-3.53180777154359
-3.53180507393608
-3.53180234887652
-3.53179972288109
-3.53179732102357
-3.53179523828156
-3.53179347311349
-3.53179176364378
-3.53178916276412
-3.53178291016496
-3.53176542076221
-3.53171624805575
-3.53158057405368
-3.53121033093728
-3.53020357562315
-3.52747245611403
-3.52006327306063
-3.49992594116353
-3.44500756197354
-3.29445551938529
-2.87853360895856
-1.71594782782367
5.35303371515491

# State 4
8.53483710990182
3.98952063019042
3.1121033644326
2.80535761135526
2.69645470584321
2.6573711179084
2.643237077899
2.63809860396445
2.63622435952368
2.63554012668982
2.63529121550083
2.63520196245461
2.63517137780262
2.63516237268327
2.63516129398991
2.63516310308598
2.63516593762308
2.63516911435258
2.63517239508661
2.6351757166699
2.63517909112157
2.63518256805879
2.63518621902382
2.63519012892296
2.63519439122502
2.63519910465145
2.63520436956953
2.63521028383697
2.63521693847713
2.63522441414639
2.63523277973804
2.63524209367651
2.63525240284321
2.63526372654138
2.63527601110063
2.63528900377996
2.63530186753663
2.63531209772214
2.6353125653197
2.63528379882235
2.63517558269453
2.63487269576913
2.63400792760674
2.63159189256118
2.62490498966428
2.60640954916042
2.55507771822875
2.41163984872031
2.00570699284725
0.830852732136444
-4.98068349962246

# State 5
-3.26293759637572
-1.60702560954096
-1.20643061221287
-1.09708782797567
-1.0664341736663
-1.05795771203114
-1.05571880063817
-1.05519086102544
-1.05510767185695
-1.05512605296478
-1.0551580913809
-1.05518370153732
-1.05519960439924
-1.05520611290139
-1.05520399097042
-1.05519382667706
-1.05517596118188
-1.05515050871575
-1.05511737472994
-1.05507626107139
-1.05502666036739
-1.0549678417403
-1.05489882831035
-1.05481836543373
-1.0547248786104
-1.05461642004639
-1.05449060219802
-1.05434451666091
-1.05417463781944
-1.05397671285895
-1.05374564362108
-1.05347537183219
-1.05315878571629
-1.05278766970167
-1.0523527234963
-1.05184367284926
-1.05124945922885
-1.05055841445357
-1.04975814102528
-1.04883431043711
-1.04776601454317
-1.04651023901123
-1.04495177573478
-1.04274310526748
-1.03879340727145
-1.02963764589607
-1.0042152963723
-0.926990850498421
-0.681706042504489
0.134107080846838
3.16671349439969

# State 6
18.0831416824713
11.9651349804372
11.387094069869
11.1692553360642
11.087124665065
11.0561376564971
11.044436500598
11.0400138948934
11.0383406909022
11.0377069262152
11.0374664096316
11.037374728458
11.0373393634044
11.0373252728001
11.0373191861133
11.037316085142
11.0373140815632
11.0373124739256
11.0373110098561
11.0373096049509
11.0373082353509
11.0373068949189
11.0373055783876
11.0373042758306
11.0373029689287
11.0373016269388
11.0373002046384
11.0372986424145
11.0372968669133
11.0372947895105
11.0372922984639
11.037289240173
11.0372853919359
11.0372804200601
11.0372737790523
11.0372644579174
11.037250410139
11.0372271270542
11.0371838868617
11.0370931486792
11.0368768430787
11.0362764448146
11.0347234833293
11.0306570409803
11.0198869658084
10.9911637670164
10.914089167352
10.7058282400117
10.1389768125955
8.57866072323596
-3.19034272387107

# State 7
1.63102561314952
1.6246174817409
1.60781040149401
1.58834771404804
1.56772251819467
1.54649783777877
1.52496524065663
1.50329131716742
1.48157368097557
1.45986917431766
1.43821018575425
1.41661456107709
1.39509178260645
1.37364689230184
1.35228307438372
1.33100346678159
1.30981251875666
1.28871702792041
1.26772703683954
1.24685686675308
1.22612645095812
1.20556267179474
1.18520064941638
1.16508536709623
1.14527366130816
1.12583478872971
1.1068445842508
1.08837205866733
1.07047364588497
1.05330649662212
1.0373791499534
1.02318842585886
1.01081784417272
1.00028022026323
0.991494135434772
0.984347671983702
0.978705362113488
0.974458073200898
0.971520985768024
0.969812830123599
0.969239124558064
0.969686012465355
0.970983176542821
0.972745649113413
0.976122811730312
0.979109208538538
0.982124857756679
0.98623360759057
0.992247956958568
1.003380486074
1.02968112974394

# State 8
-1.66399426610335
-1.64427463403284
-1.61354511903093
-1.58124481390735
-1.54831776384753
-1.51501174185678
-1.48142244929717
-1.44759359401893
-1.41355015218601
-1.37931054409201
-1.34489166269224
-1.3103114865795
-1.2755905619097
-1.24075210869678
-1.2058198907276
-1.17081345313202
-1.13574223658368
-1.10060211382872
-1.06537621164484
-1.0300367316827
-0.994545949010194
-0.958862211771372
-0.922949344942789
-0.886778591128776
-0.850328483086099
-0.81359551662831
-0.776588087995619
-0.73930111687361
-0.701739730819496
-0.663922132739933
-0.625876103765015
-0.587549401932539
-0.548897457006391
-0.509873589618676
-0.470454040126558
-0.430623982785318
-0.390369663298722
-0.349676432528379
-0.308533262233268
-0.266938060653367
-0.22491523229052
-0.18258656446394
-0.14025755500125
-0.106262466782131
-0.0869641738074401
-0.0843629506539457
-0.0835856329200712
-0.0826171883234753
-0.0810300497936415
-0.0743382841643008
-0.0159992805527127

# State 9
0.343618380725905
0.348359309605457
0.34782593027527
0.345422399143432
0.34195882075331
0.337809385813042
0.333180267334774
0.328193581623727
0.322926062888918
0.317428537962421
0.311736222774371
0.305874353945341
0.299861368874529
0.293710777841421
0.287432336264313
0.281032838944011
0.274516691637733
0.267886319542521
0.26114243673374
0.254284204496182
0.247309273668317
0.240213648123091
0.232991354659219
0.225633969511542
0.218130061692527
0.210464508091474
0.202617518027059
0.194564270034382
0.186277993401226
0.177748490584712
0.169015488867485
0.160108408267865
0.151019097444156
0.141745647059834
0.132271802907014
0.122574824976461
0.112627542014573
0.102419102368088
0.0919727831164412
0.0813603652300122
0.0707316893228857
0.0603543999447888
0.0507272972849817
0.0420486788186504
0.0338034557157582
0.0277592266787972
0.0237979929327839
0.0201757066221285
0.0166565372347024
0.0109826283471388
-0.0022274047493323

# State 10
0.209795965399734
-0.703768642940198
-0.94443088200187
-1.05351215543773
-1.11301023568128
-1.14692941411234
-1.16577474934151
-1.17502407562076
-1.17786466597516
-1.17629672566615
-1.17164887173378
-1.1648337721306
-1.15648421199411
-1.14703016547601
-1.13674635155431
-1.12578296639382
-1.11418606311213
-1.1019074177858
-1.08880875252579
-1.07465226922281
-1.05907561412107
-1.04155217956849
-1.02132380297417
-0.997313267266818
-0.968075590446926
-0.931999669060423
-0.888092106780226
-0.836744898345163
-0.778454123827027
-0.711690731843401
-0.636665817593258
-0.558591889675864
-0.478916970673738
-0.398343463085259
-0.317060800122033
-0.235136268323703
-0.152579338070738
-0.0693619740712454
0.0145878456712726
0.0994020310145916
0.185320855111308
0.273031470867123
0.364794746185481
0.465730454562524
0.573903402821227
0.694891578793844
0.819648594263555
0.951896553677258
1.1014243333694
1.3017167839818
2.36617460985573

# State 11
0.675050071805554
1.68381955928276
1.88549413833712
1.99415362570193
2.07229841138831
2.13575576484112
2.19103604059157
2.2412064205347
2.28788477763074
2.33201938549161
2.37422274332115
2.41492506936487
2.45444940552533
2.49305074675011
2.53093788003758
2.56828658957376
2.60524833111737
2.64195629925212
2.67852972704534
2.71507699130552
2.75169764472948
2.78848306063722
2.82551550480919
2.86286553837692
2.90058727373676
2.93871234381299
2.9772520012382
3.01622565557757
3.05571027883771
3.095834332451
3.13663333451862
3.17804351554204
3.22007999773423
3.262741808045
3.30599021509189
3.34972098283309
3.39374694931945
3.43779958120902
3.48157120014735
3.52477233954014
3.56720413759778
3.60886630772483
3.65014093521594
3.69348717932575
3.74456428004585
3.82114210696512
3.93012935187108
4.0908247115153
4.35211847877821
4.97326714452083
6.67151272549084

# State 12
1.47268113963918
1.00729418016213
0.824656187065229
0.708647555338324
0.623789467448658
0.556644456336027
0.500501184601255
0.451690606017434
0.408066432818848
0.368296686835718
0.331508208448361
0.29709844292295
0.264631332976549
0.233777495239255
0.204278605599418
0.175925447621971
0.148543896494301
0.121985640303654
0.0961218093339374
0.0708384429900007
0.0460331508645818
0.02161256943736
-0.00250963515135537
-0.0264143799948644
-0.050178511333558
-0.0738759582180277
-0.0975786986137388
-0.121357497220818
-0.145282408341908
-0.16942322344589
-0.193850548461013
-0.218637426563975
-0.243860080884267
-0.269598336500476
-0.295936323403358
-0.322963404114728
-0.350775547447892
-0.379477334589987
-0.409185301341646
-0.440034239717318
-0.472190208246479
-0.505881336489296
-0.541497311570115
-0.579990069112818
-0.623912078264257
-0.67807569259175
-0.742665246778982
-0.823772364155972
-0.937725217070818
-1.12582011179886
-1.60422120996448

# State 13
3.30524396988877
6.16069645115443
7.46932018869592
8.06948053971771
8.36347527273142
8.53675310936634
8.66362168800368
8.76403639995888
8.84759949999794
8.91980361464198
8.98399201093762
9.0422999471065
9.09614819004226
9.1465186725427
9.19411517418237
9.23946012583708
9.28295458272415
9.3249163348269
9.36560472787471
9.40523724087215
9.44400085806426
9.48206010078562
9.5195628863902
9.55664495918543
9.59343338012373
9.63004940340661
9.66661097141539
9.70323500245484
9.74003961615764
9.77714643269293
9.81468309231258
9.85278617345911
9.89160474746545
9.93130490900656
9.97207578706139
10.0141378107917
10.0577544462411
10.1032493508936
10.1510321232146
10.201637936496
10.2557900684542
10.3145011153881
10.3792415450398
10.4522300525804
10.5369563144157
10.6391867570931
10.7690789667786
10.9486701377171
11.2617409498453
11.9127508553807
13.3344956919133

# State 14
1.03996632072911
1.00673320951736
1.00499072492547
1.00409370397318
1.00394330749138
1.00397389212268
1.00379547186618
1.00363422632012
1.00363431521777
1.00363649318374
1.00362904994937
1.00367317681154
1.00369935521362
1.0036151281305
1.0035716567846
1.00358723029803
1.00359413680366
1.00359977039201
1.0036046573103
1.0036098997972
1.00361428679188
1.00361162973197
1.00362092714185
1.00362942887726
1.00362428332656
1.00361711309832
1.00362220078298
1.00363131323606
1.00362103294577
1.00362151948693
1.00359847281935
1.00358071760587
1.00361913153551
1.00364458870168
1.00364373572206
1.00364663250466
1.00356919322332
1.00532483978721
1.00687553184247
1.00608396121441
1.00639433964871
1.0066822924899
1.00915123957135
0.979651846449347
0.94694491016494
0.913774510195389
0.880789732376401
0.849252000572261
0.823265941640553
0.8022372464362
0.784197724419854

# State 15
-0.0171749065952461
-0.00586915395961769
-0.00435866765610292
-0.00402251667464971
-0.00401838161459286
-0.00374085862227948
-0.00341070549538063
-0.00342603971738282
-0.00342297790634897
-0.00342178598913127
-0.00342255062207918
-0.00339428246660121
-0.00339121760696502
-0.00341738413439031
-0.00341647418083466
-0.00341531986965228
-0.00341717947620679
-0.00341678331070218
-0.00341432098071596
-0.00341458784299911
-0.00341407635897286
-0.00341754380709657
-0.00341541351604305
-0.00341073525599175
-0.00341399476504583
-0.00341170000144078
-0.00342982253352106
-0.00343435868852107
-0.00341024347752396
-0.00343471300032243
-0.0034451155603255
-0.00341778173239045
-0.00340788588019104
-0.00341892833074815
-0.00343705011712497
-0.00343117055149999
-0.00346094251403822
-0.00412719681921895
-0.00514660559943128
-0.00571650470699347
-0.00572178739393438
-0.00552669307520201
-0.00454220796232025
0.00635012500580279
0.0172465720891811
0.0284366571604454
0.0397482825231278
0.0511326236987199
0.0625621843223976
0.0740175262338869
0.0854441686769104

# State 16
-0.00197853196607159
-0.000302053390348544
-0.0014971639725867
-0.00155157831063599
-0.00156895940173913
-0.0015748678204566
-0.0015768077903194
-0.0015774409187132
-0.00157764750607902
-0.0015777061636326
-0.00157770523591897
-0.00157766350475615
-0.00157762828682969
-0.00157766085331684
-0.00157767472983304
-0.00157768193947495
-0.00157768377170161
-0.00157768288415388
-0.00157768440605668
-0.00157767938389575
-0.00157767609725507
-0.00157767510504023
-0.00157764058342058
-0.0015776687972782
-0.00157766478123833
-0.00157766422262576
-0.00157763268251418
-0.00157766367109065
-0.00157766503520861
-0.00157763913924051
-0.00157766992410433
-0.00157764963147747
-0.00157764399155987
-0.00157765698790801
-0.00157769560000059
-0.00157777306189381
-0.00157791946766898
-0.00157801416849
-0.000495463588736192
-0.000492356597870335
-0.000405070133614492
-0.000379038002694357
-0.000740968099578514
0.00966417480161938
0.0207763332556963
0.0300362404829818
0.0381337357901015
0.0454872333080252
0.052355600241935
0.0589576792062317
0.0656265215288825

# State 17
6.71528643942374
2.17751848731913
1.09401322843783
0.733395305652817
0.610401119613136
0.567955684034366
0.552962482257592
0.547570739551368
0.545663214907583
0.544990865010125
0.544757491739541
0.544679842403627
0.544664029307931
0.544682317759257
0.544692657695942
0.544699024470071
0.544703583736127
0.544708759347951
0.544713765592334
0.544715555024587
0.544719194038816
0.544725253373567
0.544737259377453
0.544759313848006
0.544742201039923
0.544739738540549
0.544738654991555
0.544765298133528
0.544753690674982
0.544756749870746
0.544775185719574
0.544765767823536
0.544779711426768
0.544780040332377
0.544765628169505
0.544725263370481
0.544648365263919
0.544822485175815
0.550431262802559
0.552084376734352
0.552453522059767
0.552576979024687
0.55227394142632
0.550807707984907
0.546086899717626
0.532336696635605
0.492591067038333
0.376795630361019
0.0343399419465893
-1.00510452002913
-5.59497216769754

# State 18
10.4020046692092
4.14874934024726
2.85452531257471
2.40080649722553
2.24036208427664
2.18372844569502
2.16381871119875
2.1565909017095
2.15394890299051
2.15296476882928
2.1525748960523
2.15239412375243
2.15221295427133
2.15213589695743
2.15209724884225
2.15207378228796
2.15205170809865
2.152027085574
2.15202052100063
2.1520044548858
2.15197907243353
2.15193063421026
2.15182211255761
2.15190097211156
2.1518974493889
2.15187260842925
2.15177962498772
2.15184462574977
2.15182923976764
2.1517416326557
2.15177593078515
2.15168951256898
2.15164653982853
2.15159799694997
2.15149135085608
2.15121868014936
2.15045220166187
2.14801026342095
2.13822587234882
2.13893233934477
2.13842656366983
2.13783892296482
2.13686919320726
2.13460134307794
2.12851345012792
2.11167389028799
2.06492219359375
1.93419572268294
1.56473062670978
0.503090089517217
-5.01015116369299

# State 19
-2.877928249385
-0.846246088514729
-0.262135917453729
-0.0801265449234822
-0.0213514290422641
-0.00202873385099737
0.00407501408431389
0.00619220066394501
0.00689040205759911
0.00709388848763774
0.00710197868400806
0.0069604455209657
0.00691787576628975
0.00703685306789061
0.00708835307306513
0.00711559804846732
0.007126881482744
0.00713572699412041
0.00713651698533308
0.00712386937526777
0.00711643668956201
0.00711710132385192
0.00709810364934867
0.00710324381689658
0.00710237391449471
0.0070957265391259
0.00707717525803915
0.00710085937960822
0.00710952091484129
0.00710019791432057
0.00713148239266246
0.00712917201665609
0.00711304112144942
0.00715607833285119
0.007288239436434
0.00755027150418641
0.00804503088054519
0.00828358331828864
0.00928200069428417
0.0116500946080979
0.0125877250279769
0.0129748040808521
0.0133562173590683
0.0141203108316071
0.016225027629509
0.0224862913335993
0.0413757051361679
0.0989387410346148
0.277261266776378
0.849048181137899
2.81651133940472

# State 20
15.6346357185139
6.54763436820704
4.90439830334369
4.32310830009946
4.11376946088555
4.03682013840291
4.00794474722636
3.99728956730931
3.9933634378051
3.99192958570011
3.99143090066813
3.99129152558648
3.99136281809923
3.99141445714206
3.99144565560004
3.99146767612569
3.99149012397388
3.99151541021641
3.9915248946065
3.99154323156487
3.99157178688322
3.99162530700631
3.99174344761664
3.9916686993548
3.99167486843743
3.99171440756028
3.9918490049308
3.99174925330861
3.99175297542649
3.99184602405653
3.99181247341076
3.99190965460386
3.99197446018923
3.99206129993114
3.99228478580327
3.99298156626298
3.99550112120273
4.00597494448321
4.05492318061042
4.06535554948628
4.06799972513381
4.06889312658116
4.0686924596693
4.06613103327548
4.05773691860737
4.03447430906939
3.97115203545264
3.79837192642774
3.32325595495752
1.99982759319783
-5.64145453873707

# State 21
0.803396942522538
0.804598700512287
0.804711571661018
0.803838189296522
0.802010146660454
0.799403738376419
0.796300711788212
0.792963818737575
0.789591306172483
0.786323138506542
0.783258413281926
0.780471092646144
0.778018849899734
0.775945233702343
0.77428199789785
0.77305403871605
0.772283348855497
0.771989390806771
0.77218923502778
0.772898504870801
0.774132579941865
0.775908403607065
0.778246550232058
0.78117070486622
0.784705241302187
0.788873226332607
0.793694602281095
0.79918349820955
0.80534431257619
0.81216731750572
0.819624953887712
0.827669710617394
0.83623427504229
0.845235122035762
0.854581976089339
0.864195086399452
0.874025166431974
0.884062359521282
0.894329320126481
0.904868252464664
0.915728470826026
0.926959473038065
0.938607853874957
0.950716398093024
0.963324850123628
0.976472642445506
0.990203950715519
1.00457729213173
1.01969567009085
1.035796739885
1.05347159628334

# State 22
0.0847654938678397
0.0908271317657977
0.103912913582236
0.118161535793911
0.132935894823323
0.147946321233167
0.163026225601042
0.178042451669763
0.192841591434379
0.207216335774756
0.220900569589518
0.233619023410963
0.245189998380692
0.255568921038311
0.264810782699057
0.27302109341205
0.280324814976095
0.286848417996925
0.292709901538634
0.298014957813771
0.302857277611339
0.307320103943179
0.311476875477108
0.315389193178604
0.319104174918804
0.322652843213035
0.326049755255477
0.329292529092864
0.332362241053506
0.335225870189943
0.33784115082909
0.340162086700334
0.342142931833503
0.34373842503891
0.344899525792886
0.345566436700255
0.345663072367236
0.345097243676797
0.343766614435209
0.341565766043376
0.338388772008621
0.334120839511364
0.328610954351767
0.321616412997862
0.312708151062131
0.301105013517754
0.285355515876745
0.261640633394882
0.224481705910518
0.191419789706405
0.158150274792635

# State 23
0.0684180470795104
0.0853435065041364
0.09848891355206
0.10984552200344
0.119927236565248
0.128989872306543
0.13718074798698
0.144589264572683
0.151279567784386
0.157313914478953
0.162754845977277
0.167655963904084
0.1720560129087
0.175983467291107
0.179461289358478
0.18250729134372
0.185135403272733
0.187358467209582
0.18918771573924
0.190632174631395
0.191699351867806
0.192396178356118
0.192727920748254
0.192697162536568
0.192304713407569
0.191549396982057
0.190426717560684
0.188929587741221
0.187052167723304
0.184792505414787
0.182152185512971
0.179134871632097
0.175744452968969
0.171982708381547
0.167847259848287
0.163330534271237
0.158419672782048
0.153096761194169
0.147338798481413
0.141117242498204
0.134397220755309
0.12713656039527
0.119284397527828
0.110778738102089
0.101541600117744
0.0914696409934732
0.0804169652893352
0.0681620136478543
0.0543309133910892
0.0381660330925082
0.0179144545238181

# State 24
-1.52609030991187
-1.18483949982211
-1.04616578470859
-0.956396248152836
-0.886772528304885
-0.825597965286554
-0.76885008979467
-0.714848181059776
-0.662765988075337
-0.612115730589604
-0.562574146224203
-0.513918321886796
-0.465991919773581
-0.41868143695683
-0.37189840942101
-0.325568490250707
-0.279625360600579
-0.234006245261421
-0.188649954977657
-0.143496268669022
-0.0984853090923655
-0.053557310604524
-0.00865351229017301
0.0362843619967097
0.0813155861029519
0.126500939571629
0.171902679530577
0.217584634546369
0.263612647491018
0.310055061514367
0.356982936337284
0.404470339775171
0.452595265306694
0.501441520765336
0.551101688483256
0.601680776608967
0.653299609787167
0.706097099499824
0.760231761326702
0.815883657298722
0.87325803986982
0.932593564736059
0.99418033190315
1.05839875146654
1.12580753386811
1.19736049657121
1.27496973798719
1.36317292405883
1.47452671962984
1.64716567208288
3.01865621352292

# State 25
0.681878647665494
1.41526150137836
1.56183792723643
1.64721671142406
1.70731813248479
1.75542043603389
1.79640924821546
1.83240679729685
1.86451375975222
1.89340581732464
1.91956807007158
1.94338686612729
1.96518012192103
1.9852130407353
2.00370775018941
2.02085088066671
2.03680023044569
2.0516897630833
2.06563540719435
2.07874039391101
2.09109906870804
2.1027997458377
2.11392732054607
2.1245642032841
2.13479018712613
2.14468269425996
2.15431758458617
2.1637704682219
2.17311901918308
2.18244722634295
2.1918509182779
2.20144382404482
2.2113632322564
2.22177395383877
2.23286860753432
2.24486205266268
2.25798142715672
2.27245910750464
2.28853734410569
2.30649197312337
2.32668290018344
2.34964004371088
2.37620040360648
2.40772954311038
2.44651800286323
2.49654612627162
2.56520078716774
2.66680425587611
2.83472415043524
3.16679446935777
4.56786125585658

# State 26
1.46271465687229
1.10591215444502
0.943643566537731
0.831453151331388
0.745587811365204
0.675363393317234
0.615215774312894
0.561996461231519
0.513805020556042
0.469426803629479
0.428043547680837
0.389076545357174
0.352098186078185
0.316780398641848
0.282863386568815
0.25013575057494
0.218421370241564
0.187570456788189
0.157453195759453
0.127955101581016
0.0989735395541168
0.0704150492982103
0.0421931874523498
0.01422674800377
-0.0135617523807531
-0.0412474572788407
-0.0689044918208633
-0.0966072030906976
-0.124431372413088
-0.152455562663941
-0.180762592785015
-0.20944111488031
-0.238587424349823
-0.268307653442058
-0.298720531146495
-0.329960982762414
-0.362184999270788
-0.395576484239678
-0.4303572668577
-0.466802251120866
-0.505263034358409
-0.546205869529739
-0.590274608695123
-0.638398705983198
-0.691985143627677
-0.753274333881861
-0.826035767219525
-0.917031072115002
-1.03953999630944
-1.2284886707335
-1.71990746961957

# State 27
-0.362613465262583
1.60362209073481
2.39165444759068
2.72826141405507
2.91084148878859
3.04122788262893
3.14294725543522
3.22674016453627
3.29860911136773
3.36214778958272
3.41962126300234
3.47252005028651
3.5218645120411
3.56837988419708
3.61260053326983
3.65493391814872
3.69570088947154
3.73516173434534
3.77353344490389
3.81100147856185
3.84772800010461
3.88385784115587
3.91952295921344
3.95484590245279
3.98994261701115
4.02492482926956
4.05990217259197
4.09498419203199
4.13028234394509
4.16591210675882
4.20199533421213
4.23866301634376
4.27605867367906
4.31434270977646
4.35369820957789
4.39433893515643
4.4365207039629
4.480558055359
4.52684932963527
4.57591538765235
4.62846092985479
4.68547421080705
4.74839400818315
4.81939905048507
4.9019325421366
5.00171719893784
5.12892626530645
5.30487178120187
5.61994661831924
6.34645661036707
8.15593306361325

# State 28
1.05440599219347
1.02607201669909
1.0018574838908
1.00173911314368
1.00173834127911
1.00174240048556
1.00174622988222
1.00174765707146
1.00174668524688
1.00174726266876
1.00174762454687
1.00174777418701
1.0017515711206
1.00175145391982
1.00174814514804
1.00175207433996
1.00175246142586
1.00174856805119
1.00175220739891
1.00175616590943
1.00175363779813
1.00175275185818
1.00175420565614
1.00175502116947
1.00175539953974
1.00175522756371
1.00175544896629
1.00175609933995
1.00175691674609
1.00175798596034
1.00176228439284
1.001760972214
1.00175835954903
1.00176086192312
1.00176082986876
1.00175785007797
1.00174466180756
1.00174167082109
1.00176840718985
1.00177281293328
1.001763534141
1.0017669814493
1.00176634209262
1.00176476786079
1.00174472567118
1.00599997597159
0.863254213107423
0.714026568396858
0.558042343403816
0.390189760785559
0.20888206253127

# State 29
0.0979676189271004
0.0317348464327142
0.0023831170243789
0.0006391275164214
0.000849276721896703
0.000820118662539658
0.000825315575474774
0.000828179307991183
0.000820551244436696
0.000825676369359386
0.000821918259382571
0.000824509767571417
0.000822016374424911
0.00082479753961316
0.000821948830285022
0.000824400710394769
0.000823220032585048
0.000823494121292532
0.000823278569484845
0.000823947195444224
0.000824036801444832
0.000822560673957779
0.000824107543332912
0.000822901720861667
0.000823748878240413
0.000822794996763273
0.000823946074394974
0.000822692269021347
0.000823960593243835
0.000822578450382929
0.000823704544198586
0.000823584740769955
0.000822274835406093
0.000824857279499644
0.0008224378481474
0.000821985332212541
0.000827892340755525
0.00081682989761897
0.000829551324619419
0.000824670446796925
0.000820260838296383
0.000828084212398588
0.000825016653893705
0.000813332326641705
0.000831926013878419
0.000866825242926427
0.000512469713433991
0.000145033227799617
-0.00025007194289252
-0.000675605923104361
-0.00118201932621871

# State 30
0.00921585532071185
0.00185521081216591
-0.00194389787682601
-0.00200650467263431
-0.00202657653730352
-0.00203311074401977
-0.00203525511556716
-0.00203595976752833
-0.00203619330315443
-0.00203627186193346
-0.00203629831466519
-0.00203630723304789
-0.00203630994367468
-0.00203631023173807
-0.00203631062329452
-0.00203631057836774
-0.00203631118500708
-0.00203631163037108
-0.0020363095041344
-0.00203631066881689
-0.00203631061259463
-0.00203631002802384
-0.00203630984408647
-0.00203630968635917
-0.00203631037465191
-0.00203631051063811
-0.00203631006496222
-0.00203630968082363
-0.00203630925257978
-0.00203630910044532
-0.00203630847318793
-0.00203630725495451
-0.00203630743643619
-0.0020363068529033
-0.0020363066549432
-0.00203630736175418
-0.0020363098310865
-0.00203631626691576
-0.00203632238866914
-0.00203632887438447
-0.00203635997987026
-0.00203644271172841
-0.00203667551951164
-0.00203733333784419
-0.00203919836218188
-0.00204452601585644
-0.00128863241350191
-0.000507294029564694
0.000359346834533095
0.00147848774192094
0.00336749489009122

# State 31
6.59964712385791
1.90864107185568
0.797535693613946
0.429286329840733
0.304440577458748
0.261469590889621
0.24654295063612
0.24132771593659
0.23949820223435
0.238852541153783
0.238624971185306
0.238545385090423
0.238517989935203
0.238509230494093
0.238507553985584
0.238507447045316
0.238507308051048
0.238507442731832
0.238510799412502
0.238511862599182
0.238507690360968
0.238503813335873
0.238501513379712
0.238500041970739
0.238499870478183
0.238496003087237
0.23849306250597
0.238490394439405
0.238487996453981
0.23848592757875
0.238484663930345
0.238484384937111
0.238484284504684
0.238481217483346
0.238479092946614
0.23847756933777
0.23847529428236
0.238469312797807
0.238457660200897
0.238435352925466
0.238374157732957
0.238192925036525
0.23769520312391
0.23629893918784
0.232369096147404
0.221494690813379
0.194538206137514
0.0950538882581475
-0.205676517012852
-1.11687367178193
-5.24137398086631

# State 32
7.3341145814979
2.34489100807466
1.18857034326967
0.805082333835714
0.675967959150996
0.631762371701315
0.616476493595031
0.611147013090382
0.609296009683097
0.608646602290409
0.608415333860426
0.608330393796983
0.608296714725589
0.608278436550746
0.608271475740592
0.608270255235178
0.608272405012221
0.60826643594236
0.608249608164322
0.608266512960433
0.608278658856643
0.608286203263819
0.608292762810875
0.608298841151339
0.608305601355533
0.608313057266469
0.608320734018957
0.608328320727711
0.608334494624218
0.608338891834038
0.608337231134393
0.608336444028166
0.608350786734972
0.608360128046345
0.608367541394088
0.608375396029013
0.608383762229591
0.608391673792425
0.608381915085477
0.608338244593791
0.608286582558322
0.608083378040097
0.607468063557884
0.605703673168861
0.600674217893645
0.586194211981304
0.542670448122416
0.44022980184701
0.136299664504129
-0.784304728839821
-4.90551945459065

# State 33
-3.11661209018054
-0.905231955790831
-0.281262481531033
-0.0890073701556732
-0.0273314281781085
-0.00725401453568926
-0.000665012637880737
0.00150241692962155
0.00221850523387376
0.00245939555291911
0.0025408618649008
0.00256849029553996
0.0025770398645804
0.00257904303877402
0.00258025147946351
0.00258004636802514
0.00258077854238968
0.00258237345835054
0.00257836670350876
0.0025800253953648
0.00257870257349997
0.00257725259924938
0.00257634696574624
0.00257566513173997
0.0025756634093827
0.00257748689768792
0.00257569802250237
0.00257406757508783
0.00257241294337308
0.00257155575536377
0.00257050347808259
0.0025681399202145
0.00256596401251645
0.00256364710214996
0.00256274787797614
0.00256418190994057
0.00257082075797429
0.00258924849851714
0.00260944024207895
0.00263328559465075
0.00272472237878032
0.0029785381582063
0.00369142773856524
0.00571101965137085
0.01143833957938
0.0277594690778926
0.0740796711659432
0.209561018822841
0.606136475959254
1.81047358750143
5.75699018407239

# State 34
12.7932740202158
5.50282951365876
4.12927774940443
3.64412667444537
3.46948192345645
3.40591677802182
3.38262629336578
3.3740600730026
3.37089106139737
3.36971673503607
3.36928280451608
3.36912355249485
3.36906691205176
3.36905021562116
3.36904351314874
3.36903942240749
3.36903459152995
3.36903612298174
3.36904294846933
3.36903646328827
3.3690295684314
3.36902761159193
3.36902393591887
3.36901828272548
3.36900671667997
3.36901141286192
3.36901065455798
3.36900805811084
3.36900570699777
3.36900473037491
3.36900816689376
3.36901045573226
3.36899854619807
3.36899003756451
3.36898162906461
3.36896775623949
3.36894251302173
3.36889095658891
3.36877441719898
3.36845754477141
3.36757129762947
3.36524722139478
3.35909536210564
3.3428274966538
3.29992560731489
3.18792329360796
2.9031197153378
2.01121539439624
-0.519646138362142
-8.02297821914615
-37.0074954030864

# Control 0
-0.999950697105249
-0.999950550033585
-0.999950522220563
-0.999950510931754
-0.999950505861971
-0.999950503243389
-0.999950501660157
-0.999950500563916
-0.999950499730091
-0.999950499056063
-0.999950498485872
-0.999950497982311
-0.999950497517583
-0.999950497069928
-0.999950496622421
-0.999950496162538
-0.999950495682305
-0.999950495177317
-0.999950494647002
-0.999950494093875
-0.999950493523141
-0.999950492942252
-0.999950492360363
-0.999950491787756
-0.999950491235175
-0.999950490713393
-0.999950490232405
-0.999950489801202
-0.999950489426577
-0.999950489113689
-0.999950488864913
-0.999950488680135
-0.99995048855671
-0.999950488489731
-0.99995048847248
-0.999950488496909
-0.999950488554559
-0.999950488637182
-0.999950488737839
-0.99995048885342
-0.999950488986537
-0.999950489151452
-0.999950489370314
-0.999950489672938
-0.99995049007324
-0.999950490499412
-0.999950490585927
-0.999950489087388
-0.999950482032104
-0.999950460647259

# Control 1
0.999999523338193
0.999999471504061
0.999999464778598
0.999999462149971
0.999999461150982
0.999999460777503
0.999999460630634
0.999999460555888
0.999999460496539
0.99999946043324
0.999999460361924
0.999999460283859
0.999999460202399
0.999999460121866
0.999999460046568
0.999999459980875
0.999999459928988
0.999999459894417
0.999999459879869
0.999999459887335
0.999999459917831
0.999999459970928
0.999999460045673
0.999999460139569
0.999999460249167
0.999999460370363
0.999999460498157
0.999999460627257
0.999999460751713
0.999999460866151
0.999999460965045
0.999999461043502
0.999999461097339
0.999999461123143
0.999999461118937
0.999999461083333
0.999999461016616
0.999999460920497
0.999999460797873
0.999999460653236
0.999999460491698
0.999999460317051
0.999999460130924
0.999999459925118
0.999999459667567
0.999999459262686
0.999999458449543
0.999999456519995
0.999999451575424
0.99999943748654

# Control 2
-0.999988088084984
-0.999988074767415
-0.999988072227434
-0.999988071206585
-0.999988070808618
-0.999988070659755
-0.99998807060814
-0.999988070593337
-0.999988070591778
-0.999988070594586
-0.999988070598651
-0.999988070603119
-0.999988070607975
-0.999988070613491
-0.99998807062002
-0.999988070627896
-0.999988070637399
-0.999988070648752
-0.999988070662103
-0.999988070677526
-0.999988070695029
-0.999988070714566
-0.999988070736044
-0.999988070759365
-0.999988070784457
-0.999988070811311
-0.999988070840043
-0.999988070870923
-0.999988070904435
-0.99998807094123
-0.999988070982077
-0.999988071027628
-0.999988071078048
-0.9999880711325
-0.999988071188638
-0.999988071242509
-0.999988071289117
-0.999988071323751
-0.999988071343356
-0.999988071347064
-0.999988071335827
-0.999988071311793
-0.999988071278369
-0.999988071241539
-0.999988071213165
-0.999988071217593
-0.999988071303828
-0.999988071566818
-0.999988072171875
-0.999988073486185

# Control 3
0.999955600863982
0.99547177298212
0.998320411146675
0.998320411709745
0.998320411710021
0.998320411694307
0.998320411681848
0.998320411690288
0.998320411695202
0.998320411694859
0.998320411695894
0.998320411696945
0.998320411693251
0.998320411690894
0.99832041169401
0.998320411695757
0.998320411695417
0.998320411695305
0.998320411695293
0.998320411695292
0.998320411695053
0.998320411695182
0.998320411695507
0.998320411695075
0.99832041169454
0.998320411695007
0.998320411695587
0.998320411694763
0.998320411694606
0.99832041169439
0.998320411693405
0.998320411695381
0.998320411697169
0.998320411696022
0.998320411695162
0.998320411692628
0.99832041175466
0.998320410924501
0.995486080192571
0.995506525785458
0.995631942607897
0.993753567495055
0.993990304752227
0.999955488952243
0.999958344487159
0.999959073941272
0.999959178920118
0.99995917099894
0.999959090433847
0.99995903635704

# Control 4
0.999906693478449
0.99549129073039
-0.998323355272626
-0.998323355209047
-0.998323355130909
-0.998323355294726
-0.998323355151732
-0.998323354967825
-0.99832335497197
-0.998323354969906
-0.998323354983707
-0.998323354985034
-0.998323354957756
-0.998323354958956
-0.998323354971468
-0.998323354968453
-0.998323354968298
-0.998323354970756
-0.99832335497047
-0.998323354969342
-0.998323354967771
-0.998323354968515
-0.998323354972389
-0.99832335497065
-0.998323354969253
-0.99832335496063
-0.998323354955779
-0.998323354980961
-0.99832335496955
-0.998323354950021
-0.998323354980537
-0.998323354989721
-0.99832335496695
-0.998323354952212
-0.998323354962566
-0.998323354958386
-0.998323354555182
-0.998323353242465
0.995484417578522
0.995502139889671
0.995627862470912
0.97806514607451
0.996163788502619
0.999883960036328
0.99990042538177
0.999900623184567
0.999900660377884
0.999900699843132
0.999900720021368
0.999900688188552

# Control 5
-0.714934353356972
-0.91657458398663
-0.99832088837536
-0.998320887198327
-0.998320887291291
-0.998320887226064
-0.998320887318776
-0.998320887419981
-0.998320887415278
-0.998320887416855
-0.998320887408461
-0.998320887407116
-0.99832088742476
-0.998320887425459
-0.998320887416498
-0.998320887417201
-0.998320887417498
-0.998320887416157
-0.998320887416342
-0.998320887416987
-0.998320887418023
-0.998320887417548
-0.998320887415042
-0.998320887416402
-0.998320887417465
-0.998320887422157
-0.998320887424483
-0.998320887410678
-0.998320887417283
-0.998320887428473
-0.998320887411741
-0.99832088740526
-0.998320887417218
-0.998320887426268
-0.998320887420798
-0.998320887424555
-0.998320887616585
-0.998320890151071
-0.91541846411815
-0.908914326607082
-0.870801743603059
-0.822971311001999
-0.722484558988517
-0.716278000053865
-0.716127868168019
-0.71610976516081
-0.716113985654755
-0.716142801351171
-0.716250275955581
-0.716783548147072

# Control 6
0.999927471435884
0.999924361005417
0.998413855696339
0.998413854156714
0.998413853929432
0.998413853952238
0.998413853945225
0.998413853946147
0.99841385394553
0.998413853944944
0.998413853945267
0.998413853945188
0.99841385394515
0.998413853944971
0.998413853945146
0.998413853945028
0.99841385394508
0.998413853945052
0.998413853945268
0.998413853944992
0.998413853945153
0.998413853945076
0.998413853945093
0.998413853945159
0.998413853945087
0.998413853945042
0.998413853945109
0.998413853945112
0.998413853945143
0.998413853945278
0.998413853945023
0.99841385394515
0.998413853944873
0.998413853945124
0.998413853945387
0.998413853943758
0.998413853945293
0.998413853945603
0.998413853944959
0.99841385394632
0.998413853944512
0.998413853944866
0.998413853948251
0.998413853946381
0.998413854068617
0.998413835149905
0.999927359251595
0.999927346732712
0.999927303549466
0.99992713940398

# Control 7
0.999883158694238
0.999888423039469
-0.998416657808008
-0.998416639488254
-0.998416642352365
-0.998416641901705
-0.998416641966147
-0.99841664193845
-0.998416641943287
-0.998416641951152
-0.998416641945788
-0.998416641948329
-0.998416641948742
-0.998416641948129
-0.998416641947394
-0.998416641950812
-0.998416641946517
-0.998416641948369
-0.998416641948709
-0.998416641950055
-0.998416641945521
-0.99841664194841
-0.998416641948942
-0.998416641947498
-0.99841664194807
-0.998416641948693
-0.998416641948061
-0.99841664194829
-0.998416641947997
-0.998416641947613
-0.998416641950239
-0.99841664194529
-0.998416641951087
-0.998416641948564
-0.998416641942355
-0.998416641960139
-0.998416641937977
-0.998416641951198
-0.998416641963791
-0.998416641928677
-0.998416641956049
-0.998416641958595
-0.998416641918698
-0.998416641966405
-0.998416641963635
-0.998416656561464
0.999882781446254
0.999882779646795
0.999882771570726
0.999882730004542

# Control 8
-0.845556441370212
-0.846227041612924
-0.998414295386602
-0.998414306086536
-0.998414304383561
-0.99841430466909
-0.998414304634752
-0.99841430465307
-0.998414304650652
-0.998414304646035
-0.998414304649341
-0.998414304647754
-0.99841430464752
-0.998414304648032
-0.998414304648396
-0.998414304646258
-0.998414304649005
-0.998414304647825
-0.998414304647465
-0.998414304646767
-0.998414304649612
-0.998414304647785
-0.99841430464743
-0.998414304648323
-0.998414304647994
-0.998414304647624
-0.998414304647989
-0.998414304647839
-0.998414304648006
-0.998414304648171
-0.998414304646634
-0.998414304649757
-0.998414304646181
-0.998414304647655
-0.998414304651513
-0.998414304641034
-0.998414304654407
-0.998414304645647
-0.998414304637919
-0.99841430465984
-0.998414304643374
-0.998414304641797
-0.99841430466627
-0.998414304638682
-0.99841430456731
-0.99841430783181
-0.846563450259608
-0.846727663717884
-0.847237394378559
-0.849222371244434

# Parameters
0.280671286198195
0.596498538988102
0.029813730727392
0.496934116286405
0.0325545138394012

# Boundary conditions : 
0 -0.00502966619304202 0 4
0 0.00791876822076398 0 4
0 -0.0431134417519972 0 4
0 -6.58721226392011 0 4
0 7.71828810990182 0 4
0 -3.26051659637572 0 4
0 18.0831416824713 0 4
0 -0.00989867064236383 0 4
0 0.0135566722310279 0 4
0 -0.0130657968279799 0 4
0 -5.14323774975517 0 4
0 5.65573357142802 0 4
0 -1.69403235476051 0 4
0 6.49558669375984 0 4
0 0.0102851909851756 0 4
0 -0.00117562604253342 0 4
0 0.00024887278326071 0 4
0 4.34911182956801 0 4
0 3.73049194371832 0 4
0 -1.27370703942052 0 4
0 2.30014002660055 0 4
0 0.0191992181026835 0 4
0 -0.000678674809070731 0 4
0 0.00279152555062789 0 4
0 4.06888185778567 0 4
0 5.69202981135849 0 4
0 -1.35379668253243 0 4
0 5.27884107347449 0 4
0 0.000934395910136443 0 4
0 -0.0601826558655345 0 4
0 -0.00869859920310628 0 4
0 3.58099091033499 0 4
0 2.76625332564132 0 4
0 -1.39670462056097 0 4
0 4.63734095660256 0 4
0 -0.20888206253127 0 4
0 0.00118201932621871 0 4
0 -0.00336749489009122 0 4
0 5.24137398086631 0 4
0 4.90551945459065 0 4
0 -0.350155184072395 0 4

# Path constraint 0 : 
0 0 4
0.732015190357679
0.732015067832238
0.732015046425347
0.732015037800877
0.732015034067374
0.732015032253999
0.732015031225349
0.73201503054075
0.732015030024189
0.732015029600125
0.732015029232107
0.732015028898892
0.73201502858636
0.732015028284603
0.732015027986537
0.73201502768765
0.732015027385924
0.732015027080972
0.732015026774112
0.732015026467989
0.732015026166198
0.732015025872766
0.732015025592378
0.732015025329469
0.73201502508821
0.732015024872447
0.732015024685128
0.732015024528546
0.732015024403467
0.732015024310142
0.732015024247196
0.732015024212114
0.732015024201051
0.732015024208717
0.732015024228742
0.732015024253391
0.732015024275064
0.732015024287267
0.732015024285899
0.732015024271261
0.732015024248361
0.732015024228861
0.732015024228457
0.732015024263083
0.732015024329109
0.732015024343947
0.732015023974204
0.732015022146839
0.732015015568112
0.732014995846362

# Path constraint 1 : 
0 0 4
0.584567994430092
0.67990354744982
0.729143649660556
0.729143649269377
0.729143649278097
0.729143649325945
0.729143649289721
0.729143649246845
0.729143649249361
0.729143649248881
0.729143649252601
0.729143649253197
0.729143649245503
0.729143649245238
0.729143649249087
0.729143649248761
0.729143649248647
0.729143649249227
0.729143649249161
0.729143649248882
0.729143649248435
0.729143649248665
0.729143649249642
0.729143649249174
0.729143649248673
0.729143649246673
0.72914364924555
0.729143649251642
0.729143649248778
0.729143649243838
0.729143649251227
0.729143649253929
0.729143649248718
0.729143649244772
0.729143649247095
0.729143649245388
0.72914364915928
0.729143649385375
0.679277441624001
0.675763410066574
0.655552319418417
0.619085964860189
0.58187956477165
0.585160271639689
0.585104625870171
0.585097032222647
0.585099028635455
0.585112067059858
0.585160588157233
0.585401562862339

# Path constraint 2 : 
0 0 4
0.647600368631661
0.647945931217832
0.729305396703332
0.729305391415103
0.729305391954266
0.729305391872095
0.729305391885427
0.729305391880544
0.729305391881585
0.729305391883122
0.72930539188212
0.729305391882625
0.729305391882706
0.729305391882545
0.729305391882431
0.729305391883102
0.729305391882239
0.72930539188261
0.729305391882724
0.729305391882939
0.729305391882056
0.729305391882625
0.729305391882737
0.729305391882457
0.729305391882556
0.729305391882676
0.72930539188256
0.729305391882608
0.729305391882553
0.729305391882504
0.729305391882986
0.729305391882005
0.729305391883127
0.729305391882667
0.729305391881461
0.729305391884737
0.72930539188055
0.729305391883304
0.729305391885742
0.729305391878911
0.729305391884163
0.729305391884927
0.729305391877976
0.729305391888512
0.72930539191628
0.729305391306402
0.648117100126085
0.648201446511703
0.64846333647462
0.649484281131525

# Dynamic constraint 0 (y_dot - f = 0) : 
0 0 4
0.00526252043264197
0.00546306180025313
0.00563441313115609
0.00578000592753236
0.00590275426056186
0.00600529887906642
0.0060902759115713
0.00616039070621532
0.00621833007179617
0.00626661897968939
0.00630750285638104
0.00634288690994689
0.00637432898140933
0.00640306835592774
0.00643007238235738
0.00645608759178184
0.00648168749494582
0.00650731346781575
0.00653330779452688
0.00655993934158472
0.00658742292489656
0.00661593355954126
0.00664561669384822
0.00667659536222809
0.00670897502101653
0.0067428466858237
0.00677828887946408
0.00681536882593337
0.00685414328593437
0.00689465942473699
0.00693695613678802
0.00698106634455176
0.00702702097435282
0.00707485567351318
0.00712462203620623
0.00717640645391748
0.00723036212837425
0.00728676363952374
0.00734609870715919
0.00740921788038773
0.00747756927667154
0.00755355219110676
0.00764103144838946
0.00774606770228492
0.00787794928406949
0.00805068688714461
0.00828531227892104
0.00861373054390313
0.00908582904779576
0.00978410626190152

# Dynamic constraint 1 (y_dot - f = 0) : 
0 0 4
-0.00828508095780522
-0.00861050740208302
-0.00889777055879115
-0.00915149945453475
-0.00937768591483534
-0.0095827169067797
-0.00977244737547833
-0.00995166070232534
-0.0101239204812993
-0.0102916725776661
-0.0104564571711734
-0.0106191386240697
-0.0107801069782076
-0.0109394352386762
-0.0110969927699198
-0.011252521979388
-0.0114056871939203
-0.011556103966968
-0.0117033555023638
-0.0118470011926037
-0.0119865807776498
-0.0121216164518194
-0.0122516143956384
-0.0123760666530184
-0.012494453955918
-0.01260624995491
-0.0127109272740578
-0.012807965797768
-0.0128968635408531
-0.0129771502827998
-0.0130484038134684
-0.0131102681278836
-0.0131624722806778
-0.0132048480532407
-0.0132373445203289
-0.0132600387989401
-0.0132731457963573
-0.0132770365302244
-0.0132722844019117
-0.0132597702506665
-0.0132408886518782
-0.0132179089513593
-0.0131945529301325
-0.0131768518690916
-0.0131743343631856
-0.0132015775418302
-0.0132801583655779
-0.0134411376098202
-0.013728517761036
-0.0142049253579999

# Dynamic constraint 2 (y_dot - f = 0) : 
0 0 4
0.04232390367241
0.0417099187752101
0.0412763498581295
0.040990169472333
0.0408182669467282
0.040734031666867
0.0407167372054653
0.0407495470597251
0.0408179514352112
0.0409090004524323
0.041011151423347
0.0411144116374145
0.041210507628427
0.0412929246817722
0.0413567688864683
0.0413984771945691
0.0414154332120471
0.0414055474122654
0.0413668445871451
0.0412970809298853
0.0411933955886254
0.0410519899408013
0.0408678226240358
0.040634309464868
0.0403430254710153
0.0399834219059613
0.0395425990685744
0.0390052220684426
0.0383537408787379
0.0375691808947779
0.0366328879291365
0.0355296653936063
0.0342525459464696
0.0328087005372418
0.0312245324305432
0.0295464822025101
0.0278344594887014
0.0261488983179158
0.0245378324303795
0.0230308173131033
0.0216407038809285
0.020369148497349
0.0192117578161308
0.0181611157921902
0.01720767887355
0.0163392769100586
0.015540058235219
0.014789570381178
0.0140629041377316
0.013334225214604

# Dynamic constraint 3 (y_dot - f = 0) : 
0 0 4
5921.23550556559
5926.74349867591
5927.43085490886
5927.67670518295
5927.76588200313
5927.79864603769
5927.81093916858
5927.81579152159
5927.81795296355
5927.81914991854
5927.81999591269
5927.82069228049
5927.82128757224
5927.82177495242
5927.82212977866
5927.82232491105
5927.82233755212
5927.82215267431
5927.82176486915
5927.82117927075
5927.82041178253
5927.81948869725
5927.81844576367
5927.81732675443
5927.81618160416
5927.81506420274
5927.81402994115
5927.81313311895
5927.81242432734
5927.81194792349
5927.81173970975
5927.81182492157
5927.81221660938
5927.81291448355
5927.81390424712
5927.81515735276
5927.81663092545
5927.81826710755
5927.81998983743
5927.82169370364
5927.82320935761
5927.82420491923
5927.823918019
5927.8204116272
5927.80852765743
5927.77421651717
5927.67865575897
5927.41298336218
5926.66576153901
5920.76103653436

# Dynamic constraint 4 (y_dot - f = 0) : 
0 0 4
-4072.59892693696
-4076.26281929857
-4076.8331012178
-4077.03067552555
-4077.10026343711
-4077.12499974625
-4077.13380294505
-4077.13690517084
-4077.13797422702
-4077.13833912096
-4077.13848594843
-4077.1385933652
-4077.13872579804
-4077.1389036213
-4077.13912888149
-4077.13939495703
-4077.13969045274
-4077.14000106821
-4077.14031078748
-4077.14060285836
-4077.14086070737
-4077.14106881602
-4077.14121354295
-4077.14128386421
-4077.14127199813
-4077.14117388566
-4077.14098950432
-4077.14072300127
-4077.14038263735
-4077.1399805429
-4077.13953229223
-4077.13905630622
-4077.1385730981
-4077.13810438857
-4077.13767208718
-4077.13729704999
-4077.13699739384
-4077.13678567221
-4077.13666324271
-4077.13660883341
-4077.13656209176
-4077.13627049072
-4077.13510603323
-4077.13132769706
-4077.12010268999
-4077.08792493934
-4076.99654277887
-4076.73485322606
-4075.96692340699
-4071.33366664726

# Dynamic constraint 5 (y_dot - f = 0) : 
0 0 4
15.4247710310108
16.6668877782135
16.9570256606698
17.0355937384145
17.057750697702
17.0639832647795
17.0656927751988
17.0661370803338
17.0662385233212
17.0662521571848
17.0662457415034
17.0662360610426
17.0662267007328
17.0662181092962
17.0662101101774
17.0662024563002
17.0661949207626
17.0661872948927
17.0661793752355
17.0661709527498
17.0661618041339
17.0661516836152
17.0661403136872
17.0661273747848
17.0661124939454
17.0660952317974
17.0660750679148
17.0660513855863
17.0660234581887
17.0659904410385
17.0659513747717
17.0659052067316
17.0658508340643
17.0657871730913
17.0657132510033
17.0656282847903
17.0655316662146
17.065422667552
17.0652993597151
17.0651551659356
17.0649679859929
17.064665639588
17.0640158728769
17.0622755800216
17.0570712348044
17.0408099716107
16.9890293785075
16.8210973941779
16.251734383338
14.0483092899911

# Dynamic constraint 6 (y_dot - f = 0) : 
0 0 4
-9937.13510506592
-9942.67312148849
-9943.03317793557
-9943.16883188564
-9943.21995493229
-9943.23923273211
-9943.24650788497
-9943.24925558573
-9943.25029393106
-9943.25068631066
-9943.25083438978
-9943.25089004979
-9943.25091079237
-9943.25091842256
-9943.25092122513
-9943.25092235518
-9943.25092301475
-9943.25092365635
-9943.25092443885
-9943.25092540111
-9943.25092652729
-9943.25092777422
-9943.25092908452
-9943.25093039066
-9943.25093161742
-9943.25093268693
-9943.25093352377
-9943.25093405873
-9943.25093422929
-9943.25093397585
-9943.25093323316
-9943.25093192356
-9943.25092994356
-9943.25092710528
-9943.25092298373
-9943.25091660033
-9943.2509055656
-9943.25088375374
-9943.25083444454
-9943.25070719087
-9943.25032130988
-9943.24936818412
-9943.24685512267
-9943.24015405994
-9943.22220854
-9943.17387693995
-9943.04274106972
-9942.68429682965
-9941.69122277081
-9931.48619609712

# Dynamic constraint 7 (y_dot - f = 0) : 
0 0 4
0.00911243758357028
0.00875695906898111
0.00856927112737416
0.00844458816061144
0.00834384488956985
0.00825443971659467
0.00817697730575495
0.00811553438343426
0.00807309879018803
0.00805040650746491
0.00804624746174576
0.00805816939316939
0.00808312106162412
0.00811787810122855
0.00815924913314459
0.00820416421129244
0.00824975319824595
0.0082933690427982
0.00833240023066351
0.00836408416030809
0.00838580295714975
0.0083956047238074
0.00839266769054525
0.00837797893384651
0.00835634045541744
0.00834037389418563
0.00834872467988856
0.00838918671410016
0.00835484250895635
0.00791251138339666
0.00707311819983492
0.00618698755796787
0.00530764127538141
0.00452020174235068
0.00385307477001462
0.00332911961673366
0.00292193541572894
0.00260755522713774
0.00238332965319454
0.00226405314590816
0.00227187737403034
0.00247250391019227
0.00311049563410049
0.00271401829585682
0.00441002123714984
0.00583039273344643
0.00623074166269366
0.0059074780299887
0.00257700693270158
-0.0102147598190248

# Dynamic constraint 8 (y_dot - f = 0) : 
0 0 4
-0.0118081156769749
-0.0106528821689804
-0.00978110613044891
-0.00909341067011349
-0.0085288924282918
-0.00804743565819899
-0.00762189552921999
-0.00723365431510681
-0.00686953345106756
-0.00651948085054355
-0.00617492976981771
-0.00582806197116459
-0.00547226789863142
-0.00510390523567339
-0.00472466384303871
-0.00434252703390925
-0.00396924274550936
-0.0036159646006555
-0.00329220193016733
-0.00300660732387692
-0.0027619558017431
-0.00255174036882821
-0.00236765775453218
-0.00220172116136585
-0.00203552440076105
-0.00185702333430326
-0.00167971183734816
-0.00149310292039084
-0.0012831349767245
-0.00103890732584422
-0.000840017592316999
-0.00067887704634717
-0.000557252721181123
-0.000452186211750083
-0.000355196683434644
-0.000266429983656447
-0.000188947310123422
-0.000122210382326016
-6.07244922620209e-05
1.90194901331653e-05
0.000213038438579199
0.000707340472387602
0.00954106491316634
0.0247810086806175
0.0421338844886066
0.0448868546123926
0.046000037702245
0.0473024414490026
0.0453176279027489
0.00109573926373766

# Dynamic constraint 9 (y_dot - f = 0) : 
0 0 4
0.0128250649180761
0.012547136261034
0.0122383188581027
0.0119143033038077
0.0115877335481399
0.0112663157417964
0.0109540335588312
0.0106524917040015
0.0103619891639705
0.0100822451174091
0.00981282190846261
0.00955333049932622
0.00930349609923981
0.00906314416858617
0.0088321535152609
0.00861041708484239
0.00839783784725678
0.0081943571577221
0.00799998988594464
0.00781488635117861
0.00763947137590568
0.00747460759888588
0.00732171515406593
0.00718283571517139
0.00706074481868701
0.00695922892199941
0.0068824617519348
0.00683155060879645
0.0067890903216635
0.0067043301718181
0.00658674451371771
0.00647304172534705
0.00635607641696731
0.00624924420812262
0.0061580267417453
0.00608578185914684
0.00601502590031479
0.0059103406757826
0.0057217438013748
0.00536937901012348
0.00473303041892261
0.00357769369164219
0.00219544671587425
0.00128208743821377
-0.00147132611326923
-0.00419995344529062
-0.00530440898327324
-0.00636845506192917
-0.00556369053475368
-0.000248861490936937

# Dynamic constraint 10 (y_dot - f = 0) : 
0 0 4
0.947422140706487
0.298722988935256
0.171804739569619
0.124593146901375
0.10061994653842
0.0867738955123099
0.0781877717176143
0.0726468415950403
0.0690045407626088
0.0666136048913495
0.065074426568448
0.0641192150013496
0.0635547727240666
0.0632338389132638
0.0630386817277833
0.0628709386471533
0.0626411836795411
0.0622633152992089
0.0616408847019734
0.0606515441821135
0.0591324031548983
0.0568524621157251
0.0534924693414677
0.048683740812106
0.0422585355384987
0.0348323748988868
0.0277881857800051
0.0212279315515347
0.0131258865495182
0.00522485294698927
0.00253483865885706
0.00130078296834796
0.00078223864823479
0.000471985147092346
0.000252919045120759
7.23585942301874e-05
-0.000102210356138499
-0.000308139955327306
-0.000594876330798078
-0.00105303466787771
-0.00209551759371912
-0.00521818240306754
-0.0130528062512444
-0.0181202217786459
-0.0285508699775031
-0.0313518673712767
-0.0379760284326698
-0.0544563103031528
-0.104583623086076
-0.971109943233311

# Dynamic constraint 11 (y_dot - f = 0) : 
0 0 4
-1.03274496746209
-0.203797585071335
-0.10465224859485
-0.0710916184758585
-0.0545146740279479
-0.0450411712425929
-0.0389827555344944
-0.0347634317315491
-0.0316408544252069
-0.0292343170663845
-0.0273321467519998
-0.0258071915857934
-0.0245775698744986
-0.023587517589601
-0.0227975973532937
-0.0221794084497429
-0.0217124807603426
-0.0213823154585953
-0.021179212196329
-0.0210975750029516
-0.0211352733944197
-0.0212932435483695
-0.0215757073702081
-0.0219902858535468
-0.022548008285773
-0.0232669186611933
-0.0241797519477438
-0.02533586437016
-0.0267764749734032
-0.0284488156817493
-0.0302596002366831
-0.0321696298717447
-0.0341333867742484
-0.036098598682845
-0.0379965524473711
-0.0397400336210132
-0.041238041186904
-0.0424318378437394
-0.0433010912698122
-0.043858602516798
-0.0441368100350585
-0.0441336683108742
-0.0448888140786754
-0.0481797487827782
-0.0658668288342876
-0.0956784716317034
-0.146704864445219
-0.246632534424597
-0.606039292033488
-1.68065846867212

# Dynamic constraint 12 (y_dot - f = 0) : 
0 0 4
0.465039342425107
0.182277391015626
0.115633925514148
0.0844689756255572
0.0667410803601174
0.0557239791742883
0.0483752758160602
0.0431721239175596
0.0393001342503502
0.0363004114792624
0.0339022741747063
0.0319391478928155
0.0303042817295897
0.0289265401673703
0.0277567399275551
0.0267597125876608
0.0259095638094756
0.0251867625800425
0.0245763039278604
0.0240665169199274
0.0236482718719808
0.0233144447122024
0.0230595529983962
0.0228795086137343
0.022771449040466
0.0227335951993173
0.0227650404342789
0.0228654741086121
0.0230351728415865
0.0232758010382327
0.0235913164944302
0.0239865600755727
0.0244662028628581
0.0250351731621328
0.0256986390733732
0.0264620227118465
0.0273307118020413
0.0283095675900663
0.0294019296536013
0.030607238129042
0.0319143783962107
0.033292548372209
0.0346691478438041
0.0365958648748117
0.0419836163312423
0.0524067961197042
0.0697430237922717
0.103700262935854
0.17943665528469
0.473607082778798

# Dynamic constraint 13 (y_dot - f = 0) : 
0 0 4
-2.85545118133437
-1.30862243943454
-0.600159057972687
-0.293993448377488
-0.17327656268081
-0.126867315527488
-0.100413459460865
-0.0835618576778376
-0.0722028817214717
-0.0641871720031268
-0.0583067196737321
-0.0538470334407304
-0.050369279272239
-0.047595304015573
-0.0453437590369639
-0.0434932687320284
-0.0419605679091504
-0.0406872123461923
-0.0396313353415767
-0.0387624421522492
-0.0380580698793587
-0.0375016145502798
-0.0370809031238757
-0.0367872522487236
-0.0366148551761381
-0.0365604000871151
-0.0366228629054426
-0.0368034449585615
-0.0371056467815762
-0.0375354884548234
-0.0381019081651797
-0.0388173987973595
-0.0396989836850601
-0.0407696971202132
-0.0420608392685047
-0.0436154469877543
-0.0454937116856193
-0.0477815742996732
-0.0506046096011197
-0.0541509219483771
-0.0587098298525834
-0.0647392046937512
-0.0729872738684438
-0.0847250186409347
-0.102229189273014
-0.129890945596753
-0.179589895925158
-0.313069526376784
-0.651008611317284
-1.42174353672102

# Dynamic constraint 14 (y_dot - f = 0) : 
0 0 4
-0.00380040995098341
-0.0342728375988405
-0.0330593083451904
-0.0320181478260746
-0.0318921345263471
-0.0317510110794462
-0.0314167838479514
-0.0312557291690956
-0.0312579280485327
-0.0312525643987993
-0.031289090227648
-0.0313594266222247
-0.0313003311533577
-0.0311725125057589
-0.0311445481608813
-0.0311669878973936
-0.0311794562712386
-0.0311898078068198
-0.0312000008507983
-0.0312095744471168
-0.0312112553264084
-0.0312178414227128
-0.0312343217491051
-0.0312388949801623
-0.0312264102481082
-0.0312243933180546
-0.0312373910117852
-0.0312373283183074
-0.0312274810540383
-0.031203866319086
-0.0311640382661803
-0.0311838072772073
-0.031247649842896
-0.0312722572839284
-0.031274264042683
-0.0311996925096346
-0.0328778533668539
-0.0361841690110309
-0.0355680558532585
-0.0350454595986509
-0.0354125471846692
-0.0376983868125745
-0.0058121168452383
-0.00266713691317377
-0.00223591794900257
-0.00245808071091702
-0.00395274767989173
-0.009563198525256
-0.0145865621994467
-0.0176530607265216

# Dynamic constraint 15 (y_dot - f = 0) : 
0 0 4
0.00387966105954768
0.0105346265019545
0.00846034207277131
0.00811511033053883
0.00783829947201781
0.00722538695656413
0.00690657189899545
0.0069187733372566
0.00691456851739418
0.00691421073916197
0.00688681874470842
0.00685546553223993
0.00687931673033245
0.00690466141269909
0.00690264566076254
0.00690337965335561
0.00690489490022198
0.00690215805387277
0.00689991684971767
0.00689971244283256
0.00690270394523457
0.00690408052221361
0.00689823345115583
0.00689592676371174
0.00689701495454845
0.00691279496550658
0.00693634284249993
0.00691594568049008
0.00691633953579159
0.00695198419941622
0.00693433977948353
0.00689776358806429
0.00689893108271474
0.00692809263980553
0.00694036213036527
0.00696427627221011
0.00766033668078766
0.0093460159216174
0.0111990047213525
0.011796415088809
0.0117051908292541
0.0109381858996016
0.00106497368065264
0.00105746851450546
0.000742877352715398
0.000614845220271047
0.000544178376031379
0.00050968641934121
0.000503330197321308
0.000555355348777778

# Dynamic constraint 16 (y_dot - f = 0) : 
0 0 4
-0.000232748419348968
0.00384780380168932
0.00305424080990724
0.00312568753406121
0.00314931891116443
0.00315679701694465
0.00315908635562502
0.00315992086881037
0.00316018956120455
0.00316025228350912
0.00316021764769095
0.00316013913333999
0.00316019004575548
0.00316024269032086
0.00316026720669074
0.0031602783202607
0.00316028296129289
0.00316029230738165
0.00316028552592931
0.00316028010002559
0.00316027835494643
0.00316024564576486
0.00316030789973497
0.00316026879542166
0.00316027297570142
0.00316023747789291
0.00316029963289795
0.00316027432299665
0.00316025257192121
0.00316031241847204
0.00316027214887715
0.00316029259820866
0.00316030144840929
0.00316035288319407
0.00316047089670771
0.00316069629080865
0.00316093983782869
0.00207848519579232
0.00315915646521342
0.00307634561516041
0.00313816098614136
0.00352642192187351
-0.00723969727205827
-0.00794571582581483
-0.00609217854554009
-0.00492607742390973
-0.00417085601760455
-0.00365141425419137
-0.00327865640855209
-0.00300300348196993

# Dynamic constraint 17 (y_dot - f = 0) : 
0 0 4
-3335.01333195747
-3338.46548900382
-3339.19576967788
-3339.43366277588
-3339.51382606594
-3339.54166830022
-3339.55161271101
-3339.55512088653
-3339.55637299928
-3339.55682893802
-3339.55699849148
-3339.5570851521
-3339.55707558804
-3339.55707837866
-3339.55708463319
-3339.55709011154
-3339.55709098362
-3339.55707974146
-3339.55707432561
-3339.55706149234
-3339.55704498114
-3339.55702773232
-3339.5569344665
-3339.55694467492
-3339.55692337599
-3339.55690366735
-3339.55683457263
-3339.55684330449
-3339.55683812199
-3339.55677751618
-3339.55680267958
-3339.5567714211
-3339.55676169884
-3339.5567586421
-3339.55674735456
-3339.55673069797
-3339.55700422127
-3339.56246343005
-3339.55032138244
-3339.5490665443
-3339.54883793825
-3339.54842644534
-3339.54724818405
-3339.54400106617
-3339.53498595916
-3339.50900495416
-3339.43298272291
-3339.20640340031
-3338.50967704019
-3334.9614218719

# Dynamic constraint 18 (y_dot - f = 0) : 
0 0 4
-16734.9645420564
-16739.9229957892
-16740.7891519736
-16741.0831140645
-16741.1875427147
-16741.2249237805
-16741.2381118627
-16741.2429322948
-16741.244580576
-16741.2449035688
-16741.2445757829
-16741.243791394
-16741.2428690688
-16741.2417170504
-16741.2404186657
-16741.2390502354
-16741.2376961894
-16741.2364578363
-16741.2353708387
-16741.2345299828
-16741.2339882595
-16741.2337740036
-16741.2341886288
-16741.2347888768
-16741.2358446024
-16741.2372464026
-16741.2392064205
-16741.2412277746
-16741.24344247
-16741.2459353295
-16741.2482041742
-16741.2504901837
-16741.2525027715
-16741.254120688
-16741.2551913812
-16741.2554152472
-16741.2538779243
-16741.2460603835
-16741.2301733366
-16741.2272657386
-16741.2249009574
-16741.2216625856
-16741.2171192973
-16741.2098269282
-16741.1955673075
-16741.1621824009
-16741.07493544
-16740.8333157085
-16740.1389104339
-16735.6866970352

# Dynamic constraint 19 (y_dot - f = 0) : 
0 0 4
8.56643831608478
10.0070724973821
10.4064763911131
10.5294751374319
10.5691375174405
10.5821096312141
10.5859523876924
10.5873672614998
10.5878631555787
10.5880618650238
10.5882159966154
10.5881148804445
10.5879818760888
10.5880506854797
10.5880765466264
10.5880933375463
10.5880979005348
10.5881115340031
10.5881225956868
10.5881186532362
10.5881118708825
10.5881329506732
10.5881451969856
10.5881178712675
10.5881278086196
10.5881378543954
10.588131471636
10.5881136028339
10.5881327367061
10.588121398803
10.5881286795524
10.5881665615754
10.5881068344052
10.5880182478588
10.587889612948
10.5876576438192
10.5879147569714
10.5871524839452
10.5879076212018
10.5893472389113
10.5899037031334
10.5899147385024
10.5895393188805
10.5881988702909
10.5840440046925
10.5714212606267
10.532766920785
10.4120959716674
10.0192146198823
8.62859643385728

# Dynamic constraint 20 (y_dot - f = 0) : 
0 0 4
-9934.03382773435
-9941.47487575277
-9942.53644311862
-9942.90824539599
-9943.04058125643
-9943.08863574203
-9943.10684868214
-9943.11357487728
-9943.11606616252
-9943.11700115175
-9943.11736070455
-9943.11757186798
-9943.1175529038
-9943.11753333434
-9943.11752511874
-9943.11752654545
-9943.11753036517
-9943.11751547433
-9943.11752511038
-9943.11753592192
-9943.11756124458
-9943.11762593928
-9943.11743286046
-9943.11751332224
-9943.11754587127
-9943.11763981532
-9943.11740413493
-9943.11750612667
-9943.11759374363
-9943.11746539291
-9943.11759440381
-9943.11756035205
-9943.1175809136
-9943.11771629844
-9943.11818851708
-9943.12001005698
-9943.12796106206
-9943.16642045852
-9943.12787306348
-9943.12008930478
-9943.11834073087
-9943.11724872378
-9943.11489075339
-9943.1090627449
-9943.09420274732
-9943.05416163095
-9942.94474995648
-9942.64253713461
-9941.79456578292
-9935.47901644362

# Dynamic constraint 21 (y_dot - f = 0) : 
0 0 4
-0.0163223921747876
-0.011769367201263
-0.00939061960584398
-0.00753562730303392
-0.00605972622338047
-0.00495069971523465
-0.00414902616997159
-0.003573260605786
-0.00315679802357371
-0.00285386556954526
-0.0026360833928929
-0.00248493298296881
-0.0023847311435109
-0.00232255049442287
-0.0022906458759212
-0.00228536297356874
-0.00230349798231166
-0.00234201873727635
-0.00239885373550108
-0.00247314527927944
-0.00256584680061667
-0.00267997900945238
-0.00281805167952143
-0.00298015808520891
-0.00316438669178631
-0.00336699499764326
-0.00358153947733975
-0.00379764645022684
-0.00400052862881051
-0.00417167065130342
-0.00429041106727679
-0.00433621033589748
-0.00429207962781841
-0.00415043412571092
-0.00392087504430705
-0.00363281545661409
-0.00332447053764162
-0.00302695074722081
-0.00275820578331265
-0.0025235271798395
-0.00232102252494137
-0.0021453666886162
-0.00198979023207946
-0.00184735077390141
-0.00171198229238911
-0.00157859654368153
-0.00144186717920491
-0.0012999218942531
-0.00115966404519141
-0.000985544888076451

# Dynamic constraint 22 (y_dot - f = 0) : 
0 0 4
0.00085709579014813
0.00108716442240564
0.00136683453429871
0.00168030510064685
0.00203423045506959
0.00243638077116282
0.00290148948102767
0.00347071748551617
0.00420880931852638
0.00518123532749315
0.00640194602517968
0.00778119781832365
0.0091850126896279
0.0105164476378065
0.0117271782862186
0.0127995964101993
0.0137337512720903
0.0145394355710418
0.0152300989214113
0.0158187607818584
0.0163167995719288
0.0167348901730154
0.0170857067510644
0.0173845445676464
0.0176482851817381
0.0178941564598931
0.0181398446196293
0.0184026355903754
0.0186973900460348
0.0190341774110777
0.0194176697203474
0.019848735601171
0.0203282434360473
0.0208615999417437
0.0214614666605109
0.0221462571611941
0.0229343201655103
0.0238380951185407
0.0248630499208012
0.0260124072909205
0.0272985801393438
0.0287630215379289
0.0305056968101061
0.0327264814014298
0.0358001441136424
0.0404364224147329
0.049075969750604
0.0635199938322975
0.0610784082801903
0.0645663986943342

# Dynamic constraint 23 (y_dot - f = 0) : 
0 0 4
-0.00239848721373843
-0.00216630977644111
-0.00199120946038761
-0.00183198793008363
-0.00166676191092802
-0.00149329955939095
-0.00130902652756715
-0.00111999862668652
-0.000943220635580083
-0.000791051612766408
-0.000662689118557075
-0.000549034285638211
-0.000444070515483175
-0.000345546524260804
-0.000250892496221206
-0.000158324391771436
-6.85010928430374e-05
1.87011152222583e-05
0.000104200977131541
0.000188380263443783
0.000270797755060559
0.000352190108466127
0.000434382111611231
0.000518341004395018
0.000605282653032058
0.000697778585541181
0.000797682472699374
0.000903006484664459
0.00100910784940178
0.00111166582238528
0.00120777401408276
0.00129632056190485
0.00137845317863775
0.00145726849294922
0.00153677681855982
0.00162091936066058
0.00171319897806435
0.00181687406670594
0.00193528150334671
0.00207202074916135
0.00223089970226434
0.00241597782605982
0.00263198859127582
0.00288568385875072
0.00318843985053339
0.00356053743720383
0.00404016316176635
0.0047123770534067
0.0058288569234193
0.00803834240556745

# Dynamic constraint 24 (y_dot - f = 0) : 
0 0 4
-0.332069980911228
-0.114915718564617
-0.0631524429214518
-0.0413707387984759
-0.031786787899298
-0.0264550242215126
-0.0229285046366057
-0.0203053962961673
-0.0182239251960968
-0.0165078141342166
-0.0150510623785948
-0.013784659984705
-0.0126643330748418
-0.0116632081716445
-0.0107646864771932
-0.00995777124723984
-0.00923563769096944
-0.008593328674946
-0.00802656669581439
-0.00753179468106355
-0.00710575158232432
-0.00674427652376651
-0.00644367244675825
-0.00620176692029198
-0.0060170898011157
-0.00588844880647107
-0.00581512609759732
-0.00579728474840124
-0.00583603304245905
-0.00593312764290799
-0.00609096250388935
-0.0063130473946148
-0.00660479922155172
-0.00697442742287213
-0.00743341329544178
-0.007995985878406
-0.00867775670542348
-0.00949490958741206
-0.0104646930834542
-0.0116069374955495
-0.0129479221377677
-0.0145287412289057
-0.0164237056034031
-0.0187855315505006
-0.0219670253925091
-0.0268536350913871
-0.0359365929320807
-0.0569857441490484
-0.114996574513638
-1.30739508708991

# Dynamic constraint 25 (y_dot - f = 0) : 
0 0 4
-0.704831337668356
-0.12501707368063
-0.066689060581804
-0.0432817852134049
-0.0327346814689964
-0.0268951143618388
-0.0230836611418115
-0.0203134052523324
-0.0181752889624129
-0.0164871472258277
-0.0151553315415331
-0.0141150524334333
-0.0133167141965638
-0.0127200997721735
-0.012292318399254
-0.0120068827128135
-0.0118420462742117
-0.0117816658001737
-0.0118147998733948
-0.0119342084892633
-0.0121354014085155
-0.0124163761448339
-0.0127759070167679
-0.0132125168286192
-0.0137249310724883
-0.0143126988383915
-0.0149767483416303
-0.0157204397013593
-0.0165515521350916
-0.0174836102614253
-0.0185364539737307
-0.0197358396042735
-0.0211117302806159
-0.022694607398809
-0.0245096039078159
-0.0265720747683837
-0.0288904875689071
-0.0314781546455292
-0.0343724737551536
-0.0376619002575387
-0.0415216446804956
-0.0462651499496989
-0.0524291971099733
-0.0609502697385351
-0.0735360090831807
-0.0936241510666851
-0.128212325861426
-0.196503498355209
-0.363370555010733
-1.43639181993749

# Dynamic constraint 26 (y_dot - f = 0) : 
0 0 4
0.354622556995212
0.159771591747558
0.10950642541088
0.0830549440676895
0.0673225465570811
0.0571745990549041
0.0501878200910619
0.0451108566069113
0.041256595540382
0.0382276579866013
0.0357832651915981
0.0337711055541656
0.032090998784324
0.030674653809148
0.0294739975234004
0.028454250689126
0.0275896469859745
0.0268607141650806
0.0262525500266282
0.0257536666437529
0.025355181596823
0.0250502897782511
0.0248339245076536
0.0247024935714301
0.024653683513059
0.0246863771067827
0.0248005910307286
0.0249974252676083
0.0252791243802281
0.0256491802673316
0.0261124870153887
0.0266756519147223
0.027347461603954
0.0281395314904344
0.0290672210855725
0.0301509717560007
0.0314183306378462
0.0329071082060617
0.0346704594935978
0.0367853003539911
0.0393666109119779
0.0425923848113976
0.0467486350196458
0.0523132196489039
0.0601196660761034
0.0716966398533228
0.0900346915804374
0.121643217416901
0.188151122351228
0.490783096180655

# Dynamic constraint 27 (y_dot - f = 0) : 
0 0 4
-1.96623425633424
-0.788031061993315
-0.336605679967782
-0.18257879928785
-0.130385129659451
-0.101718119689371
-0.0837916665881826
-0.0718677142294095
-0.06353745469755
-0.0574722581264209
-0.0528975793878361
-0.0493432604938975
-0.0465141768445103
-0.0442194590934055
-0.042332199672563
-0.0407657903758545
-0.0394596677065624
-0.0383705367162017
-0.0374668627031896
-0.0367253530505613
-0.0361286746050475
-0.0356639532464844
-0.0353217796563539
-0.0350955517988494
-0.0349810499192702
-0.0349761810012037
-0.035080856734325
-0.035296988419895
-0.035628598128576
-0.0360820611694317
-0.0366665138385898
-0.0373944866171119
-0.0382828625299441
-0.0393543229487161
-0.0406395449875374
-0.0421805840001408
-0.0440361618642617
-0.0462900794644199
-0.0490648573138124
-0.0525443349278056
-0.0570120663515228
-0.0629185746264751
-0.0710038105428898
-0.0825322500481542
-0.0997834046393642
-0.127207803153331
-0.175944241378886
-0.315073551333356
-0.72650869728826
-1.8094751525988

# Dynamic constraint 28 (y_dot - f = 0) : 
0 0 4
-0.000995396470350851
-0.00439238702100075
-0.0275971256962422
-0.0274780206895476
-0.0274813012785453
-0.027489169996033
-0.0274944116905108
-0.0274947158988758
-0.0274944180521991
-0.0274953668929491
-0.0274958616700305
-0.0274997882795294
-0.02750345484081
-0.0274999718134069
-0.027500582558395
-0.0275049021171824
-0.0275014421129574
-0.0275011768406485
-0.027508565093742
-0.0275101727391286
-0.0275068122893972
-0.027507396076722
-0.0275096890769224
-0.0275109018923702
-0.0275111369130029
-0.0275112083714716
-0.0275121134859116
-0.0275136145495558
-0.0275155260835521
-0.0275209246880669
-0.0275238833483895
-0.0275199058942447
-0.0275199143660951
-0.0275224113479671
-0.0275194191393162
-0.0275032802079147
-0.0274871354428187
-0.0275109647850488
-0.0275421258281545
-0.0275370034699537
-0.0275314315933004
-0.0275343191542635
-0.0275321432305375
-0.027510558638711
-0.031745781981623
0.106744758804533
0.104651175452726
0.111342378359506
0.123070736665172
0.136297497751184

# Dynamic constraint 29 (y_dot - f = 0) : 
0 0 4
0.0575391195699573
0.0207348908815653
-0.00295702432799064
-0.00142321245023988
-0.00160419934751624
-0.00158022481543238
-0.00158827531633836
-0.00158340692022213
-0.00158097040429523
-0.00158234450127254
-0.00158116652108019
-0.00158125105856996
-0.00158152978960702
-0.00158142263219807
-0.00158101921442996
-0.00158229308942435
-0.001581418754239
-0.001581469297382
-0.00158177884354531
-0.00158265854023407
-0.0015813091354613
-0.00158138998887112
-0.0015817471576611
-0.00158140130418238
-0.00158131642373633
-0.00158152634568491
-0.00158144625987161
-0.00158148348978889
-0.00158138664148536
-0.00158115162878478
-0.00158213870754102
-0.0015806719832958
-0.0015820274350354
-0.00158220882427984
-0.0015793505121891
-0.00158482571308327
-0.0015796951106798
-0.00158141174577164
-0.00158926455358298
-0.00157980181294619
-0.00158339503617597
-0.00158820538878466
-0.00157347951417772
-0.00158041090536429
-0.00163391415260928
-0.00131443633094743
-0.00129379520883786
-0.00128604108291415
-0.00126327145379003
-0.0011810741710817

# Dynamic constraint 30 (y_dot - f = 0) : 
0 0 4
0.0094085569332523
0.00728384518632953
0.00395249058849018
0.00403516715079771
0.00406177291328157
0.00407045177264811
0.00407330107194435
0.00407424267746393
0.00407455256506262
0.00407465735342659
0.00407469310364191
0.00407470518581053
0.00407470848413372
0.00407471046487763
0.00407471103130035
0.00407471151645756
0.00407471151188075
0.00407471008826724
0.00407471389930035
0.00407471097145018
0.00407470910841428
0.0040747079819892
0.00407470710190668
0.00407470720269061
0.00407470736327973
0.00407470656602547
0.00407470497938109
0.00407470341108297
0.0040747022651366
0.00407470078340215
0.00407469956687044
0.00407469973079587
0.00407469662248057
0.00407469523494394
0.00407469529726668
0.00407469780851528
0.00407470592510228
0.00407471657774507
0.00407472876184079
0.004074772015516
0.00407487995294242
0.00407519368394074
0.00407608343604835
0.0040786055110034
0.00408579772338303
0.00333523210645442
0.00334089678738749
0.00334385749491968
0.00334992160688203
0.00336751325423048

# Dynamic constraint 31 (y_dot - f = 0) : 
0 0 4
-3956.58223880284
-3960.16007444349
-3960.9098847888
-3961.15321464345
-3961.23507913569
-3961.26313425335
-3961.27286315755
-3961.27625948654
-3961.2774654976
-3961.2778975444
-3961.27805375097
-3961.27810919523
-3961.2781264301
-3961.27812469996
-3961.27811532652
-3961.2781008259
-3961.27808544264
-3961.27806716242
-3961.27803083247
-3961.27801211604
-3961.27799266792
-3961.27797400689
-3961.27795764032
-3961.27794499613
-3961.27793218324
-3961.2779283769
-3961.27792971367
-3961.2779362889
-3961.27794755869
-3961.27796434456
-3961.27798219237
-3961.27800114547
-3961.27802872368
-3961.27805636532
-3961.27808335035
-3961.27810839983
-3961.2781285327
-3961.27814608091
-3961.27815079956
-3961.27810752533
-3961.27800563018
-3961.27769162339
-3961.27678764264
-3961.27424335489
-3961.26728383027
-3961.25118368857
-3961.17139722465
-3960.97020300181
-3960.35995067262
-3957.14846349031

# Dynamic constraint 32 (y_dot - f = 0) : 
0 0 4
-19955.3744191901
-19959.2065095578
-19960.0035936848
-19960.2580084099
-19960.3428308189
-19960.3714852124
-19960.380990509
-19960.3838454278
-19960.3842878564
-19960.3838480136
-19960.3830898899
-19960.3822467524
-19960.3814367708
-19960.3807487873
-19960.3802357823
-19960.3799465001
-19960.3799082934
-19960.3801518636
-19960.3807301558
-19960.3815642381
-19960.3826610478
-19960.3839889345
-19960.385493023
-19960.3871106967
-19960.3887669387
-19960.3903860203
-19960.3918833568
-19960.3931790018
-19960.3941993027
-19960.3948752723
-19960.3951644344
-19960.3950381154
-19960.3944448786
-19960.3934070077
-19960.3919464943
-19960.3901038125
-19960.3879403282
-19960.3855213936
-19960.3829408078
-19960.3803432078
-19960.3776823619
-19960.3749471536
-19960.3717740384
-19960.3668882501
-19960.3563116453
-19960.326714227
-19960.2436101773
-19960.0428856502
-19959.4277753986
-19956.2300783228

# Dynamic constraint 33 (y_dot - f = 0) : 
0 0 4
10.3156472301012
11.8940772800761
12.322099320579
12.4525632334103
12.4941400629521
12.5076236646685
12.5120440395217
12.5135006992036
12.5139718769599
12.5141315287208
12.5141861332457
12.5142061447429
12.514213167378
12.5142157229322
12.5142178006653
12.5142167624747
12.5142149167917
12.5142208550576
12.5142248011296
12.5142192216765
12.5142178938914
12.514215558141
12.5142143613158
12.5142127554604
12.5142131237081
12.5142124267414
12.5142107826799
12.5142093851882
12.5142075282428
12.5142063451802
12.51420783907
12.5142085821381
12.5142058761375
12.514203644901
12.5142005219789
12.5141947493744
12.5141824326579
12.5141775041418
12.5141697797896
12.5141117445845
12.5139394895625
12.5134755616106
12.5121708533716
12.508463477104
12.4978730722141
12.4678853681146
12.3815709174819
12.1206563537605
11.3140453062174
8.58223921878957

# Dynamic constraint 34 (y_dot - f = 0) : 
0 0 4
-9935.76512516696
-9941.6798512179
-9942.56794026351
-9942.87832234959
-9942.98935757605
-9943.02961629344
-9943.04433495042
-9943.04973038379
-9943.05172474863
-9943.05246538333
-9943.05274051328
-9943.05284363785
-9943.05288407636
-9943.05289449567
-9943.05289742603
-9943.0528968658
-9943.05290324532
-9943.05290837773
-9943.05289472694
-9943.05289380434
-9943.05289806309
-9943.05289552483
-9943.05289262239
-9943.05288571789
-9943.05290096318
-9943.05289451369
-9943.05289176103
-9943.05289121576
-9943.05289196928
-9943.05289597054
-9943.0528946527
-9943.05288055251
-9943.05288432912
-9943.05288507531
-9943.05288051861
-9943.05287029234
-9943.05284532402
-9943.05278184677
-9943.05258315357
-9943.05201558162
-9943.05057987214
-9943.04675503717
-9943.03664431091
-9943.01002191862
-9942.94094980043
-9942.76821795364
-9942.16131609692
-9940.52301378282
-9935.55253070243
-9914.07967297089

# Dimension of the constraints multipliers : 
3691

# Constraint Multipliers : 

# Multipliers associated to the boundary conditions : 
-99.5400001598972
118.321024712763
-166.681523716484
-185.584377599127
188.212854707379
-185.322219789418
188.807025548472
-125.059641452976
136.649395756408
-136.273806833343
-187.448487182219
183.43758256786
-185.152658042429
184.838177275004
117.11200234091
-48.0150679695516
10.6070808406274
184.527620303812
184.831711799711
-184.602568002901
185.432730400769
143.531380154164
-27.6167279282345
74.6450061747816
184.310981236042
185.034558933907
-184.115728773496
185.384175961557
36.1772193626511
-173.455342175996
-119.283540126279
184.920250664596
184.456531504121
-184.471517183486
185.713055142635
-180.406566472287
42.2750461082547
-81.6625269402227
184.95899808605
185.068351091472
-183.755187900328

# Path constraint 0 multipliers : 
197.465393952823
197.467038707359
197.466787848564
197.466657332197
197.466579979158
197.466528109411
197.466489924736
197.466460209756
197.46643644047
197.466417118311
197.466401143874
197.46638753627
197.466375390642
197.466363865729
197.466352186715
197.466339677601
197.46632579215
197.466310094099
197.46629229726
197.466272264137
197.466250007906
197.466225684493
197.466199602412
197.466172192257
197.466143988048
197.466115621517
197.466087776729
197.466061172113
197.466036497778
197.46601443568
197.46599556895
197.465980382971
197.465969226742
197.465962267675
197.465959513309
197.465960758062
197.465965643265
197.465973698821
197.46598437642
197.465997185763
197.466011751095
197.466028064107
197.466046554835
197.466068683018
197.466097796224
197.466141097609
197.466214274706
197.466352725044
197.466634618669
197.46728573406

# Path constraint 1 multipliers : 
224.486479928357
241.64170706956
233.041117815018
233.041108236237
233.041108477896
233.041109621891
233.041108780202
233.04110776681
233.041107827212
233.041107815838
233.041107904209
233.041107918275
233.041107735646
233.041107729288
233.041107820809
233.041107812939
233.041107810242
233.041107824189
233.041107822492
233.041107815824
233.041107805523
233.041107810703
233.041107833864
233.041107822911
233.041107811027
233.041107763498
233.041107736938
233.04110788131
233.041107813327
233.041107696168
233.041107871731
233.041107935621
233.041107811902
233.041107718411
233.041107773574
233.04110773298
233.041105701677
233.041111595217
241.655532556232
241.57580114906
241.04089351711
245.329931332627
345.09758175498
224.354432513944
224.45044148781
224.482105593593
224.48794940083
224.489765215167
224.49052097735
224.493641976133

# Path constraint 2 multipliers : 
230.173661790231
230.406960987474
235.260527036164
235.260421364197
235.260434113034
235.260432326886
235.260432625476
235.260432518092
235.260432541509
235.260432576
235.260432553806
235.260432564918
235.260432566932
235.260432563156
235.260432560588
235.260432575735
235.260432556487
235.260432564424
235.260432567138
235.260432571875
235.260432552542
235.260432564845
235.260432567368
235.260432561152
235.260432563493
235.260432566023
235.260432563568
235.260432564596
235.260432563436
235.260432562136
235.260432572786
235.260432551153
235.260432575998
235.260432565912
235.26043253914
235.260432611892
235.26043251892
235.26043258013
235.260432634444
235.2604324831
235.260432600415
235.260432620821
235.260432475635
235.260432736038
235.260433440214
235.260421943029
230.227494122609
230.233580574476
230.249220085644
230.288994490049

# Dynamic constraint 0 (y_dot - f = 0) multipliers : 
100.652064573016
101.998133404376
103.256903049528
104.342952438593
105.251111254663
106.000006931691
106.613511204196
107.115193466311
107.52669948705
107.867188554249
108.1531077495
108.398175055237
108.613537125592
108.808052217474
108.988637146389
109.160624496576
109.328093374983
109.494154407101
109.661182928723
109.831002491688
110.005024899171
110.184354335455
110.36986298693
110.56224467455
110.762051985877
110.969721422919
111.185590294636
111.409908541971
111.642848355957
111.884514420849
112.134957848472
112.39419765314
112.662255098963
112.939209059626
113.225285498647
113.521002449637
113.827404629494
114.146439009514
114.481542244691
114.838527904057
115.226867955602
115.661445398189
116.164783660849
116.769561405632
117.520714181864
118.475132523121
119.693727316365
121.21289840551
122.965820185445
124.596072711744

# Dynamic constraint 1 (y_dot - f = 0) multipliers : 
-119.435372957267
-120.714520817818
-121.938177104281
-123.037430973015
-124.007936275231
-124.868431227045
-125.642618848116
-126.351953179061
-127.013349631227
-127.639048857819
-128.23732539584
-128.813417630486
-129.370397728587
-129.909876466488
-130.432525928916
-130.938442217515
-131.427383141157
-131.898915652613
-132.352502190119
-132.787548070834
-133.203425635058
-133.599485643206
-133.975062623922
-134.329478319011
-134.662045766679
-134.972075678401
-135.258886285764
-135.521817553565
-135.760250380052
-135.973630985756
-136.161500093813
-136.323525777785
-136.459538288983
-136.569565360532
-136.653868499972
-136.712986145869
-136.747799993889
-136.759657215377
-136.750602601444
-136.723796998728
-136.684214108725
-136.639701518532
-136.602429036051
-136.590550802306
-136.629409444752
-136.750453391442
-136.983495772679
-137.332786324093
-137.718828950633
-137.862941337016

# Dynamic constraint 2 (y_dot - f = 0) multipliers : 
166.489302029695
166.278906416924
166.102448625332
165.972062634279
165.885901335899
165.837449690864
165.819226793654
165.824080933377
165.845524665792
165.877778834438
165.915778772965
165.955194573505
165.992443725272
166.024666221028
166.049648363566
166.065699318697
166.071494821894
166.065904400768
166.047814693356
166.015955184427
165.968726361969
165.904025207352
165.819059570427
165.710141575567
165.57245121488
165.399765864176
165.184162050363
164.91571646744
164.582269144599
164.169366588444
163.6605724138
163.038392540021
162.286050237904
161.390164601779
160.343953102364
159.149978989317
157.821104075923
156.378771641707
154.849103309182
153.258549458811
151.630792013762
149.985405485944
148.337634581684
146.698277186187
145.073043302921
143.461704429938
141.858919480151
140.261441513874
138.691781876492
137.257233298929

# Dynamic constraint 3 (y_dot - f = 0) multipliers : 
186.139838767366
186.19122761772
186.16044580783
186.127375099665
186.106365239831
186.095188843314
186.089769035745
186.087287449479
186.086195115122
186.085728025995
186.085532905414
186.085453053063
186.085421300354
186.08540912922
186.085404713013
186.0854032578
186.085402812763
186.085402418793
186.085401944804
186.085401221087
186.085400115079
186.085398782241
186.085397160521
186.085395197793
186.085393234024
186.085391265617
186.085389369303
186.08538773592
186.085386393479
186.085385373581
186.085384700944
186.085384654045
186.085385192215
186.085386566763
186.085389291151
186.085394093114
186.085404047892
186.085426066846
186.08547788251
186.085604751635
186.085919012355
186.086697756984
186.088611811684
186.093257062459
186.104338057774
186.130185516689
186.188734692741
186.316249196797
186.579223652991
187.080220441597

# Dynamic constraint 4 (y_dot - f = 0) multipliers : 
-187.617747159852
-186.909843957256
-186.487032975557
-186.271830418008
-186.171235425144
-186.126651187925
-186.107598678165
-186.09966947283
-186.096435143792
-186.09513654767
-186.094622074887
-186.094420919996
-186.094343646453
-186.094315017081
-186.094305349537
-186.094303062819
-186.094303621412
-186.094305208587
-186.094307051422
-186.094308722673
-186.09431007051
-186.094310986016
-186.094311325041
-186.094310998929
-186.094309988246
-186.094308281706
-186.094305921723
-186.094302897947
-186.094299348715
-186.094295411175
-186.094291115171
-186.094286665094
-186.094282314642
-186.094278164255
-186.09427455888
-186.094271726164
-186.094269888714
-186.094268400275
-186.094263203293
-186.094237530588
-186.094133147346
-186.093763055228
-186.09254302857
-186.088731499946
-186.077343507599
-186.044720409809
-185.955469685731
-185.725195104831
-185.181244128229
-184.094295235271

# Dynamic constraint 5 (y_dot - f = 0) multipliers : 
185.682825808833
185.710048820025
185.654518977534
185.606730442668
185.579276915921
185.565938785533
185.560067063797
185.557658308475
185.556725366062
185.556379082652
185.556248351477
185.556187008952
185.556141117175
185.556092729015
185.556037082516
185.555973646517
185.555902695612
185.55582404888
185.555736621628
185.555638267905
185.555525696792
185.555394374395
185.555238382992
185.555050239892
185.554820712148
185.554538698268
185.554191330213
185.553764520396
185.553244277451
185.552619157489
185.551884068154
185.551045182842
185.550124754512
185.549163468015
185.548217453866
185.547348683567
185.546611683864
185.546044013282
185.545668713794
185.545514427005
185.545660942091
185.546333867025
185.548107584817
185.552331578927
185.561946311571
185.582769639594
185.624715315127
185.700695445192
185.820898040929
186.013857835435

# Dynamic constraint 6 (y_dot - f = 0) multipliers : 
-187.710438453075
-186.906728619202
-186.494947646006
-186.307215411259
-186.226867457863
-186.193806360754
-186.180560270738
-186.175353648774
-186.173335835472
-186.172562509287
-186.172268605054
-186.172157797727
-186.172116396063
-186.172101097752
-186.172095523221
-186.172093911236
-186.17209366273
-186.172093781587
-186.172094192039
-186.172094739394
-186.172095195996
-186.172095877657
-186.172096449821
-186.172096873013
-186.172097325887
-186.172097776255
-186.172098116624
-186.172098486624
-186.17209871216
-186.172098986878
-186.172099139481
-186.172099151828
-186.172098879493
-186.172098427186
-186.172097109557
-186.17209428568
-186.172087199784
-186.172069177713
-186.172020398728
-186.171887556812
-186.171523717027
-186.170532348294
-186.167867242388
-186.160818807924
-186.142569799231
-186.096661308012
-185.985883397118
-185.735668233779
-185.235346219765
-184.497954986257

# Dynamic constraint 7 (y_dot - f = 0) multipliers : 
123.01784560155
121.676110378877
120.795564443434
120.159711461669
119.655483596105
119.223131398252
118.852934805892
118.556487613049
118.346235725821
118.227164832581
118.195724629996
118.241722613379
118.350838855365
118.506826966755
118.693254832103
118.894807291923
119.09780364104
119.289861168102
119.460170646416
119.601162309624
119.708067858732
119.777548361869
119.813146404121
119.82835599524
119.835481273672
119.862546604185
119.962635095008
119.98426861082
119.148087025318
116.043036459539
111.601706667494
106.212342364757
100.362781336562
94.0294385323073
87.5581311436088
81.4485292507784
75.9825245428698
71.3194269038436
67.779551923978
65.8669244160718
65.8583513652646
67.9661368850006
78.7140192651168
73.2251978543587
93.1292470020792
104.904472185497
107.692197190521
105.443509340887
70.7076647987815
-122.844570069208

# Dynamic constraint 8 (y_dot - f = 0) multipliers : 
-132.85186067343
-129.276536781828
-126.035482891693
-123.150328637491
-120.557935973809
-118.178481505133
-115.936829799182
-113.766876194407
-111.609860263923
-109.410406492709
-107.1121646715
-104.655797519911
-101.982100085419
-99.0421343053269
-95.8129073702727
-92.3115027551251
-88.5977923384413
-84.7653814131238
-80.9332739180992
-77.2333258605124
-73.7641633803205
-70.543528192751
-67.5201655823041
-64.5764501800863
-61.4899576806215
-58.0994501460735
-54.4784319691746
-50.4492039708864
-45.262260887091
-38.029128028117
-31.6466488666376
-26.27113712761
-22.0897761772205
-18.2682196532015
-14.5843637666868
-11.1285851543501
-8.0559610576729
-5.40311638767593
-2.99110052956913
0.22773532802113
8.64968453533613
29.5130634921589
123.993901644476
155.529243275905
166.620267782501
167.595585255969
167.968739685675
168.436845009296
167.768001590105
40.8875367338779

# Dynamic constraint 9 (y_dot - f = 0) multipliers : 
135.460575480305
134.650919291856
133.787469198966
132.864465949298
131.895509939342
130.896856031741
129.881846749147
128.85950034585
127.835115238742
126.811522482079
125.79024957406
124.772338673284
123.75880650712
122.750845819754
121.749901158593
120.757722855342
119.77642215563
118.808567025373
117.857511261855
116.928038918096
116.026868455509
115.163071792538
114.349121625093
113.601219993302
112.937525531455
112.379249439655
111.947946258188
111.620500104326
111.238237776954
110.526735365388
109.750533500023
108.9824037691
108.311688744726
107.681606010393
107.103161916642
106.58721330894
106.069995068662
105.400041479766
104.339205044175
102.328121619327
97.2690676678229
84.9259881155367
63.0881806804917
44.4625651432557
-49.6504183161946
-90.987252515145
-100.915967817471
-108.578424200889
-102.909084983377
-10.5025015777866

# Dynamic constraint 10 (y_dot - f = 0) multipliers : 
184.91998710324
182.817358694342
180.774256737238
178.931186232696
177.34725936902
176.041377256069
175.002828961829
174.204199660978
173.611226012897
173.188664510805
172.902120423284
172.718251905638
172.604833505248
172.531721982462
172.472886172246
172.408117011605
172.32140137479
172.19633525886
172.013583655477
171.74898620055
171.356958743182
170.745268604508
169.762293057191
168.170517771299
165.605579241064
161.641560208713
155.751133297617
146.340800606717
129.411086634029
101.079830416058
72.3215830804421
47.4137086992084
30.9506611214348
19.5065508794546
10.7024706387234
3.07859213911926
-4.43867583513473
-13.1128199599386
-24.5277409458108
-41.118677660886
-66.939388984798
-98.4853668907396
-129.429556321422
-142.887891244117
-154.192847450218
-160.336821681865
-165.341782489281
-170.858770822951
-176.684171001429
-182.405538490604

# Dynamic constraint 11 (y_dot - f = 0) multipliers : 
-183.612357263727
-181.186510739413
-177.701550945825
-174.111517377809
-170.770862679247
-167.817936197699
-165.248701412549
-163.004736245209
-161.025675712204
-159.267248844445
-157.701944971196
-156.314334717714
-155.096332119768
-154.043820902078
-153.154514832915
-152.426679450619
-151.85871792147
-151.449511360124
-151.198258594657
-151.103514720761
-151.164700648134
-151.384901054761
-151.768143344441
-152.3181470916
-153.048622765238
-153.972579568504
-155.074062626095
-156.315342086479
-157.542126848854
-158.582343409173
-159.686456504108
-160.819080630161
-162.117539983639
-163.417534222471
-164.612058029783
-165.617021066227
-166.442688628071
-167.117176093435
-167.598092624291
-167.719621311556
-167.400717995331
-167.776299039165
-168.003604930406
-168.827582794758
-172.8606457145
-176.625597151943
-179.858952874267
-182.875750036281
-185.222913815261
-183.75127412652

# Dynamic constraint 12 (y_dot - f = 0) multipliers : 
183.232714519338
180.89050838546
178.355933031823
175.797110258641
173.328110611011
171.029108287901
168.937161095823
167.054303570925
165.362889690359
163.838543805269
162.457823670855
161.201484757288
160.055116103673
159.008562237179
158.054970947497
157.189869865227
156.410417947351
155.714850882211
155.102091198416
154.571488365264
154.122654447856
153.755350436263
153.469396794848
153.264614112264
153.140748397475
153.097288315841
153.13326313063
153.247251189872
153.438053757996
153.706577084876
154.054275565678
154.479783590012
154.98064559063
155.552971521771
156.192164074644
156.892135643555
157.645180938586
158.441945118528
159.271319547353
160.121518788155
160.990142342145
161.920603602318
163.025489768616
164.370856839464
166.663588951714
169.927223359124
173.517913477311
177.154411976602
180.590010705972
183.273693447777

# Dynamic constraint 13 (y_dot - f = 0) multipliers : 
-184.974597938749
-184.66066758369
-183.840332385817
-182.529466841222
-180.886716764924
-179.154752471707
-177.442922542395
-175.808527709068
-174.287135104622
-172.897060178313
-171.642593855269
-170.518592729063
-169.515042473113
-168.620485450688
-167.82408261143
-167.116577674456
-166.490554913271
-165.940320601801
-165.461628961652
-165.051378028063
-164.707335466032
-164.427915898887
-164.21201161965
-164.058870205428
-163.968010343463
-163.939167924084
-163.972266433223
-164.067408061447
-164.224884418191
-164.445208211822
-164.72916972842
-165.077924319085
-165.493119037936
-165.977067158724
-166.532976732901
-167.165230270717
-167.879691622154
-168.683975620339
-169.587547956417
-170.601425045501
-171.737135616717
-173.004555814202
-174.40838454657
-175.943581961458
-177.591031668017
-179.314897294334
-181.058597925529
-182.711288262477
-184.039944434262
-184.932290666182

# Dynamic constraint 14 (y_dot - f = 0) multipliers : 
-98.8515554439623
-163.182766331388
-162.030270342777
-161.358967852151
-161.275425767652
-161.180991197193
-160.954403815652
-160.843804069703
-160.845337350032
-160.841632566987
-160.866805831237
-160.915145520427
-160.874551434245
-160.786288550666
-160.766906071154
-160.782471662415
-160.791107551057
-160.798275861624
-160.805327946161
-160.811949596563
-160.813110368436
-160.817652004225
-160.829059118772
-160.83220572526
-160.823583644583
-160.822179571957
-160.831177436069
-160.831124407971
-160.824316660341
-160.808011570907
-160.780413801481
-160.794116850268
-160.838251516992
-160.855217041155
-160.856605290387
-160.804945514474
-161.915814928533
-163.456165902468
-163.483251877008
-163.033882472198
-163.876381570899
-12.6850284489521
-85.0381339036767
-83.1075788591868
-75.5496819879233
-78.6020115701989
-94.271455586124
-114.910071469596
-130.067060524584
-139.151793092065

# Dynamic constraint 15 (y_dot - f = 0) multipliers : 
75.6186845888464
128.328696623059
119.982893950864
118.337335972018
116.954305621365
113.669788145748
111.827957114077
111.900505654879
111.875589907807
111.87349232383
111.710814018458
111.52366143781
111.666129651056
111.81687115716
111.804885935799
111.809244211413
111.818240419114
111.801992728464
111.788684112065
111.787469308168
111.805235046299
111.813411872773
111.778681787706
111.764978707712
111.771436670502
111.865080800359
112.004380749189
111.883735513768
111.886059820666
112.096589552511
111.992541751459
111.775868479912
111.782810777489
111.955633030031
112.028059503096
112.168393338205
116.03263665829
123.908675927013
130.6194559477
132.539298355814
133.056618159703
94.107909253222
10.0646622672837
25.9620264009831
26.8448440531697
24.5493326154543
22.3315329372755
21.1163078783256
21.1747675322906
23.2554377845709

# Dynamic constraint 16 (y_dot - f = 0) multipliers : 
-9.64712178377315
87.1283445201228
77.6214077470555
78.5744518385451
78.8855078522732
78.9835068843842
79.0134551312018
79.0243718386213
79.0278861613261
79.0287062881329
79.0282536105291
79.0272237681504
79.0278921227188
79.0285809081873
79.0289016596592
79.0290469487826
79.0291074057628
79.0292302539084
79.0291412391013
79.0290702807526
79.0290474545392
79.0286163278059
79.0294371846855
79.0289220908717
79.0289773990162
79.028509771864
79.0293287684398
79.0289947035065
79.028707599012
79.0294956771902
79.02896410692
79.0292338202169
79.0293496412176
79.0300223161026
79.031565960691
79.0345140144333
79.0381630604209
62.4840966980842
79.012596297661
77.9419414023133
78.7485395508521
54.986747146073
-93.8907428640003
-103.654530193569
-103.101655027029
-97.8816036940928
-91.7679180781294
-86.1690325678321
-81.4535545256365
-77.6273799514153

# Dynamic constraint 17 (y_dot - f = 0) multipliers : 
-186.172567560188
-186.443590390724
-186.388538326085
-186.298205935355
-186.236491906505
-186.202908415889
-186.186523873715
-186.179025519352
-186.175742117159
-186.174349414714
-186.173772240442
-186.173536091291
-186.173440486407
-186.173405683805
-186.173393813402
-186.173389875973
-186.173388556074
-186.173388211624
-186.17338831993
-186.173387749713
-186.173386694509
-186.173385597608
-186.17338604668
-186.173390744602
-186.173390439135
-186.173388754341
-186.173386129221
-186.173389127868
-186.17338821362
-186.173387096001
-186.173390034428
-186.173391011904
-186.173397599748
-186.173411754161
-186.173443699945
-186.173529542399
-186.173805078727
-186.174831938043
-186.17930478679
-186.189242534664
-186.209782485837
-186.247126966745
-186.289096103706
-186.247939609732
-186.218903791298
-186.22173089869
-186.254087258748
-186.298570638778
-186.269571671296
-185.864624110101

# Dynamic constraint 18 (y_dot - f = 0) multipliers : 
-186.039279910547
-186.27584267101
-186.278223316535
-186.239367938963
-186.208436298149
-186.190537302098
-186.181516035512
-186.177300394823
-186.175425449609
-186.174620507451
-186.174285799892
-186.174150818367
-186.174089708132
-186.174062027455
-186.174049864711
-186.174045038172
-186.174042810817
-186.174041194871
-186.174042070433
-186.174044180335
-186.174046646427
-186.174046512561
-186.174036763077
-186.174038470605
-186.174041828059
-186.174044119449
-186.174038238416
-186.174041582866
-186.174046136914
-186.174044238927
-186.174051220741
-186.174055990425
-186.174067481431
-186.174093262661
-186.174139434021
-186.174193742241
-186.174156851039
-186.173601924473
-186.171054954184
-186.166407566855
-186.157071787061
-186.139725051467
-186.11477816097
-186.084509930456
-186.071254455754
-186.078067493412
-186.105774476617
-186.151768411945
-186.180774331242
-186.030517840784

# Dynamic constraint 19 (y_dot - f = 0) multipliers : 
185.770597590475
186.100174194654
186.143000689116
186.127059700387
186.107831797024
186.095683279348
186.089429299272
186.086496591583
186.085196384448
186.084638802027
186.08440887178
186.084344194977
186.084341160909
186.084331429685
186.084321727755
186.084314062561
186.084309094997
186.084304837986
186.08430136821
186.084300764198
186.084301006198
186.084299970912
186.08430237099
186.084302298038
186.084301675109
186.084302323078
186.084307570226
186.084307531444
186.084306803859
186.084309884741
186.0843067318
186.084305054149
186.084304170335
186.084273457777
186.084136842898
186.083709386848
186.082562458097
186.083697249689
186.083635928552
186.078121383812
186.066905375877
186.047055681156
186.051139156707
186.076273323775
186.093223914791
186.105823996307
186.11539628075
186.105085585737
186.000246501279
185.56719298121

# Dynamic constraint 20 (y_dot - f = 0) multipliers : 
-186.001548044257
-186.159779758331
-186.197449733208
-186.195690131259
-186.187155491552
-186.180531012319
-186.176638113166
-186.174627427505
-186.173663842955
-186.173223653022
-186.173028425091
-186.172943302985
-186.172910751819
-186.172899583538
-186.172895834973
-186.172894602222
-186.172894220783
-186.172894357089
-186.172893753657
-186.172892635256
-186.172890932235
-186.172890759398
-186.172896107343
-186.172895019814
-186.172892735862
-186.172891292974
-186.172896913688
-186.172895074089
-186.172892362477
-186.172893603874
-186.172891488985
-186.172894791573
-186.172906312843
-186.172945524962
-186.173083937792
-186.173560535428
-186.175152348428
-186.180280897082
-186.195948386205
-186.229204294217
-186.295254974008
-186.404743399344
-186.487344713793
-186.374880852446
-186.273932027653
-186.22022829364
-186.192213964254
-186.16110114468
-186.082662614571
-185.886231209888

# Dynamic constraint 21 (y_dot - f = 0) multipliers : 
-142.492757584952
-132.862888404917
-124.189474798344
-115.375173345495
-106.551883726852
-98.2379394621006
-90.8618422512782
-84.5787209950862
-79.3585155507903
-75.1073802723626
-71.7574037325927
-69.2672809391414
-67.5501419610519
-66.4764225397513
-65.9362095220464
-65.8596556678134
-66.1869258074237
-66.8578536617911
-67.8236718649975
-69.0557553707399
-70.5521485520566
-72.3283388608163
-74.3826396294571
-76.6791618261644
-79.1533937610688
-81.7182917660697
-84.2665976305285
-86.6729132046894
-88.7959193396983
-90.4851103983035
-91.5901831197137
-91.9685052326263
-91.4962495391671
-90.0963778387395
-87.7867311996847
-84.717881177694
-81.1481184923516
-77.3626945942423
-73.6022841576612
-70.0188707937095
-66.6785556539722
-63.5785329137824
-60.6644950403677
-57.8476469912199
-55.0176442231726
-52.0382802113114
-48.7188429959609
-44.9623051198622
-40.981438383188
-35.7766573854882

# Dynamic constraint 22 (y_dot - f = 0) multipliers : 
32.9366117974423
39.4090657464739
46.595462938663
53.8911465745981
61.1592555957345
68.4415462678047
75.8370328876386
83.5274668104672
91.6234024240776
99.9750551595123
108.138958447598
115.576352984496
121.944666554325
127.172031457165
131.357008039126
134.664573491084
137.269522762141
139.326393174435
140.959313206077
142.263617088946
143.309803864212
144.148802415161
144.823241767897
145.373953454536
145.838858996852
146.251881077282
146.643891005655
147.042880582826
147.4722130248
147.948356780177
148.480778859426
149.075230189342
149.738680314853
150.481354218176
151.311829205601
152.228591126562
153.219153923748
154.267425500476
155.359544111328
156.48987763553
157.664050869394
158.904006550558
160.252868280598
161.775183545836
163.549562520148
165.646261814168
168.065350508892
170.438365630769
172.032216879193
175.055886802364

# Dynamic constraint 23 (y_dot - f = 0) multipliers : 
-68.0579042186347
-63.9956072778598
-60.7299604638512
-57.5508079136179
-54.0083546100511
-49.9719293310537
-45.395181971238
-40.396513384392
-35.3274166366931
-30.5482810536311
-26.1741801116964
-22.0778931787469
-18.1325804065414
-14.2836829722144
-10.4730780112826
-6.66484179715983
-2.89655665198737
0.799455072787366
4.41114888358557
7.91800259843746
11.2931246269559
14.5566522062639
17.7622023444968
20.943126636489
24.1355429885149
27.3926191948843
30.7258725478624
34.0511709454589
37.2369635407772
40.1781417516444
42.8223735545132
45.1721281422237
47.2807812941628
49.2362398064775
51.1358845738397
53.0659057494757
55.0943356145853
57.2748544293108
59.6516100095237
62.2612083957535
65.1314743184462
68.2829421201835
71.7366938240767
75.5303594506966
79.7397971602373
84.5027013068207
90.0478097452081
96.7719587946866
105.535703731028
116.747062783893

# Dynamic constraint 24 (y_dot - f = 0) multipliers : 
-181.812261165676
-177.341314501042
-171.962533354549
-166.362038126763
-161.378420283677
-157.145908692217
-153.480842335919
-150.154851068821
-147.003317425674
-143.937510587151
-140.925308764437
-137.959976987919
-135.02870755324
-132.115810354358
-129.216144363857
-126.33589770184
-123.492402542895
-120.716509208187
-118.047104254448
-115.524937395642
-113.187661953946
-111.069160637062
-109.20359027286
-107.625657686088
-106.36907494641
-105.464784703958
-104.937586981855
-104.803680915091
-105.072457812828
-105.747338802832
-106.825085638946
-108.297608831928
-110.155667206684
-112.390088564772
-114.987101596086
-117.919803855252
-121.144244970341
-124.603920168998
-128.237429102984
-131.988094723184
-135.813569676613
-139.69933260644
-143.678047545209
-147.856557394943
-152.444601701124
-157.749140339752
-164.050077137607
-171.104611208195
-177.619637059233
-183.521536256374

# Dynamic constraint 25 (y_dot - f = 0) multipliers : 
-183.589461567612
-178.486156245061
-173.125540120037
-167.512693391297
-162.217531219909
-157.552878941804
-153.512631947283
-149.942239428168
-146.704330828094
-143.742310390404
-141.074371522133
-138.751384887268
-136.808852239696
-135.252506692441
-134.07037148016
-133.245538207481
-132.756585843544
-132.574492515735
-132.66853574668
-133.01232425289
-133.587149191935
-134.377217466393
-135.362042670452
-136.517750183714
-137.818399311416
-139.237003456131
-140.750562213937
-142.345305329128
-144.014487399302
-145.754386474399
-147.562237000807
-149.432035448546
-151.348445775061
-153.284771697228
-155.210549728968
-157.105345247824
-158.963651255207
-160.789194369875
-162.593240658053
-164.393779107966
-166.219657266648
-168.108913952216
-170.100648522642
-172.224091853122
-174.484750936916
-176.842629398686
-179.168195470083
-181.286803976063
-183.011307296179
-183.442401544201

# Dynamic constraint 26 (y_dot - f = 0) multipliers : 
182.583010375461
180.38669369353
178.034680428368
175.698646818392
173.47349675971
171.411686973992
169.530903113659
167.824467659121
166.275198256333
164.865795364294
163.582219402604
162.412524731052
161.345963136333
160.374048612822
159.491033718376
158.693322494105
157.979144700142
157.348078043614
156.800049453328
156.334883278537
155.952548961365
155.653291442967
155.437282129325
155.304504390618
155.254824115961
155.287668656527
155.401771956794
155.595605724475
155.86804432691
156.218498777226
156.646694697252
157.152527933037
157.736038276728
158.397468181509
159.137447588745
159.957301510918
160.859449726412
161.847923932237
162.929030180127
164.112098794943
165.410175763146
166.840272920212
168.422474059908
170.176754374319
172.116188740624
174.235860231498
176.498745962502
178.820937011344
181.04583123459
182.840428974741

# Dynamic constraint 27 (y_dot - f = 0) multipliers : 
-184.907275111994
-184.091689957573
-182.789279443058
-181.108996782499
-179.31771576882
-177.53666823684
-175.828512372074
-174.23295771242
-172.771374091745
-171.449741397999
-170.263420797045
-169.202141131818
-168.253828035905
-167.406939484191
-166.651576312045
-165.979797220936
-165.385507005623
-164.864166133323
-164.412462935778
-164.02801620835
-163.709132775478
-163.454622427273
-163.26366318217
-163.135707206082
-163.070418351911
-163.067634233878
-163.127348082641
-163.2497079792
-163.435033365137
-163.683851020734
-163.996955052178
-164.37549777323
-164.82112038175
-165.336133151904
-165.923752664229
-166.588394990468
-167.336003099934
-168.174345914644
-169.113156209278
-170.163870890023
-171.338617085064
-172.6480192823
-174.097542984923
-175.682669253416
-177.384263445311
-179.166032458718
-180.97184807319
-182.698471466684
-184.100217343846
-185.067466001761

# Dynamic constraint 28 (y_dot - f = 0) multipliers : 
-44.6992040029612
-80.1169130132017
-158.0186950448
-157.907720899085
-157.910536686599
-157.917253602734
-157.921724938136
-157.921985841933
-157.921730826155
-157.922540225572
-157.922961765522
-157.926311263791
-157.929438253106
-157.926467268576
-157.926988245415
-157.930673061974
-157.927721165121
-157.927492836003
-157.933796335308
-157.935165463163
-157.932299771057
-157.932797745194
-157.934752493755
-157.935786197475
-157.935986331026
-157.936047198428
-157.936818559474
-157.938097619342
-157.939725998932
-157.944325115422
-157.94684520455
-157.943457728897
-157.943464396456
-157.945592029254
-157.943044521019
-157.92928921117
-157.915512699539
-157.935838689264
-157.962373596151
-157.958015228074
-157.953270761502
-157.955729734654
-157.95387956231
-157.935022441448
-161.187740810938
177.82261386869
177.865234348686
178.242700606089
178.833343964163
179.463487161019

# Dynamic constraint 29 (y_dot - f = 0) multipliers : 
168.968176724264
152.511584572627
-76.3264963720111
-48.5532079560339
-52.7569161576131
-52.2196745655799
-52.4006805180327
-52.2913090200763
-52.2364868294316
-52.2674165346901
-52.2409038255047
-52.2428076899828
-52.2490817261954
-52.2466699567643
-52.2375875200174
-52.2662596055678
-52.2465815798223
-52.2477194118984
-52.2546862565664
-52.2744811498456
-52.2441138764875
-52.2459347811494
-52.2539740565762
-52.2461894970069
-52.2442789388769
-52.2490042890388
-52.2472014549334
-52.2480395967916
-52.2458598204892
-52.240568618187
-52.2627861987393
-52.229769417594
-52.2602814893174
-52.2643644704646
-52.2000026597066
-52.3232153371016
-52.2077666980419
-52.2464192794224
-52.4228763025325
-52.2101649050019
-52.2910428337501
-52.3991177352672
-52.0675526986896
-52.2238536702159
-53.4147843311107
-45.8535962680251
-45.4363709821215
-45.082900537775
-44.2899203254449
-42.584639571973

# Dynamic constraint 30 (y_dot - f = 0) multipliers : 
119.711118148865
116.386882859284
88.3980566260269
89.2751450768915
89.5534818697539
89.6438992829036
89.6735425758145
89.6833348269247
89.6865565573872
89.6876459091989
89.6880175554554
89.688143170533
89.6881773543909
89.6881980537592
89.6882039709769
89.688209112473
89.6882089346487
89.6881936811435
89.6882341879318
89.6882034612597
89.6881840035232
89.6881723087322
89.6881631464712
89.6881642176624
89.6881658710453
89.6881576073381
89.6881411087449
89.6881247822991
89.6881128804522
89.6880973409023
89.6880846342461
89.6880867280568
89.6880541970311
89.6880397531201
89.6880404215948
89.6880665431777
89.6881510481962
89.6882616584464
89.6883877084461
89.688838532097
89.6899602332748
89.6932215943588
89.7024700781294
89.7286757272852
89.8035977462063
81.2889740048502
81.3372170836705
81.3862344690466
81.4661624726404
81.625560514063

# Dynamic constraint 31 (y_dot - f = 0) multipliers : 
-186.383400311308
-186.466458860392
-186.380358660098
-186.290268936752
-186.232109090831
-186.200832428289
-186.18560683076
-186.178649159182
-186.175606185175
-186.174316982826
-186.173783900421
-186.173567635691
-186.173481165033
-186.173447048969
-186.173433871295
-186.173428875554
-186.173426929881
-186.173426062709
-186.173426432879
-186.173427347319
-186.173427658029
-186.173427450818
-186.173427222507
-186.173427185169
-186.173427583056
-186.173427640679
-186.173427609277
-186.173427448534
-186.173427268865
-186.173427027363
-186.173426925956
-186.173427304015
-186.173428619356
-186.173431086246
-186.173437539496
-186.173455060092
-186.173501504089
-186.173622308462
-186.173934765919
-186.174733414254
-186.176732334262
-186.181593852872
-186.19294655437
-186.217764723527
-186.265736742986
-186.334037802435
-186.325810693779
-186.343154074693
-186.335667393434
-186.071508898241

# Dynamic constraint 32 (y_dot - f = 0) multipliers : 
-186.201473057468
-186.462078360236
-186.399951772084
-186.304486380681
-186.239775326636
-186.204643896549
-186.187552295402
-186.179770100592
-186.176384086199
-186.174958131722
-186.174372550035
-186.174136152816
-186.174042223541
-186.174004413216
-186.173989514032
-186.173983575125
-186.173982489965
-186.173981291112
-186.173976308148
-186.173974729264
-186.17397527015
-186.173975503717
-186.173975455615
-186.173975404728
-186.173975457672
-186.173975209214
-186.173975733074
-186.173976311581
-186.17397692377
-186.173977823447
-186.173977261509
-186.173974729024
-186.173974788039
-186.173975252109
-186.17397591558
-186.17397707373
-186.173980616886
-186.173989222535
-186.174003443589
-186.174024449653
-186.174067651323
-186.174130594791
-186.174187580218
-186.174223320037
-186.174671756295
-186.179257128628
-186.209464880047
-186.291786419171
-186.384076547036
-186.262846038838

# Dynamic constraint 33 (y_dot - f = 0) multipliers : 
185.746381759466
186.099170524329
186.153117655096
186.140852561266
186.122080942605
186.109810988772
186.103374279147
186.100341680195
186.099002811372
186.098436581925
186.098204319739
186.098111137233
186.098074492251
186.09806045677
186.098055073553
186.098053149511
186.098052300047
186.098051486826
186.098051728866
186.098051448725
186.09805134007
186.098051419995
186.098051568047
186.09805175916
186.098051850518
186.098051364076
186.098051136112
186.09805107095
186.098051114944
186.098051040686
186.098050893579
186.098051034281
186.098051593895
186.098053105828
186.098056349555
186.098063248473
186.098078127868
186.098111433038
186.098195332472
186.098408178263
186.098922117724
186.100133496726
186.102898017952
186.108928022908
186.12123422179
186.146021007356
186.184714361412
186.209871437668
186.113035675711
185.559006295028

# Dynamic constraint 34 (y_dot - f = 0) multipliers : 
-186.228573317876
-186.103566533555
-186.129896770677
-186.156458329793
-186.168312868419
-186.172246822097
-186.173192761403
-186.173258091323
-186.173149822461
-186.173052968308
-186.172994057958
-186.172963393967
-186.172948484817
-186.172941827621
-186.172939120728
-186.172937942826
-186.172937292787
-186.172936913478
-186.172937427469
-186.172937730572
-186.172937703445
-186.172937747962
-186.172937744104
-186.172937618657
-186.172937212307
-186.172937086362
-186.172936978131
-186.172937108653
-186.17293694716
-186.172936716752
-186.172936694972
-186.172936720463
-186.172934741271
-186.172928799128
-186.172911870825
-186.172864029578
-186.172730066061
-186.172352455018
-186.171290934511
-186.168302782618
-186.159886479093
-186.136198142214
-186.069561807018
-185.882253272762
-185.356262547384
-183.881015575431
-179.783594739638
-170.002746658336
-147.429055178858
-98.3389939996547

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
458.544660317028
455.303744654455
454.7158801409
454.485048689728
454.388748939327
454.344384911802
454.320731052241
454.305819576219
454.294967975099
454.286226813226
454.278689793684
454.271831009229
454.26528898586
454.258791440505
454.252121578813
454.24511968135
454.23769093321
454.229781640701
454.221394509701
454.212578167325
454.203424425529
454.194053489759
454.1846221579
454.175300610799
454.166268477505
454.157711116763
454.149803789168
454.142708768986
454.136549486046
454.13143461311
454.127421775791
454.124532537521
454.12274309219
454.121988251078
454.122172738884
454.123161169684
454.124805842034
454.126951662447
454.129439253662
454.132151780585
454.135018858205
454.138061518911
454.141320309888
454.144713079354
454.147440968849
454.146252256726
454.13045339049
454.067531016071
453.859768637466
453.23412361119

# z_L corresponding to control variable 1 : 
0.0122742672359209
0.0122742673296674
0.0122742673310203
0.0122742673320009
0.0122742673322989
0.0122742673322625
0.0122742673321401
0.0122742673320554
0.0122742673320571
0.0122742673321597
0.0122742673323558
0.0122742673326277
0.0122742673329509
0.0122742673332964
0.0122742673336336
0.0122742673339311
0.0122742673341582
0.012274267334288
0.0122742673342984
0.0122742673341724
0.0122742673338994
0.0122742673334778
0.0122742673329113
0.012274267332213
0.0122742673314035
0.0122742673305088
0.0122742673295613
0.0122742673285973
0.0122742673276569
0.0122742673267793
0.0122742673260045
0.0122742673253695
0.0122742673249067
0.0122742673246433
0.0122742673245975
0.0122742673247813
0.0122742673251966
0.0122742673258354
0.0122742673266822
0.0122742673277115
0.0122742673288924
0.0122742673301937
0.012274267331587
0.0122742673330703
0.0122742673347082
0.0122742673367459
0.0122742673398797
0.012274267345951
0.0122742673595926
0.0122742673930006

# z_L corresponding to control variable 2 : 
4839.89983293477
4832.86271549189
4831.30474995596
4830.67229655982
4830.42373659043
4830.32966974926
4830.29623955028
4830.28601609739
4830.28440175386
4830.28586374691
4830.28839068911
4830.2913313184
4830.29452625678
4830.2979911762
4830.30179551803
4830.30601959803
4830.31073068024
4830.31599877372
4830.32188045346
4830.32842414693
4830.3356726164
4830.34367246287
4830.35246895095
4830.36213065602
4830.37275921376
4830.38450453483
4830.39759154141
4830.41233227044
4830.42915014213
4830.44854663404
4830.47106310117
4830.4971344718
4830.52687253608
4830.55975646075
4830.59434100573
4830.62819464507
4830.65824491238
4830.68155956137
4830.69616176352
4830.70133477763
4830.69740553065
4830.68534968549
4830.6667815271
4830.64464373285
4830.6250285407
4830.62093362957
4830.65945519487
4830.79477320923
4831.1238864981
4831.83465424982

# z_L corresponding to control variable 3 : 
0.0122754560783507
0.01230266768781
0.0122851414395059
0.0122851414365555
0.0122851414365289
0.0122851414366062
0.012285141436683
0.0122851414366396
0.0122851414366092
0.0122851414366113
0.0122851414366042
0.0122851414365977
0.0122851414366216
0.0122851414366359
0.0122851414366163
0.0122851414366058
0.0122851414366079
0.0122851414366085
0.0122851414366085
0.0122851414366086
0.0122851414366101
0.0122851414366093
0.0122851414366072
0.0122851414366098
0.0122851414366132
0.0122851414366107
0.0122851414366074
0.0122851414366113
0.0122851414366127
0.012285141436615
0.0122851414366195
0.0122851414366071
0.0122851414365973
0.0122851414366049
0.0122851414366097
0.0122851414366254
0.012285141436265
0.0122851414405633
0.0123025856173005
0.0123024611323046
0.012301691935029
0.0123132802704258
0.0123116061959454
0.0122754615499582
0.0122754407670239
0.01227543641025
0.0122754358124372
0.0122754358778824
0.0122754364588127
0.0122754370766831

# z_L corresponding to control variable 4 : 
0.0122748582165209
0.0123025601545557
19.3314445963917
19.3314422180103
19.3314405873926
19.3314439326392
19.3314410151207
19.3314372766613
19.3314373477278
19.3314373067257
19.3314375822927
19.3314376062401
19.3314370655077
19.3314370953892
19.3314373399325
19.3314372748073
19.331437272491
19.3314373223095
19.3314373165532
19.3314372938036
19.3314372626968
19.3314372773381
19.3314373543658
19.3314373206057
19.3314372937829
19.3314371186132
19.3314370188897
19.3314375294486
19.331437299502
19.33143690552
19.33143752427
19.3314377045129
19.3314372404596
19.3314369458861
19.3314371570202
19.3314370788469
19.3314287416225
19.3314032476731
0.0123025971146053
0.0123024880993743
0.0123017170993505
0.0124109171293911
0.0122978566801795
0.0122749972790568
0.0122748913324434
0.012274889836659
0.0122748895962173
0.0122748893738298
0.0122748892588572
0.0122748894486455

# z_L corresponding to control variable 5 : 
0.086114943272743
0.293954633850196
19.235457273113
19.2354365274238
19.235438264437
19.2354368066781
19.2354387696887
19.2354408894339
19.2354407870767
19.2354408192788
19.2354406426108
19.2354406140664
19.2354409850745
19.2354410004452
19.2354408116907
19.2354408258938
19.235440832187
19.2354408041184
19.2354408079064
19.2354408214319
19.235440843209
19.2354408330815
19.2354407806918
19.2354408090281
19.2354408316519
19.2354409296786
19.2354409786104
19.2354406891464
19.2354408276401
19.2354410626088
19.2354407116552
19.2354405754929
19.2354408256527
19.2354410158663
19.2354409017935
19.2354409818032
19.2354450263813
19.2354920430535
0.289940567800062
0.269256054134621
0.189880990128194
0.138603877979967
0.0884365786340816
0.0865225324185909
0.0864770119431696
0.0864714919784463
0.0864727764171511
0.0864815551632304
0.0865143116985743
0.0866772107561771

# z_L corresponding to control variable 6 : 
0.0122758387143684
0.0122758592248242
0.0122845764081245
0.0122845764182811
0.0122845764193392
0.0122845764192444
0.0122845764192779
0.0122845764192747
0.0122845764192777
0.0122845764192804
0.012284576419279
0.0122845764192792
0.0122845764192793
0.0122845764192805
0.0122845764192795
0.0122845764192799
0.01228457641928
0.01228457641928
0.0122845764192786
0.0122845764192802
0.0122845764192797
0.0122845764192798
0.0122845764192797
0.0122845764192794
0.0122845764192798
0.01228457641928
0.0122845764192797
0.0122845764192796
0.0122845764192795
0.0122845764192787
0.0122845764192799
0.0122845764192797
0.0122845764192808
0.0122845764192795
0.0122845764192786
0.0122845764192866
0.0122845764192797
0.0122845764192763
0.0122845764192788
0.0122845764192745
0.0122845764192825
0.0122845764192803
0.0122845764192646
0.012284576419272
0.0122845764185261
0.0122845765209196
0.012275841570887
0.0122758418524149
0.0122758426788107
0.0122758453994945

# z_L corresponding to control variable 7 : 
0.0122750048472011
0.0122749826955183
21.0062758461283
21.0058971896416
21.0059567693925
21.0059475088808
21.0059488291228
21.0059482591986
21.0059483582644
21.0059485195098
21.0059484093051
21.0059484609245
21.0059484693962
21.0059484580903
21.0059484422173
21.0059485118581
21.0059484249525
21.0059484623894
21.0059484680576
21.005948496764
21.0059484044961
21.0059484631839
21.0059484738277
21.0059484442992
21.0059484562206
21.0059484690593
21.0059484559376
21.0059484605886
21.0059484544514
21.005948445982
21.005948500363
21.0059483998583
21.0059485183484
21.0059484660595
21.0059483394089
21.0059487072365
21.0059482517808
21.0059485164938
21.0059487740821
21.0059480587496
21.0059486214988
21.0059486727767
21.0059478551456
21.0059488430524
21.005948132052
21.0062751600775
0.0122750069892615
0.0122750070217098
0.0122750071343506
0.012275007579158

# z_L corresponding to control variable 8 : 
0.158947484327627
0.159640821019215
20.895194076108
20.8954184023417
20.8953830408881
20.8953888964399
20.8953882026965
20.895388580442
20.8953885319935
20.8953884378363
20.8953885055784
20.8953884730949
20.8953884682738
20.8953884789617
20.895388486269
20.8953884424996
20.8953884988557
20.8953884745901
20.8953884670904
20.8953884529765
20.895388511298
20.8953884738503
20.8953884665484
20.8953884847895
20.895388478083
20.8953884705271
20.8953884779786
20.8953884749411
20.8953884783048
20.8953884816329
20.8953884502358
20.8953885142461
20.8953884410813
20.8953884711664
20.8953885501605
20.8953883361718
20.895388609673
20.8953884295935
20.8953882713348
20.8953887205782
20.8953883836888
20.8953883511056
20.8953888518137
20.8953882880615
20.895386739853
20.8954580585156
0.159990659033102
0.160162068662248
0.160696485127876
0.162812031949755

# z_L corresponding to parameters : 
0.0874628100857352
0.0411541714329421
0.823338604240895
0.0493997140138937
0.754020589208366

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
0.0122746385602135
0.0122746396135893
0.0122746398022709
0.0122746398781726
0.0122746399115716
0.0122746399283511
0.0122746399382642
0.0122746399450704
0.0122746399502784
0.0122746399545476
0.0122746399582123
0.0122746399614785
0.0122746399644916
0.0122746399673599
0.0122746399701657
0.0122746399729677
0.0122746399758015
0.0122746399786862
0.0122746399816231
0.0122746399846001
0.0122746399875947
0.0122746399905758
0.0122746399935063
0.0122746399963464
0.0122746399990564
0.0122746400015977
0.0122746400039369
0.0122746400060456
0.0122746400079072
0.0122746400095107
0.0122746400108579
0.0122746400119602
0.0122746400128382
0.0122746400135199
0.0122746400140375
0.0122746400144251
0.0122746400147131
0.0122746400149253
0.0122746400150733
0.0122746400151426
0.0122746400150845
0.0122746400147854
0.0122746400140942
0.0122746400128424
0.0122746400110249
0.0122746400093247
0.0122746400106501
0.0122746400244804
0.0122746400802803
0.0122746402486

# z_U corresponding to control variable 1 : 
13934.7863948194
13946.4512363783
13950.2997436685
13951.7464050786
13952.3137286476
13952.552394089
13952.6644935951
13952.7237683697
13952.7564115725
13952.7717235608
13952.7733941269
13952.7638332099
13952.745548117
13952.7214002191
13952.6946496666
13952.6687296634
13952.6470167285
13952.6327295707
13952.6287133702
13952.6372698062
13952.6600539197
13952.6980298783
13952.751263818
13952.819058267
13952.8998795702
13952.9913710989
13953.0905099109
13953.1936340814
13953.2967452612
13953.3954368162
13953.4853044213
13953.5620334798
13953.6216655726
13953.6607736241
13953.6766096245
13953.667393277
13953.6322048881
13953.5710804404
13953.4850070806
13953.3758001045
13953.2461585039
13953.0998498716
13952.9417011893
13952.7783007781
13952.6191283888
13952.4804850382
13952.3966134357
13952.4572948362
13952.9190251158
13955.1022712903

# z_U corresponding to control variable 2 : 
0.0122743030080004
0.0122743031230521
0.0122743031422649
0.0122743031498995
0.0122743031528623
0.0122743031539763
0.0122743031543722
0.0122743031544955
0.0122743031545187
0.0122743031545072
0.0122743031544842
0.0122743031544571
0.0122743031544269
0.012274303154393
0.0122743031543536
0.0122743031543075
0.0122743031542532
0.0122743031541898
0.0122743031541164
0.0122743031540326
0.0122743031539383
0.0122743031538335
0.0122743031537183
0.0122743031535928
0.0122743031534568
0.0122743031533097
0.01227430315315
0.0122743031529752
0.0122743031527817
0.0122743031525647
0.0122743031523189
0.0122743031520397
0.012274303151726
0.0122743031513827
0.0122743031510246
0.0122743031506764
0.0122743031503698
0.0122743031501344
0.01227430314999
0.0122743031499427
0.0122743031499877
0.0122743031501141
0.0122743031503048
0.0122743031505325
0.0122743031507475
0.0122743031508595
0.0122743031507237
0.0122743031501774
0.012274303149358
0.0122743031493181

# z_U corresponding to control variable 3 : 
361.10469288219
5.47546558503375
19.2170917743806
19.2171028622618
19.217102999957
19.217102631602
19.2171024275083
19.2171026763998
19.2171027864253
19.2171027797724
19.2171027990612
19.2171028223019
19.217102747998
19.2171026949812
19.2171027609079
19.2171028010113
19.2171027934861
19.2171027902779
19.2171027901053
19.2171027904466
19.2171027855799
19.2171027883498
19.21710279468
19.2171027853151
19.2171027737962
19.2171027869725
19.2171028019002
19.2171027751416
19.2171027752036
19.2171027769835
19.2171027449486
19.2171027863582
19.2171028337584
19.2171028127954
19.2171027901423
19.2171027346111
19.2171042624981
19.2170891561153
5.49379043768766
5.52027621570468
5.68880444328243
3.91994890593005
4.04218804972456
359.142731565318
365.661993578931
366.657424124243
366.785816980942
366.775903302335
366.620230260323
366.431291126625

# z_U corresponding to control variable 4 : 
537.805783310359
5.50090225193687
0.0122851231487872
0.0122851231494892
0.0122851231499302
0.0122851231489952
0.0122851231498103
0.0122851231508536
0.0122851231508318
0.0122851231508433
0.0122851231507657
0.0122851231507586
0.0122851231509114
0.0122851231509039
0.0122851231508342
0.0122851231508519
0.0122851231508526
0.0122851231508387
0.0122851231508403
0.0122851231508467
0.0122851231508555
0.0122851231508513
0.0122851231508295
0.0122851231508392
0.0122851231508469
0.0122851231508958
0.0122851231509235
0.0122851231507808
0.0122851231508453
0.0122851231509556
0.0122851231507828
0.0122851231507315
0.0122851231508608
0.0122851231509438
0.012285123150885
0.0122851231509078
0.0122851231532167
0.0122851231602669
5.49142777943499
5.51424501711656
5.68275690514174
1.11554038502467
6.38142707389123
345.682385383007
482.319902262493
485.05098776872
485.464694907742
485.828227768279
486.060716095769
485.852653095898

# z_U corresponding to control variable 5 : 
0.0143144884130315
0.012809110731027
0.0122851384764306
0.0122851384826269
0.0122851384821287
0.0122851384824987
0.01228513848198
0.0122851384814184
0.012285138481445
0.0122851384814363
0.0122851384814829
0.0122851384814904
0.0122851384813923
0.0122851384813883
0.0122851384814382
0.0122851384814344
0.0122851384814327
0.0122851384814402
0.0122851384814392
0.0122851384814356
0.0122851384814298
0.0122851384814325
0.0122851384814464
0.0122851384814388
0.0122851384814329
0.0122851384814069
0.012285138481394
0.0122851384814706
0.0122851384814339
0.0122851384813718
0.0122851384814646
0.0122851384815007
0.0122851384814344
0.0122851384813841
0.0122851384814144
0.0122851384813933
0.012285138480326
0.012285138466817
0.0128168421550358
0.0128605103194131
0.013122499029481
0.0134667875390655
0.0142522954579143
0.0143032881925075
0.0143045329545307
0.0143046840024059
0.0143046488531203
0.0143044086510736
0.0143035128756719
0.0142990698769608

# z_U corresponding to control variable 6 : 
280.353424327076
277.689583315695
20.8743070414395
20.8742707060589
20.8742657800996
20.8742662502963
20.8742660994165
20.8742661171595
20.8742661037687
20.8742660915317
20.874266098259
20.8742660971959
20.8742660963075
20.8742660913743
20.8742660957251
20.8742660939333
20.8742660936294
20.8742660935409
20.8742660995696
20.874266092686
20.8742660952273
20.8742660942908
20.8742660949233
20.8742660960672
20.874266094392
20.8742660933804
20.8742660949437
20.874266095132
20.8742660958192
20.8742660992575
20.8742660934848
20.8742660949627
20.8742660898179
20.874266095517
20.8742661000686
20.8742660635468
20.8742660957933
20.8742661092246
20.8742660969468
20.8742661194433
20.8742660812202
20.874266090299
20.8742661614331
20.8742661211648
20.8742693615404
20.8738542387302
279.779516494972
279.724685731588
279.567921962505
279.065123179895

# z_U corresponding to control variable 7 : 
400.386356893907
425.15435441863
0.0122845589579251
0.0122845590547883
0.0122845590397226
0.0122845590420776
0.0122845590417409
0.0122845590418857
0.0122845590418604
0.0122845590418193
0.0122845590418473
0.0122845590418341
0.012284559041832
0.012284559041835
0.012284559041839
0.0122845590418212
0.0122845590418434
0.0122845590418338
0.0122845590418322
0.0122845590418251
0.0122845590418487
0.0122845590418336
0.0122845590418309
0.0122845590418384
0.0122845590418354
0.0122845590418321
0.0122845590418355
0.0122845590418343
0.0122845590418358
0.0122845590418379
0.0122845590418241
0.0122845590418498
0.0122845590418196
0.0122845590418329
0.0122845590418652
0.012284559041772
0.0122845590418878
0.0122845590418196
0.0122845590417539
0.0122845590419367
0.0122845590417935
0.0122845590417803
0.0122845590419886
0.0122845590417382
0.0122845590418349
0.0122845589628911
398.551446633094
398.605039045029
398.723100029146
398.920904837371

# z_U corresponding to control variable 8 : 
0.0133013585527601
0.0132965259538342
0.0122845736575306
0.0122845736030996
0.0122845736118471
0.0122845736103875
0.0122845736105607
0.0122845736104666
0.0122845736104787
0.0122845736105022
0.0122845736104853
0.0122845736104934
0.0122845736104946
0.012284573610492
0.0122845736104901
0.0122845736105011
0.012284573610487
0.0122845736104931
0.0122845736104949
0.0122845736104985
0.0122845736104839
0.0122845736104933
0.0122845736104951
0.0122845736104905
0.0122845736104922
0.0122845736104941
0.0122845736104922
0.012284573610493
0.0122845736104921
0.0122845736104913
0.0122845736104991
0.0122845736104832
0.0122845736105014
0.0122845736104939
0.0122845736104742
0.0122845736105276
0.0122845736104595
0.0122845736105042
0.0122845736105436
0.0122845736104318
0.0122845736105157
0.0122845736105238
0.012284573610399
0.0122845736105394
0.0122845736109145
0.0122845735935804
0.0132941047814428
0.0132929226643581
0.0132892546174251
0.0132749898535294

# z_U corresponding to parameters : 
0
0
0
0
0

# Cpu time : 
331.558

# Iterations : 
1000
