function display_Earth()
% In CR3BP frame

UC      = get_Univers_Constants();
DC      = get_Display_Constants();

muCR3BP = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);

position_CR3BP = [-muCR3BP; 0.0; 0.0];

[X,Y,Z] = sphere(100);

Earth_radius = 6371.0/UC.LD;

ratio   = 0.25;
X       = Earth_radius*X/(ratio);
Y       = Earth_radius*Y/(ratio);
Z       = Earth_radius*Z/(1000);
s       = surf(position_CR3BP(1)+X,position_CR3BP(2)+Y,position_CR3BP(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.bleu);

return
