function display_L2()
% In CR3BP frame

UC      = get_Univers_Constants();
DC      = get_Display_Constants();

muCR3BP = UC.xL2;

position_CR3BP = [muCR3BP; 0.0; 0.0];

[X,Y,Z] = sphere(100);

L2_radius = 6371.0/UC.LD;

ratio   = 0.5;
X       = L2_radius*X/(ratio);
Y       = L2_radius*Y/(ratio);
Z       = L2_radius*Z/(1000);
s       = surf(position_CR3BP(1)+X,position_CR3BP(2)+Y,position_CR3BP(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_L2);

return
