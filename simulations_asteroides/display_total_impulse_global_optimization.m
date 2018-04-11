% Script to display the results after optimization of the outbound 3 impulse manoeuver: from EMB to asteroid
%

function display_total_impulse_global_optimization(numAsteroid, numOpti)

%
repOutput = 'results/total_impulse_global/';
if(~exist(repOutput,'dir')); error('Wrong result directory name!'); end;

file2load = [repOutput 'asteroid_no_' int2str(numAsteroid)];
if(exist([file2load '.mat'],'file')~=2)
    error(['there is no optimization done for asteroid number ' int2str(numAsteroid)]);
end;

% ----------------------------------------------------------------------------------------------------
DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants

% ----------------------------------------------------------------------------------------------------
load(file2load);

nbOpti              = length(allResults);
outputOptimization  = allResults{numOpti};


xOrb_epoch_t0_Ast   =   outputOptimization.xOrb_epoch_t0_Ast;
numAsteroid         =   outputOptimization.numAsteroid ;
dVmax               =   outputOptimization.dVmax       ;
ratio               =   outputOptimization.ratio       ;
LB                  =   outputOptimization.LB          ;
UB                  =   outputOptimization.UB          ;
X0                  =   outputOptimization.X0          ;
Xsol                =   outputOptimization.Xsol        ;
t0_o                =   outputOptimization.t0_o        ;
dt1_o               =   outputOptimization.dt1_o       ;
dtf_o               =   outputOptimization.dtf_o       ;
t0_r                =   outputOptimization.t0_r        ;
dt1_r               =   outputOptimization.dt1_r       ;
dtf_r               =   outputOptimization.dtf_r       ;
dV0_o               =   outputOptimization.dV0_o       ;
dV1_o               =   outputOptimization.dV1_o       ;
dV0_r               =   outputOptimization.dV0_r       ;
dV1_r               =   outputOptimization.dV1_r       ;
dVf_o               =   outputOptimization.dVf_o       ;
dVf_r               =   outputOptimization.dVf_r       ;
delta_V             =   outputOptimization.delta_V     ;
delta_V_o           =   outputOptimization.delta_V_o   ;
delta_V_r           =   outputOptimization.delta_V_r   ;
Fsol                =   outputOptimization.Fsol        ;
exitflag            =   outputOptimization.exitflag    ;
output              =   outputOptimization.output      ;

duration_o          = dt1_o + dtf_o;
duration_r          = dt1_r + dtf_r;
tf_o                = t0_o + dt1_o + dtf_r;
tf_r                = t0_r + dt1_r + dtf_r;

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
% Figures
% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------

% ----------------------------------------------------------------------------------------------------
titre_o = ['Outbound -- Asteroid no ' int2str(numAsteroid) ' -- Optimization no ' int2str(numOpti) '/' int2str(nbOpti)];

hFigSpace_o = figure(  'units', 'normalized', 'Visible','on',...
                'color',[0.2745 0.5098 0.7059],...
                'numbertitle','off',...
                'name','Outbound');

%
px = 0.0;
py = 0.25;
lx = 0.35;
ly = 0.5;
hAxesTraj = axes('Parent', hFigSpace_o, 'units','normalized',...
                'position',[px py lx ly],...
                'visible','on','XGrid','off','YGrid','off','XColor',0.0*[1 1 1],'YColor',0.0*[1 1 1],'DefaultAxesColor', DC.color_Space);

%title(titre);

% Display trajectory
axes(hAxesTraj); hold on; 
axis vis3d;

% ----------------------------------------------------------------------------------------------------
titre_r = ['Return -- Asteroid no ' int2str(numAsteroid) ' -- Optimization no ' int2str(numOpti) '/' int2str(nbOpti)];

hFigSpace_r = figure(  'units', 'normalized', 'Visible','on',...
                'color',[0.2745 0.5098 0.7059],...
                'numbertitle','off',...
                'name','Return');

%
px = 0.0;
py = 0.25;
lx = 0.35;
ly = 0.5;
hAxesTraj = axes('Parent', hFigSpace_r, 'units','normalized',...
                'position',[px py lx ly],...
                'visible','on','XGrid','off','YGrid','off','XColor',0.0*[1 1 1],'YColor',0.0*[1 1 1],'DefaultAxesColor', DC.color_Space);

pxFig = px;
lxFig = lx;
%title(titre);

