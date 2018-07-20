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
# state.dimension integer 30
# control.dimension integer 9
# algebraic.dimension integer 0
# parameter.dimension integer 5
# constant.dimension integer 20
# boundarycond.dimension integer 36
# constraint.dimension integer 3
# # #
# # Discretization :
# discretization.steps integer 100
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
# state.6 string q21
# state.7 string q22
# state.8 string q23
# state.9 string q24
# state.10 string q25
# state.11 string q26
# state.12 string q31
# state.13 string q32
# state.14 string q33
# state.15 string q34
# state.16 string q35
# state.17 string q36
# state.18 string q41
# state.19 string q42
# state.20 string q43
# state.21 string q44
# state.22 string q45
# state.23 string q46
# state.24 string q51
# state.25 string q52
# state.26 string q53
# state.27 string q54
# state.28 string q55
# state.29 string q56
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
# boundarycond.6 string q21i-q11f
# boundarycond.7 string q22i-q12f
# boundarycond.8 string q23i-q13f
# boundarycond.9 string q24i-q14f
# boundarycond.10 string q25i-q15f
# boundarycond.11 string q26i-q16f
# boundarycond.12 string q31i-q21f
# boundarycond.13 string q32i-q22f
# boundarycond.14 string q33i-q23f
# boundarycond.15 string q34i-q24f
# boundarycond.16 string q35i-q25f
# boundarycond.17 string q36i-q26f
# boundarycond.18 string q41i-q31f
# boundarycond.19 string q42i-q32f
# boundarycond.20 string q43i-q33f
# boundarycond.21 string q44f-q34f
# boundarycond.22 string q45i-q35f
# boundarycond.23 string q46i-q36f
# boundarycond.24 string q51i-q41f
# boundarycond.25 string q52i-q42f
# boundarycond.26 string q53i-q43f
# boundarycond.27 string q54i-q44f
# boundarycond.28 string q55i-q45f
# boundarycond.29 string q56i-q46f
# boundarycond.30 string qL21-q51f
# boundarycond.31 string qL22-q52f
# boundarycond.32 string qL23-q53f
# boundarycond.33 string qL24-q54f
# boundarycond.34 string qL25-q55f
# boundarycond.35 string qL26-q56f
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
# 36 30 9 0 5 3
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
# 60000
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
# 2.296701
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
# -0.912085
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
# 0.000693
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
# -2.380669
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
# -0.248788
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
# -0.001371
# # #
# ********************** 
# ** init/state.6.init
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
# 2.296701
# # #
# ********************** 
# ** init/state.7.init
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
# 2.296701
# # #
# ********************** 
# ** init/state.8.init
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
# -0.912085
# # #
# ********************** 
# ** init/state.9.init
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
# 0.000693
# # #
# ********************** 
# ** init/state.10.init
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
# -2.380669
# # #
# ********************** 
# ** init/state.11.init
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
# -0.248788
# # #
# ********************** 
# ** init/state.12.init
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
# -0.001371
# # #
# ********************** 
# ** init/state.13.init
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
# -0.912085
# # #
# ********************** 
# ** init/state.14.init
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
# 2.296701
# # #
# ********************** 
# ** init/state.15.init
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
# -0.912085
# # #
# ********************** 
# ** init/state.16.init
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
# 0.000693
# # #
# ********************** 
# ** init/state.17.init
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
# -2.380669
# # #
# ********************** 
# ** init/state.18.init
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
# -0.248788
# # #
# ********************** 
# ** init/state.19.init
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
# -0.001371
# # #
# ********************** 
# ** init/state.20.init
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
# 0.000693
# # #
# ********************** 
# ** init/state.21.init
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
# 2.296701
# # #
# ********************** 
# ** init/state.22.init
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
# -0.912085
# # #
# ********************** 
# ** init/state.23.init
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
# 0.000693
# # #
# ********************** 
# ** init/state.24.init
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
# -2.380669
# # #
# ********************** 
# ** init/state.25.init
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
# -0.248788
# # #
# ********************** 
# ** init/state.26.init
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
# -0.001371
# # #
# ********************** 
# ** init/state.27.init
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
# -2.380669
# # #
# ********************** 
# ** init/state.28.init
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
# 2.296701
# # #
# ********************** 
# ** init/state.29.init
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
# -0.912085
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
# 0.120098
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
# -0.049211
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
# 0.001328
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
# -0.166791
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
# -0.96718
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
# 0.000483
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
# -0.34961
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
# -2.027301
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
# 0.001012
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
# 0.1
# 0.1
# 0.1
# 0.1
# 0.1
# # #
# discretization.stages integer 1
# discretization.steps.after.merge 100
# # #
# # #
# **************************** 
# **************************** 
# *****     SOLUTION     ***** 
# **************************** 
# **************************** 
# # #
# Objective value : 
0
