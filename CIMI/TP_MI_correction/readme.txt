#
Ecole CIMI-CON septembre 2018
TP sur les méthodes indirectes
Auteur 	: Olivier Cots
Date 	: 08/08/2018
#

# ——————————————————————————————————————————————————————————————————————————————————————————————————————— 
TP_1_tir_simple_pb_scalaire : introduction sur un problème scalaire en x

exo_1 : 

	dot_x = -x + u : tir simple + visualisation de la fonction de tir

exo_2_contraintes_sur_u :

	ajout d’une contrainte sur le contrôle + pb de convergence (converge quand même avec HamPath)


# ——————————————————————————————————————————————————————————————————————————————————————————————————————— 
TP_2_tir_simple_et_multiple_double_integrateur : double intégrateur

exo_1_energie_min : 
	
	énergie min : choix avec ou sans contraintes sur u

exo_2_temps_min : min du temps final avec contraintes sur u

	exo_2_1_tir_simple : tir simple
	exo_2_2_tir_multiple_de_structure : tir multiple (pas les conditions de raccordement)

# ——————————————————————————————————————————————————————————————————————————————————————————————————————— 
TP3_homotopie_regularisation_double_integrateur : double intégrateur : min L1 avec régularisation L^(2-lambda)

exo_3_1_regularisation : 

	régularisation : tir simple + homotopie. L’homotopie prend du temps. Ce serait plus efficace de faire du tir multiple quand on sature la contrainte sur le contrôle.

exo_3_2_min_L1 :

	min L1 : tir multiple sans les conditions de raccordement.

# ——————————————————————————————————————————————————————————————————————————————————————————————————————— 
TP4_transfert_orbital_temps_min