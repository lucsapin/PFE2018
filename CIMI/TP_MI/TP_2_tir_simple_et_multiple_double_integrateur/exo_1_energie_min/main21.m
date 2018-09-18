% Auteur : Olivier Cots, INP-ENSEEIHT & IRIT
% Date   : 2018
%
% Etude du probleme de controle optimal (double integrateur) :
%
% min J(u) = 1/2 * int_{t0}^(tf} u(t)^2 dt
% dot{x1}(t) = x1(t),
% dot{x1}(t) = u(t), |u(t)| <= umax
% x(t0) = x0
% x(tf) = xf
%
% t0 = 0, tf = 1, x0 = (-1,0), xf = (0,0).
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

fprintf(' \n Double intégrateur. Problème de minimisation de l''énergie avec contraintes sur le contrôle.\n\n')
fprintf('   min J(u) = 1/2 * int_{t0}^(tf} u(t)^2 dt\n')
fprintf('   \n')
fprintf('   dot{x1}(t) = x1(t),\n')
fprintf('   dot{x1}(t) = u(t), |u(t)| <= umax,\n')
fprintf('   \n')
fprintf('   x(t0) = x0,\n')
fprintf('   x(tf) = xf,\n')
fprintf('   \n')
fprintf('   t0 = 0, tf = 1, x0 = (-1,0), xf = (0,0).\n')
%

fprintf('\n Choisir umax : \n\n');
fprintf('       1 - umax = 7 (équivalent au problème sans contraintes sur u)\n');
fprintf('       2 - umax = 4.5\n\n');
choix = 0;
while(choix~=1 && choix~=2)
    choix = input(' Choisir 1 ou 2 puis appuyer sur entrée.\n');
end
if(choix==1)
    umax = 7.0;
else
    umax = 4.5;
end

% Definition des parametres : par = [t0, tf, x0, xf, umax]
% Et du tspan
%
t0      =  0.0;
tf      =  1.0;
x0      = [-1.0; 0.0];
xf      = [ 0.0; 0.0];
%umax    = 7.0;
%umax    = 4.5;
par     = [t0; tf; x0; xf; umax];

tspan   = [t0 tf];
n       = length(x0);

% Definitions des options
%
disp(tirets);
fprintf('\n Options : \n\n');
options = hampathset;
disp(options)

% Solution
%
if(umax>=6.0)
    p0_solution = [12.0; 6.0];
elseif(umax==4.5)
    p0_solution = [0.155884489551447E+02; 0.779422425226331E+01]; % solution issue de HamPath
else
    p0_solution = [0.0; 0.0];
end;

%-------------------------------------------------------------------------------------------------------------
% Resolution du probleme de controle optimal : ssolve
%-------------------------------------------------------------------------------------------------------------
%
%

disp(tirets); fprintf('\n Résolution du problème de contrôle optimal via la méthode de tir simple indirect : \n\n');

p0_guess = [0.5; 0.5]; % prediction du vecteur adjoint initial

% avec HamPath
fprintf('\n Avec HamPath \n');
[ p0sol, Ssol, nSev, njev, flag] = ssolve(p0_guess, options, par);

if(flag~=1) error('Pb de convergence !'); end;

e = p0sol-p0_solution;

fprintf('\n');
fprintf(['      Initial guess                 : p0_guess = [%g, %g]\n'], p0_guess);
fprintf(['      Solution trouvée              : p0       = [%g, %g]\n'], p0sol);
fprintf(['      Ecart à la solution           : e        = [%g, %g]\n'], e);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g, %g]\n'], Ssol);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], nSev);

%
disp('Appuyer sur une touche pour continuer...'); pause;

% avec fsolve de Matlab
fprintf('\n Avec fsolve de Matlab \n');
myfun                       = @(p0) sfunjac(p0, options, par);
tolX                        = hampathget(options,'TolX');
optionsNLE                  = optimoptions( 'fsolve', 'display', 'iter', 'Algorithm', 'levenberg-marquardt', 'StepTolerance', tolX );
[p0solMatlab, SsolMatlab, exitflag, output]    = fsolve(myfun, p0_guess , optionsNLE);
e = p0solMatlab-p0_solution;

fprintf(['      Initial guess                 : p0_guess = [%g, %g]\n'], p0_guess);
fprintf(['      Solution trouvée              : p0       = [%g, %g]\n'], p0solMatlab);
fprintf(['      Ecart à la solution           : e        = [%g, %g]\n'], e);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g, %g]\n'], SsolMatlab);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], output.funcCount);

%
disp('Appuyer sur une touche pour continuer...'); pause;

%-------------------------------------------------------------------------------------------------------------
% Visualisation de la solution
%-------------------------------------------------------------------------------------------------------------
%
%

disp(tirets); fprintf('\n Visualisation de la solution \n\n');

%-------------------------------------------------------------------------------------------------------------
figRes = figure('units','normalized'); % Visualisation
nbFigs = {2,2};

%-------------------------------------------------------------------------------------------------------------
% Visualisation de la trajectoire solution
%

z0          = [x0; p0sol];
tspan       = linspace(tspan(1), tspan(2), 1e2);
[ tout, z, flag ] = exphvfun(tspan, z0, options, par);

% calcul du contrôle
u = control(tout, z, par);

subplot(nbFigs{:},1); hold on; plot(z(1,:), z(2,:), 'b', 'LineWidth', LW); axis([-2 2 -2 2]);
subplot(nbFigs{:},2); hold on; xlim([tout(1) tout(end)]); daxes(0, umax, 'k--'); daxes(0, -umax, 'k--'); plot(tout, u, 'b', 'LineWidth', LW);
subplot(nbFigs{:},3); hold on; xlim([tout(1) tout(end)]); plot(tout, z(n+1,:), 'b', 'LineWidth', LW);
subplot(nbFigs{:},4); hold on; xlim([tout(1) tout(end)]); plot(tout, z(n+2,:), 'b', 'LineWidth', LW);

% Les legendes et labels
subplot(nbFigs{:},1); daxes(0,0,'k--');
subplot(nbFigs{:},1); xlabel('x_1'); ylabel('x_2');
subplot(nbFigs{:},2); xlabel('t'); ylabel('u');
subplot(nbFigs{:},3); xlabel('t'); ylabel('p_1');
subplot(nbFigs{:},4); xlabel('t'); ylabel('p_2');

