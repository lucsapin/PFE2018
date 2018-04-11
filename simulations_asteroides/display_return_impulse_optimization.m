% Script to display the results after optimization of the outbound 3 impulse manoeuver: from EMB to asteroid
%

function hFig = display_return_impulse_optimization(arg1, arg2)

if(nargin==2)

    numAsteroid = arg1;
    numOpti     = arg2;

    %
    repOutput = 'results/return_impulse_EMB/';
    if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end;

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')~=2)
        error(['there is no return optimization done for asteroid number ' int2str(numAsteroid)]);
    end;

    load(file2load);

else % On affiche une solution donnee en argument. On va chercher son numero dans la liste des optimisations

    outputOpti  = arg1;
    numAsteroid = outputOpti.numAsteroid;

    %
    repOutput = 'results/return_impulse_EMB/';
    if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end;

    file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
    if(exist([file2load '.mat'],'file')~=2)
        error(['there is no return optimization done for asteroid number ' int2str(numAsteroid)]);
    end;

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
        end;
    end;
    if(fini==0)
        error('Return solution not found in the BDD!');
    end;
    numOpti = i;

end;

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

%title(titre);

% Display trajectory
axes(hAxesTraj); hold on; 
axis vis3d;

% ----------------------------------------------------------------------------------------------------
% Display sun
position_sun = [0.0 0.0 0.0]; display_sun(position_sun);

% ----------------------------------------------------------------------------------------------------
% EMB's orbit and position
% ----------------------------------------------------------------------------------------------------
xOrb_epoch_t0_EMB       = get_EMB_init_Orbital_elements();  % Initial orbital elements
[orbit_EMB, period_EMB] = get_Orbit(xOrb_epoch_t0_EMB);

% Display EMB's orbit
plot3(orbit_EMB(1,:), orbit_EMB(2,:), orbit_EMB(3,:), 'Color', DC.color_EMB, 'LineWidth', DC.LW); hold on;

% Display initial EMB's position at epoch_t0
%initial_state_EMB = get_Current_State_Cart(xOrb_epoch_t0_EMB, UC.epoch_t0) ; display_EMB(hFigSpace, initial_state_EMB(1:3), 'epoch_t0');

% Display initial EMB's position at t0 + dt1
q0      = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0)             ; display_EMB(q0(1:3), 'return_t0');
%q1      = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0 + dt1)       ; display_EMB(q1(1:3), 'return_t0_dt1');
qf      = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0 + dt1 + dtf) ; display_EMB(qf(1:3), 'return_t0_dt1_dtf');

% ----------------------------------------------------------------------------------------------------
% Asteroid's orbit
% ----------------------------------------------------------------------------------------------------
[orbit_Ast, period_Ast] = get_Orbit(xOrb_epoch_t0_Ast);

% Display Asteroid's orbit
plot3(orbit_Ast(1,:), orbit_Ast(2,:), orbit_Ast(3,:), 'Color', DC.color_Ast, 'LineWidth', DC.LW); hold on;

% Display initial asteroid's position
%initial_state_Ast = get_Current_State_Cart(xOrb_epoch_t0_Ast, UC.epoch_t0) ; display_asteroid(initial_state_Ast(1:3), 'epoch_t0');

% Display initial EMB's position at t0 + dt1
q0      = get_Current_State_Cart(xOrb_epoch_t0_Ast, t0)             ; display_asteroid(q0(1:3), 'return_t0');
%q1      = get_Current_State_Cart(xOrb_epoch_t0_Ast, t0 + dt1)       ; display_asteroid(q1(1:3), 'return_t0_dt1');
qf      = get_Current_State_Cart(xOrb_epoch_t0_Ast, t0 + dt1 + dtf) ; display_asteroid(qf(1:3), 'return_t0_dt1_dtf');

% ----------------------------------------------------------------------------------------------------
% Spacefraft position and trajectory
% ----------------------------------------------------------------------------------------------------

% trajectory of the spacecraft
[times, states, q0, q1, qf] = get_Trajectory_SpaceCraft(xOrb_epoch_t0_Ast, t0, dt1, dtf, dV0, dV1, dVf);
display_Spacecraft(q0(1:3), 'return_t0');
display_Spacecraft(q1(1:3), 'return_t0_dt1');
display_Spacecraft(qf(1:3), 'return_t0_dt1_dtf');
display_Trajectory_Spacecraft(states, 'return');

% ----------------------------------------------------------------------------------------------------
% Affichage des données dans le terminal

fprintf([DC.tirets '\n']);
fprintf([titre '\n']);
fprintf('The delta_V are given in km/s.');
fprintf(['\n' DC.tirets '\n\n']);
tiretsFig = '';
for i=1:110;
    tiretsFig= [tiretsFig '\_'];
end;

