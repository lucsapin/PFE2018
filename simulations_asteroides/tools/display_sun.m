function display_sun(position_sun)

ax      = gca;
props   = {'DataAspectRatio','PlotBoxAspectRatio'}; values = get(ax,props);
DAR     = values{1};
dx      = DAR(1);
dy      = DAR(2);
dz      = DAR(3);
PBAR    = values{2};
px      = PBAR(1);
py      = PBAR(2);
pz      = PBAR(3);

UC      = get_Univers_Constants();
DC      = get_Display_Constants();

[X,Y,Z] = sphere(100);
X       = X*UC.radiusSunAU10*dx/(dx);
Y       = Y*UC.radiusSunAU10*dy/(dx);
Z       = Z*UC.radiusSunAU10*dz/(dx);
s       = surf(position_sun(1)+X,position_sun(2)+Y,position_sun(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_Sun);

return