% Display trajectory
axes(hAxesTraj); hold on; 
axis vis3d;

% ----------------------------------------------------------------------------------------------------
titre = ['Outbound-Return (global optimization) -- Asteroid no ' int2str(numAsteroid) ' -- Optimization no ' int2str(numOpti) '/' int2str(nbOpti)];

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% Outbound
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
figure(hFigSpace_o)

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

% Display initial EMB's position at t0 + dt1
q0      = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0_o); display_EMB(q0(1:3), 'outbound_t0');
qf      = get_Current_State_Cart(xOrb_epoch_t0_EMB, tf_o); display_EMB(qf(1:3), 'outbound_t0_dt1_dtf');

% ----------------------------------------------------------------------------------------------------
% Asteroid's orbit
% ----------------------------------------------------------------------------------------------------
[orbit_Ast, period_Ast] = get_Orbit(xOrb_epoch_t0_Ast);

% Display Asteroid's orbit
plot3(orbit_Ast(1,:), orbit_Ast(2,:), orbit_Ast(3,:), 'Color', DC.color_Ast, 'LineWidth', DC.LW); hold on;

% Display initial EMB's position at t0 + dt1
q0      = get_Current_State_Cart(xOrb_epoch_t0_Ast, t0_o); display_asteroid(q0(1:3), 'outbound_t0');
qf      = get_Current_State_Cart(xOrb_epoch_t0_Ast, tf_o); display_asteroid(qf(1:3), 'outbound_t0_dt1_dtf');

% ----------------------------------------------------------------------------------------------------
% Spacefraft position and trajectory
% ----------------------------------------------------------------------------------------------------

% trajectory of the spacecraft
[times, states, q0, q1, qf] = get_Trajectory_SpaceCraft(xOrb_epoch_t0_EMB, t0_o, dt1_o, dtf_o, dV0_o, dV1_o, dVf_o);
display_Spacecraft(q0(1:3), 'outbound_t0');
display_Spacecraft(q1(1:3), 'outbound_t0_dt1');
display_Spacecraft(qf(1:3), 'outbound_t0_dt1_dtf');
display_Trajectory_Spacecraft(states, 'outbound');

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% Return
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
figure(hFigSpace_r)

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

% Display initial EMB's position at t0 + dt1
q0      = get_Current_State_Cart(xOrb_epoch_t0_EMB, t0_r); display_EMB(q0(1:3), 'return_t0');
qf      = get_Current_State_Cart(xOrb_epoch_t0_EMB, tf_r); display_EMB(qf(1:3), 'return_t0_dt1_dtf');

% ----------------------------------------------------------------------------------------------------
% Asteroid's orbit
% ----------------------------------------------------------------------------------------------------
[orbit_Ast, period_Ast] = get_Orbit(xOrb_epoch_t0_Ast);

% Display Asteroid's orbit
plot3(orbit_Ast(1,:), orbit_Ast(2,:), orbit_Ast(3,:), 'Color', DC.color_Ast, 'LineWidth', DC.LW); hold on;

% Display initial EMB's position at t0 + dt1
q0      = get_Current_State_Cart(xOrb_epoch_t0_Ast, t0_r); display_asteroid(q0(1:3), 'return_t0');
qf      = get_Current_State_Cart(xOrb_epoch_t0_Ast, tf_r); display_asteroid(qf(1:3), 'return_t0_dt1_dtf');

% ----------------------------------------------------------------------------------------------------
% Spacefraft position and trajectory
% ----------------------------------------------------------------------------------------------------

% trajectory of the spacecraft
[times, states, q0, q1, qf] = get_Trajectory_SpaceCraft(xOrb_epoch_t0_Ast, t0_r, dt1_r, dtf_r, dV0_r, dV1_r, dVf_r);
display_Spacecraft(q0(1:3), 'return_t0');
display_Spacecraft(q1(1:3), 'return_t0_dt1');
display_Spacecraft(qf(1:3), 'return_t0_dt1_dtf');
display_Trajectory_Spacecraft(states, 'return');

% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------
% Affichage des données dans le terminal
% ----------------------------------------------------------------------------------------------------
% ----------------------------------------------------------------------------------------------------

fprintf(['\n\n' DC.tirets '\n']);
fprintf([titre '\n']);
fprintf('The delta_V are given in km/s.');
fprintf(['\n' DC.tirets '\n\n']);
tiretsFig = '';
for i=1:110;
    tiretsFig= [tiretsFig '\_'];
