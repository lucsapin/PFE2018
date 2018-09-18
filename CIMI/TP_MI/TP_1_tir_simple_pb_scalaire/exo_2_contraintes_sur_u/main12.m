% Auteur : Olivier Cots, INP-ENSEEIHT & IRIT
% Date   : 2018
%
% Etude du probleme de controle optimal :
%
% min J(u) = 1/2 * int_{t0}^(tf} u(t)^2 dt
% dot{x}(t) = - x(t) + u(t), |u(t)| <= umax
% x(t0) = x0
% x(tf) = xf
%
% t0 = 0, tf = 1, x0 = -1, xf = 0.
%

% On reinitialise l'environnement
%
clear all;
close all;
path(pathdef);

% On met a jour le path
%
addpath(['libhampathCIMI/']);
addpath(['ressources/']);

% Des parametres pour l'affichage
%
tirets  = ['---------------------------------------------------------------------'];
LW      = 1.5;
set(0,  'defaultaxesfontsize'   ,  14     , ...
'DefaultTextVerticalAlignment'  , 'bottom', ...
'DefaultTextHorizontalAlignment', 'left'  , ...
'DefaultTextFontSize'           ,  14     , ...
'DefaultFigureWindowStyle','docked');

% Definition des parametres : par = [t0, tf, x0, xf, umax]
% Et du tspan
%
t0      =  0.0;
tf      =  1.0;
x0      = -1.0;
xf      =  0.0;
umax    =  1.0;
par     = [t0; tf; x0; xf; umax];

tspan   = [t0 tf];

% Definitions des options
%
disp(tirets);
fprintf('\n Options : \n\n');
options = hampathset;
disp(options)

% Solution
%
p0_solution = 2.0*(xf*exp(tf)-x0)/(exp(2.0*tf)-1.0);

%-------------------------------------------------------------------------------------------------------------
% Les fonctions disponibles : hfun, hvfun, exphvfun, expdhvfun, sfun, ssolve, hampath
%-------------------------------------------------------------------------------------------------------------
%
%

p0  = 1.0;      % vecteur adjoint initial
z0  = [x0; p0];

fprintf(' Paramètres : \n\n');

fprintf(['      t0 = %g\n'], t0);
fprintf(['      tf = %g\n'], tf);
fprintf(['      x0 = %g\n'], x0);
fprintf(['      xf = %g\n'], xf);
fprintf(['      p0 = %g\n'], p0);

fprintf('\n Fonctions disponibles (exemples) : \n\n');

% control
u = control(t0, z0, par);
fprintf(['      control   : us(x0, p0)              = %g\n'], u);
% sol : u = 1

% hfun
h = hfun(t0, z0, par);
fprintf(['      hfun      : H(x0, p0, us(x0,p0))    = %g\n'], h);
% sol : h = 1.5

% hvfun
hv = hvfun(t0, z0, par);
fprintf(['      hvfun     : Hv(x0, p0)              = (%g,%g)\n'], hv(1),hv(2));
% sol : hv = (2, 1)

% exphvfun
[ tout, z, flag ] = exphvfun(tspan, z0, options, par);
fprintf(['      exphvfun  : x(tf, x0, p0)           = %2.9f,\n'], z(1,end));
% sol : x(tf, x0, p0) = (0.5*p0*(exp(2*tf)-1)+x0)*exp(-tf) = 0.807321752472359

% expdhvfun
dz0 = [1.0; 0.0];
[ tout, z, dz, flag ] = expdhvfun(tspan, z0, dz0, options, par);
fprintf(['      expdhvfun : dx/dx0(tf, x0, p0)      = %2.9f,\n'], dz(1,end));
% sol : dx/dx0(tf, x0, p0) = exp(-tf) = 0.367879441171442

% sfun
s = sfun(p0, options, par);
fprintf(['      sfun      : S(p0)                   = %2.9f,\n'], s);
% sol : S(p0) = x(tf, x0, p0) - xf = (0.5*p0*(exp(2*tf)-1)+x0)*exp(-tf)-xf = 0.807321752472359

fprintf(['      ssolve    : ... \n']);
fprintf(['      hampath   : ... \n\n']);

%
disp('Appuyer sur une touche pour continuer...'); pause;

%-------------------------------------------------------------------------------------------------------------
% Resolution du probleme de controle optimal : ssolve
%-------------------------------------------------------------------------------------------------------------
%
%

disp(tirets); fprintf('\n Résolution du problème de contrôle optimal via la méthode de tir simple indirect : \n\n');

%p0_guess = 0.5; % prediction du vecteur adjoint initial
p0_guess = 5; % prediction du vecteur adjoint initial

% avec HamPath
fprintf('\n Avec HamPath \n');
[ p0sol, Ssol, nSev, njev, flag] = ssolve(p0_guess, options, par);

if(flag~=1) error('Pb de convergence !'); end;