outTerminal         = { int2str(outputOpti.numAsteroid)     , ...
                        outputOpti.poids                    , ...
                        outputOpti.dVmax/UC.jour*UC.AU      , ...
                        int2str(outputOpti.exitflag)        , ...
                        int2str(outputOpti.output.iterations), ...
                        outputOpti.output.constrviolation   , ...
                        outputOpti.output.firstorderopt};

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 'asteroid_number'   , ...
                                                'poids'             , ...
                                                'dVmax'             , ...
                                                'exitflag'          , ...
                                                'iterations'        , ...
                                                'constrviolation'   , ...
                                                'firstorderopt'     };

disp(outTerminal_cell);
TString = [titre sprintf('\n\n') 'The delta_V are given in km/s.' sprintf('\n\n') 'tiretsFig' sprintf('\n\n') evalc('disp(outTerminal_cell)')];

outTerminal         = [{ outputOpti.t0       , ...
                         outputOpti.dt1      , ...
                         outputOpti.dtf      , ...
                         norm(outputOpti.dV0(1:3))/UC.jour*UC.AU   , ...
                         norm(outputOpti.dV1(1:3))/UC.jour*UC.AU   , ...
                         norm(outputOpti.dVf(1:3))/UC.jour*UC.AU   , ...
                         (norm(outputOpti.dV0(1:3)) + norm(outputOpti.dV1(1:3)))/UC.jour*UC.AU   } ];

%outTerminal         = [{ outputOpti.t0       , ...
%                         outputOpti.dt1      , ...
%                         outputOpti.dtf      , ...
%                         outputOpti.dV0(1)/UC.jour*UC.AU   , ...
%                         outputOpti.dV1(1)/UC.jour*UC.AU   , ...
%                         outputOpti.dVf(1)/UC.jour*UC.AU   }; ...
%                        { ''                  , ...
%                          ''                  , ...
%                          ''                  , ...
%                         outputOpti.dV0(2)/UC.jour*UC.AU   , ...
%                         outputOpti.dV1(2)/UC.jour*UC.AU   , ...
%                         outputOpti.dVf(2)/UC.jour*UC.AU   }; ...
%                        { ''                  , ...
%                          ''                  , ...
%                          ''                  , ...
%                         outputOpti.dV0(3)/UC.jour*UC.AU   , ...
%                         outputOpti.dV1(3)/UC.jour*UC.AU   , ...
%                         outputOpti.dVf(3)/UC.jour*UC.AU   }; ];

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 't0_r'      , ...
                                                'dt1_r'     , ...
                                                'dtf_r'     , ...
                                                'norm_dV0_r'     , ...
                                                'norm_dV1_r'     , ...
                                                'norm_dVf_r'     , ...
                                                'norm_dV01_r'    };

disp(outTerminal_cell);
TString = [TString 'tiretsFig' sprintf('\n\n') evalc('disp(outTerminal_cell)')];

% dates
date_epoch_t0       = UC.date_epoch_t0;
sec_t0              = seconds(outputOpti.t0*UC.jour);
sec_dt1             = seconds(outputOpti.dt1*UC.jour);
sec_dtf             = seconds(outputOpti.dtf*UC.jour);
day_duration        = days(outputOpti.dt1+outputOpti.dtf);

outTerminal         = { date_epoch_t0+sec_t0                    , ...
                        date_epoch_t0+sec_t0+sec_dt1            , ...
                        date_epoch_t0+sec_t0+sec_dt1+sec_dtf    , ...
                        day_duration                            , ...
                        delta_V/UC.jour*UC.AU                   };

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 'Start_date'        , ...
                                                'Manoeuver_date'    , ...
                                                'End_date'          , ...
                                                'Duration'          , ...
                                                'dV_consumption'    };

disp(outTerminal_cell)
TString = [TString 'tiretsFig' sprintf('\n\n') evalc('disp(outTerminal_cell)')];

% Get the table in string form.
% Use TeX Markup for bold formatting and underscores.
TString = strrep(TString,'<strong>','\bf');
TString = strrep(TString,'</strong>','\rm');
TString = strrep(TString,'_','\_');
TString = strrep(TString,'\_\_','');
TString = strrep(TString,'\bf\rm','');
TString = strrep(TString,'\bf','');
TString = strrep(TString,'\rm','');
TString = ['\bf' TString];
TString = strrep(TString, 'tiretsFig', tiretsFig);

% Get a fixed-width font.
FixedWidth = get(0,'FixedWidthFontName');

% Output the table using the annotation command.
px  = px+lx+0.02;
py  = 0.4;
lx  = 1.0-(px+0.05);
ly  = 0.5;
annotation(hFig,'Textbox','fontsize',11,'String',TString,'Interpreter','Tex', 'Color', [0 0 0],...
    'FontName',FixedWidth,'Units','Normalized','Position',[px py lx ly],'BackgroundColor', 0.99*[1.0 1.0 1.0]);

