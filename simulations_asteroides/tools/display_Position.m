function display_Position(q, color)
% In CR3BP frame

UC      = get_Univers_Constants();
DC      = get_Display_Constants();

muCR3BP = UC.mu0MoonLD/(UC.mu0EarthLD+UC.mu0MoonLD);

position_CR3BP = [muCR3BP; 0.0; 0.0];

[X,Y,Z] = sphere(100);

Earth_radius = 6371.0/UC.LD;

ratio   = 2.0; %
X       = Earth_radius*X*(ratio);
Y       = Earth_radius*Y*(ratio);
Z       = Earth_radius*Z*(ratio);
s       = surf(q(1)+X,q(2)+Y,q(3)+Z, 'EdgeColor', 'none', 'FaceColor', color);

return
