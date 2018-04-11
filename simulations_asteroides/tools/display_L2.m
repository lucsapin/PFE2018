function display_L2(position_L2, etat)

UC      = get_Univers_Constants();
DC      = get_Display_Constants();

[X,Y,Z] = sphere;

if strcmp(etat, 'epoch_t0')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_L2(1)+X,position_L2(2)+Y,position_L2(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.blanc);
elseif strcmp(etat, 'current')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_L2(1)+X,position_L2(2)+Y,position_L2(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_L2);
elseif strcmp(etat, 'outbound_t0')
    ratio   = 1;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_L2(1)+X,position_L2(2)+Y,position_L2(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_L2);
elseif strcmp(etat, 'outbound_t0_dt1')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_L2(1)+X,position_L2(2)+Y,position_L2(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_L2);
elseif strcmp(etat, 'outbound_t0_dt1_dtf')
    ratio   = 3;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_L2(1)+X,position_L2(2)+Y,position_L2(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_L2);
elseif strcmp(etat, 'return_t0')
    ratio   = 1;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_L2(1)+X,position_L2(2)+Y,position_L2(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_L2);
elseif strcmp(etat, 'return_t0_dt1')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_L2(1)+X,position_L2(2)+Y,position_L2(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_L2);
elseif strcmp(etat, 'return_t0_dt1_dtf')
    ratio   = 3;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_L2(1)+X,position_L2(2)+Y,position_L2(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_L2);
else
    error('Wrong argument to display the L2 point');
end

return