end;

%
outTerminal         = { int2str(outputOptimization.numAsteroid)     , ...
                        outputOptimization.dVmax/UC.jour*UC.AU      , ...
                        int2str(outputOptimization.exitflag)        %, ...
%                        int2str(outputOptimization.output.iterations), ...
%                        outputOptimization.output.constrviolation   , ...
%                        outputOptimization.output.firstorderopt
                       };

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 'asteroid_number'   , ...
                                                'dVmax'             , ...
                                                'exitflag'         % , ...
%                                                'iterations'        , ...
%                                                'constrviolation'   , ...
%                                                'firstorderopt'     
                                                };

disp(outTerminal_cell)
TString = [titre sprintf('\n\n') 'The delta_V are given in km/s.' sprintf('\n\n') 'tiretsFig' sprintf('\n\n') evalc('disp(outTerminal_cell)')];

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
py  = 0.73;
lx  = 1.0-(px+0.05);
ly  = 0.22;
annotation(hFigSpace_o,'Textbox','fontsize',11,'String',TString,'Interpreter','Tex', 'Color', [0 0 0],...
    'FontName',FixedWidth,'Units','Normalized','Position',[px py lx ly],'BackgroundColor', 0.9*[1.0 1.0 1.0]);

annotation(hFigSpace_r,'Textbox','fontsize',11,'String',TString,'Interpreter','Tex', 'Color', [0 0 0],...
    'FontName',FixedWidth,'Units','Normalized','Position',[px py lx ly],'BackgroundColor', 0.9*[1.0 1.0 1.0]);

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% Outbound
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

%
outTerminal         = [{ outputOptimization.t0_o       , ...
                         outputOptimization.dt1_o      , ...
                         outputOptimization.dtf_o      , ...
                         norm(outputOptimization.dV0_o(1:3))/UC.jour*UC.AU   , ...
                         norm(outputOptimization.dV1_o(1:3))/UC.jour*UC.AU   , ...
                         norm(outputOptimization.dVf_o(1:3))/UC.jour*UC.AU   , ...
                         (norm(outputOptimization.dV1_o(1:3)) + norm(outputOptimization.dVf_o(1:3)))/UC.jour*UC.AU   } ];

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 't0_o'      , ...
                                                'dt1_o'     , ...
                                                'dtf_o'     , ...
                                                'norm_dV0_o'     , ...
                                                'norm_dV1_o'     , ...
                                                'norm_dVf_o'     , ...
                                                'norm_dV1f_o'    };

disp(outTerminal_cell)
TString = ['Outbound' sprintf('\n\n') 'tiretsFig' sprintf('\n\n') evalc('disp(outTerminal_cell)')];

% dates
date_epoch_t0       = UC.date_epoch_t0;
sec_t0              = seconds(outputOptimization.t0_o*UC.jour);
sec_dt1             = seconds(outputOptimization.dt1_o*UC.jour);
sec_dtf             = seconds(outputOptimization.dtf_o*UC.jour);
day_duration        = days(outputOptimization.dt1_o+outputOptimization.dtf_o);

outTerminal         = { date_epoch_t0+sec_t0                    , ...
                        date_epoch_t0+sec_t0+sec_dt1            , ...
                        date_epoch_t0+sec_t0+sec_dt1+sec_dtf    , ...
                        day_duration                            , ...
                        outputOptimization.delta_V_o/UC.jour*UC.AU};

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 'Start_date_o'  , ...
                                                'Boost_date_o'  , ...
                                                'End_date_o'    , ...
                                                'Duration_o'    , ...
                                                'dV_consump_o'    };

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
px  = pxFig+lxFig+0.02;
py  = 0.31;
lx  = 1.0-(px+0.05);
ly  = 0.35;
annotation(hFigSpace_o,'Textbox','fontsize',11,'String',TString,'Interpreter','Tex', 'Color', [0 0 0],...
    'FontName',FixedWidth,'Units','Normalized','Position',[px py lx ly],'BackgroundColor', 0.99*[1.0 1.0 1.0]);

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% Return
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