fprintf('\n');
fprintf(['      Initial guess                 : p0_guess = %g\n'], p0_guess);
fprintf(['      Solution trouvée              : p0       = %g\n'], p0sol);
fprintf(['      Ecart à la solution           : e        = %g\n'], p0sol-p0_solution);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = %g\n'], Ssol);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], nSev);

%
disp('Appuyer sur une touche pour continuer...'); pause;

% avec fsolve de Matlab
fprintf('\n Avec fsolve de Matlab \n');
myfun                       = @(p0) sfunjac(p0, options, par);
tolX                        = hampathget(options,'TolX');
optionsNLE                  = optimoptions( 'fsolve', 'display', 'iter', 'Algorithm', 'levenberg-marquardt', 'StepTolerance', tolX );
[p0solMatlab, SsolMatlab, exitflag, output]    = fsolve(myfun, p0_guess , optionsNLE);

fprintf(['      Initial guess                 : p0_guess = %g\n'], p0_guess);
fprintf(['      Solution trouvée              : p0       = %g\n'], p0solMatlab);
fprintf(['      Ecart à la solution           : e        = %g\n'], p0solMatlab-p0_solution);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = %g\n'], SsolMatlab);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], output.funcCount);

%
disp('Appuyer sur une touche pour continuer...'); pause;

%-------------------------------------------------------------------------------------------------------------
% Visualisation de la solution et de la fonction de tir
%-------------------------------------------------------------------------------------------------------------
%
%

disp(tirets); fprintf('\n Visualisation de la solution et de la fonction de tir \n\n');

%-------------------------------------------------------------------------------------------------------------
figRes = figure('units','normalized'); % Visualisation
nbFigs = {2,2};

%-------------------------------------------------------------------------------------------------------------
% Visualisation de la fonction de tir
%
yspan = linspace(-3,3,100); % p0 in [-3, 3]
s     = [];
for i=1:length(yspan)
    s  = [s sfun(yspan(i),options,par)];
end;
subplot(nbFigs{:},4); hold on; plot(yspan,s,'b','LineWidth',LW); xlabel('p_0'); ylabel('S'); daxes(p0sol,0,'k--');
subplot(nbFigs{:},4); hold on; plot(p0sol, Ssol,'kd', 'MarkerFaceColor',[1 0 1]); % S(p0sol)
axis([min(yspan) max(yspan) min(s)-0.01 max(s)+0.01]) % S(p0sol)

%-------------------------------------------------------------------------------------------------------------
% Visualisation de trajectoires dont la solution
%

% --------------
% p0 = 0.0
p0_1        = 0.0;
z0          = [x0; p0_1];
[ tout, z, flag ] = exphvfun(tspan, z0, options, par);

% calcul du contrôle
u = control(tout, z, par);

subplot(nbFigs{:},1); hold on; plot(tout, z(1,:), 'b', 'LineWidth', LW);
subplot(nbFigs{:},2); hold on; plot(tout, z(2,:), 'b', 'LineWidth', LW);
subplot(nbFigs{:},3); hold on; plot(tout,      u, 'b', 'LineWidth', LW);

% --------------
% p0 = 0.4
p0_2        = 0.4;
z0          = [x0; p0_2];
[ tout, z, flag ] = exphvfun(tspan, z0, options, par);

% calcul du contrôle
u = control(tout, z, par);

subplot(nbFigs{:},1); hold on; plot(tout, z(1,:), 'r', 'LineWidth', LW);
subplot(nbFigs{:},2); hold on; plot(tout, z(2,:), 'r', 'LineWidth', LW);
subplot(nbFigs{:},3); hold on; plot(tout,      u, 'r', 'LineWidth', LW);

% --------------
z0          = [x0; p0sol];
[ tout, z, flag ] = exphvfun(tspan, z0, options, par);

% calcul du contrôle
u = control(tout, z, par);

subplot(nbFigs{:},1); hold on; plot(tout, z(1,:), 'm', 'LineWidth', LW);
subplot(nbFigs{:},2); hold on; plot(tout, z(2,:), 'm', 'LineWidth', LW);
subplot(nbFigs{:},3); hold on; plot(tout,      u, 'm', 'LineWidth', LW); daxes(0, umax, 'k--');

% Les legendes et labels
subplot(nbFigs{:},1); daxes(1,0,'k--');
subplot(nbFigs{:},1); xlabel('t'); ylabel('x'); legend({sprintf(['p_0 = %g'],p0_1),sprintf(['p_0 = %g'],p0_2),sprintf(['p^*_0 = %g'],p0sol)},'Location','NorthWest');
subplot(nbFigs{:},2); xlabel('t'); ylabel('p'); legend({sprintf(['p_0 = %g'],p0_1),sprintf(['p_0 = %g'],p0_2),sprintf(['p^*_0 = %g'],p0sol)},'Location','NorthWest');
subplot(nbFigs{:},3); xlabel('t'); ylabel('u'); legend({sprintf(['p_0 = %g'],p0_1),sprintf(['p_0 = %g'],p0_2),sprintf(['p^*_0 = %g'],p0sol)},'Location','NorthWest');

