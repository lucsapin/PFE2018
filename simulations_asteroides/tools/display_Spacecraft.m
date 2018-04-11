function display_Spacecraft(position_SC, etat)

UC      = get_Univers_Constants();
DC      = get_Display_Constants();

[X,Y,Z] = sphere;

if strcmp(etat, 'outbound_t0')
    ratio   = 1;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_SC(1)+X,position_SC(2)+Y,position_SC(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_SC);
elseif  strcmp(etat, 'outbound_t0_dt1')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_SC(1)+X,position_SC(2)+Y,position_SC(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_SC);
elseif  strcmp(etat, 'outbound_t0_dt1_dtf')
    ratio   = 3;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_SC(1)+X,position_SC(2)+Y,position_SC(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_SC);
elseif strcmp(etat, 'return_t0')
    ratio   = 1;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_SC(1)+X,position_SC(2)+Y,position_SC(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_SC);
elseif  strcmp(etat, 'return_t0_dt1')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_SC(1)+X,position_SC(2)+Y,position_SC(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_SC);
elseif  strcmp(etat, 'return_t0_dt1_dtf')
    ratio   = 3;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_SC(1)+X,position_SC(2)+Y,position_SC(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_SC);
else
    error('Wrong argument to display the asteroid');
end

return
