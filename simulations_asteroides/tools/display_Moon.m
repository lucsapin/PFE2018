function display_Moon()
% In CR3BP frame

UC      = get_Univers_Constants();
DC      = get_Display_Constants();

muCR3BP = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);

position_CR3BP = [1.0-muCR3BP; 0.0; 0.0];

[X,Y,Z] = sphere(100);

Moon_radius = 1737.0/UC.LD;

ratio   = 2; % not scaled if ne 1
X       = Moon_radius*X*(ratio);
Y       = Moon_radius*Y*(ratio);
Z       = Moon_radius*Z*(ratio);
s       = surf(position_CR3BP(1)+X,position_CR3BP(2)+Y,position_CR3BP(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.gris);

return
