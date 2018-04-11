function DC = get_Display_Constants()

% Display constants

% Colors
DC.blanc    = [1.0 1.0 1.0]*0.9;
DC.rouge    = [0.8 0.1 0.1];
DC.bleu     = [0.1 0.1 0.8];
DC.vert     = [0.2 0.7 0.2];
DC.noir     = [0.0 0.0 0.0];
DC.gris     = 0.5+[0.0 0.0 0.0];
DC.color_Space = [1.0 1.0 1.0]*0.1;
DC.jaune    = [255 235 50]/255;
DC.magenta = [1 0 1];
DC.cyan = [0 1 1];

% Thickness of lines size of markers
DC.LW       = 2;
DC.MS       = 5;

% Colors of objects
DC.color_EMB = DC.rouge;
DC.color_Ast = DC.bleu;
DC.color_Sun = DC.jaune;
DC.color_SC  = DC.vert;
DC.color_L2  = DC.noir;
DC.color_Earth = DC.cyan;
DC.color_Moon = DC.gris;

%
DC.tirets='----------------------------------------------------------------------------------------------------';

return
