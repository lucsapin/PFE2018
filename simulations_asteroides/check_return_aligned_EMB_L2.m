% displaying checking if L2, Earth, Moon and EMB are aligned in EMB
% rotating frame
function hFig = check_return_aligned_EMB_L2(arg1, arg2)

if(nargin==2)

    numAsteroid = arg1;
    numOpti     = arg2;

    %
    repOutput = 'results/return_impulse_L2/';
    if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')~=2)
        error(['there is no return optimization done for asteroid number ' int2str(numAsteroid)]);
    end

    load(file2load);

else % On affiche une solution donnee en argument. On va chercher son numero dans la liste des optimisations

    outputOpti  = arg1;
    numAsteroid = outputOpti.numAsteroid;

    %
    repOutput = 'results/return_impulse_L2/';
    if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')~=2)
        error(['there is no return optimization done for asteroid number ' int2str(numAsteroid)]);
    end

    load(file2load);

    nbOpti      = length(allResults);
    fini        = 0; % on cherche le numero de la solution que l'on veut afficher
    i           = 1;
    while(fini==0 && i<=nbOpti)
        oo = allResults{i}; i = i + 1;
        erreur = norm(oo.Xsol-outputOpti.Xsol) + norm(oo.X0-outputOpti.X0) + ...
                 norm(oo.poids-outputOpti.poids) + norm(oo.dVmax-outputOpti.dVmax) + norm(oo.ratio-outputOpti.ratio);
        if(erreur < 1e-10)
            fini = 1;
            i    = i - 1;
        end
    end
    if(fini==0)
        error('Return solution not found in the BDD!');
    end
    numOpti = i;

end

% ----------------------------------------------------------------------------------------------------
DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants

% ----------------------------------------------------------------------------------------------------
nbOpti      = length(allResults);
outputOpti  = allResults{numOpti};
poids       = outputOpti.poids;
t0          = outputOpti.t0;
dt1         = outputOpti.dt1;
dtf         = outputOpti.dtf;
dV0         = outputOpti.dV0;
dV1         = outputOpti.dV1;
dVf         = outputOpti.dVf;
Fsol        = outputOpti.Fsol;
xOrb_epoch_t0_Ast = outputOpti.xOrb_epoch_t0_Ast;
delta_V     = outputOpti.delta_V;

duration    = dt1 + dtf;
return_time = t0 + dt1 + dtf;

% ----------------------------------------------------------------------------------------------------
% Figure for the space
titre = ['Return -- Asteroid no ' int2str(numAsteroid) ' -- Optimization no ' int2str(numOpti) '/' int2str(nbOpti)];

hFig = figure(  'units', 'normalized', 'Visible','on',...
                'color',[0.2745 0.5098 0.7059],...
                'numbertitle','off',...
                'name','Return');

%
px = 0.0;
py = 0.25;
lx = 0.35;
ly = 0.5;
hAxesTraj = axes('Parent', hFig, 'units','normalized',...
                'position',[px py lx ly],...
                'visible','on','XGrid','off','YGrid','off','XColor',0.0*[1 1 1],'YColor',0.0*[1 1 1],'DefaultAxesColor', DC.color_Space);

% title(titre);

% Display trajectory
axes(hAxesTraj); hold on; 
axis vis3d;

% Display EMB
position_EMB = [0.0 0.0 0.0]; display_EMB(position_EMB, 'return_t0');

% ----------------------------------------------------------------------------------------------------
% L2's, Moon's and Earth's positions
% ----------------------------------------------------------------------------------------------------

% Display initial L2's position at t0 and t0+dt1+dtf
disp('display t0');
[q_t0_Moon_EMB_LD, ~, q_t0_L2_EMB_LD] = get_Moon_Earth_L2_State_Cart_LD(t0);
display_L2(q_t0_L2_EMB_LD(1:3), 'return_t0');
display_Moon2(q_t0_Moon_EMB_LD(1:3), 'return_t0');

disp('display t0+dt1+dtf');
[q_tf_Moon_EMB_LD, ~, q_tf_L2_EMB_LD] = get_Moon_Earth_L2_State_Cart_LD(t0+dt1+dtf);
display_L2(q_tf_L2_EMB_LD(1:3), 'return_t0_dt1_dtf');
display_Moon2(q_tf_Moon_EMB_LD(1:3), 'return_t0_dt1_dtf');

return