%
outTerminal         = [{ outputOptimization.t0_r       , ...
                         outputOptimization.dt1_r      , ...
                         outputOptimization.dtf_r      , ...
                         norm(outputOptimization.dV0_r(1:3))/UC.jour*UC.AU   , ...
                         norm(outputOptimization.dV1_r(1:3))/UC.jour*UC.AU   , ...
                         norm(outputOptimization.dVf_r(1:3))/UC.jour*UC.AU   , ...
                         (norm(outputOptimization.dV0_r(1:3)) + norm(outputOptimization.dV1_r(1:3)))/UC.jour*UC.AU   } ];

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 't0_r'      , ...
                                                'dt1_r'     , ...
                                                'dtf_r'     , ...
                                                'norm_dV0_r'     , ...
                                                'norm_dV1_r'     , ...
                                                'norm_dVf_r'     , ...
                                                'norm_dV01_r'    };

disp(outTerminal_cell)
TString = ['Return' sprintf('\n\n') 'tiretsFig' sprintf('\n\n') evalc('disp(outTerminal_cell)')];

% dates
date_epoch_t0       = UC.date_epoch_t0;
sec_t0              = seconds(outputOptimization.t0_r*UC.jour);
sec_dt1             = seconds(outputOptimization.dt1_r*UC.jour);
sec_dtf             = seconds(outputOptimization.dtf_r*UC.jour);
day_duration        = days(outputOptimization.dt1_r+outputOptimization.dtf_r);

outTerminal         = { date_epoch_t0+sec_t0                    , ...
                        date_epoch_t0+sec_t0+sec_dt1            , ...
                        date_epoch_t0+sec_t0+sec_dt1+sec_dtf    , ...
                        day_duration                            , ...
                        outputOptimization.delta_V_r/UC.jour*UC.AU};

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 'Start_date_r'  , ...
                                                'Boost_date_r'  , ...
                                                'End_date_r'    , ...
                                                'Duration_r'    , ...
                                                'dV_consump_r'    };

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
px  = pxFig+lxFig+0.02;
py  = 0.31;
lx  = 1.0-(px+0.05);
ly  = 0.35;
annotation(hFigSpace_r,'Textbox','fontsize',11,'String',TString,'Interpreter','Tex', 'Color', [0 0 0],...
    'FontName',FixedWidth,'Units','Normalized','Position',[px py lx ly],'BackgroundColor', 0.99*[1.0 1.0 1.0]);

% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------
% Total
% ------------------------------------------------------------------------------
% ------------------------------------------------------------------------------

% ----------------------------------------------------------------------------------------------------
% On affiche les donnees finales interressantes
fprintf([DC.tirets '\n\n']);

time_on_ast = outputOptimization.t0_r - (outputOptimization.t0_o+outputOptimization.dt1_o+outputOptimization.dtf_o);
total_durat = outputOptimization.dt1_o+outputOptimization.dtf_o + time_on_ast + outputOptimization.dt1_r+outputOptimization.dtf_r;
delta_V_tot = (outputOptimization.delta_V)/UC.jour*UC.AU;

outTerminal         = {  days(time_on_ast)          , ...
                         years(total_durat/365.25)  , ...
                         delta_V_tot                , ...
                         delta_V_tot/(total_durat/365.25) };

outTerminal_cell    = cell2table(outTerminal);
outTerminal_cell.Properties.VariableNames   = { 'Time_On_Ast'       , ...
                                                'Total_duration'    , ...
                                                'dV_total'          , ...
                                                'Efficiency_dV_duration' };

disp(outTerminal_cell)
fprintf([DC.tirets '\n\n\n\n\n']);

TString = ['global information' sprintf('\n\n') 'tiretsFig' sprintf('\n\n') evalc('disp(outTerminal_cell)')];

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
px  = px;
py  = 0.05;
lx  = 1.0-(px+0.05);
ly  = 0.2;
annotation(hFigSpace_o,'Textbox','fontsize',11,'String',TString,'Interpreter','Tex', 'Color', [0 0 0],...
    'FontName',FixedWidth,'Units','Normalized','Position',[px py lx ly],'BackgroundColor', 0.9*[1.0 1.0 1.0]);

annotation(hFigSpace_r,'Textbox','fontsize',11,'String',TString,'Interpreter','Tex', 'Color', [0 0 0],...
    'FontName',FixedWidth,'Units','Normalized','Position',[px py lx ly],'BackgroundColor', 0.9*[1.0 1.0 1.0]);


figure(hFigSpace_o);
