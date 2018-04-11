function display_Moon2(position_Moon, etat)

UC      = get_Univers_Constants();
DC      = get_Display_Constants();

[X,Y,Z] = sphere;

if strcmp(etat, 'epoch_t0')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_Moon(1)+X,position_Moon(2)+Y,position_Moon(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.blanc);
elseif strcmp(etat, 'current')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_Moon(1)+X,position_Moon(2)+Y,position_Moon(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_Moon);
elseif strcmp(etat, 'outbound_t0')
    ratio   = 1;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_Moon(1)+X,position_Moon(2)+Y,position_Moon(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_Moon);
elseif strcmp(etat, 'outbound_t0_dt1')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_Moon(1)+X,position_Moon(2)+Y,position_Moon(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_Moon);
elseif strcmp(etat, 'outbound_t0_dt1_dtf')
    ratio   = 3;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_Moon(1)+X,position_Moon(2)+Y,position_Moon(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_Moon);
elseif strcmp(etat, 'return_t0')
    ratio   = 1;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_Moon(1)+X,position_Moon(2)+Y,position_Moon(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_Moon);
elseif strcmp(etat, 'return_t0_dt1')
    ratio   = 2;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_Moon(1)+X,position_Moon(2)+Y,position_Moon(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_Moon);
elseif strcmp(etat, 'return_t0_dt1_dtf')
    ratio   = 3;
    X       = X*UC.radiusSunAU10/ratio; % On utilise le rayon du soleil pour harmoniser les tailles mais ce n'est pas à l'échelle
    Y       = Y*UC.radiusSunAU10/ratio;
    Z       = Z*UC.radiusSunAU10/ratio;
    surf(position_Moon(1)+X,position_Moon(2)+Y,position_Moon(3)+Z, 'EdgeColor', 'none', 'FaceColor', DC.color_Moon);
else
    error('Wrong argument to display the asteroid');
end

return
