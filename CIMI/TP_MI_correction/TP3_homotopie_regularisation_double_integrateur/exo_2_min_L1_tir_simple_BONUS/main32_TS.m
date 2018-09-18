% Auteur : Olivier Cots, INP-ENSEEIHT & IRIT
% Date   : 2018
%
% Etude du probleme de controle optimal (double integrateur) :
%
% min J(u) = int_{t0}^{tf} |u(t)| dt
% dot{x1}(t) = x1(t),
% dot{x1}(t) = u(t), |u(t)| <= umax
% x(0) = x0
% x(tf) = xf
%
% t0 = 0, tf = 3, x0 = (-1,0), xf = (0,0), umax = 1.
%

% On reinitialise l'environnement
%
clear all;
close all;
path(pathdef);

% On met a jour le path
%
addpath(['libhampath/']);
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

%
fprintf(' \n Double intégrateur. Problème de minimisation L1 avec régularisation et contraintes sur le contrôle.\n\n')
fprintf('   min J(u) = int_{t0}^{tf} |u(t)| dt\n')
fprintf('   \n')
fprintf('   dot{x1}(t) = x1(t),\n')
fprintf('   dot{x1}(t) = u(t), |u(t)| <= umax,\n')
fprintf('   \n')
fprintf('   x(t0) = x0,\n')
fprintf('   x(tf) = xf,\n')
fprintf('   \n')
fprintf('   t0 = 0, tf = 3, x0 = (-1,0), xf = (0,0), umax = 1, lambda in [0, 1[.\n')
fprintf('   \n')
fprintf('   La structure est : u=umax puis u=0 et u=-umax.\n')
fprintf('   \n')

% Definition des parametres : par = [t0, tf, x0, xf, umax, lambda]
% Et du tspan
%
t0      = 0.0;
tf      = 3.0;
x0      = [-1.0; 0.0];
xf      = [ 0.0; 0.0];
umax    = 1.0;
par     = [t0; tf; x0; xf; umax];

n       = length(x0);

% Definitions des options
%
disp(tirets);
fprintf('\n Options : \n\n');
options = hampathset;
disp(options)

%
disp('Appuyer sur une touche pour continuer...'); pause;

%-------------------------------------------------------------------------------------------------------------
% Resolution du probleme de controle optimal : ssolve
%-------------------------------------------------------------------------------------------------------------
%
%

disp(tirets); fprintf('\n Résolution du problème de contrôle optimal via la méthode de tir multiple indirect : \n\n');

%    Structure               : u=+1, u=0, u=-1 
%    vecteur adjoint initial : p0 = [0.895089, 1.34263]
%    Commutation             : t1 = 0.382538
%    Commutation             : t2 = 2.61716

t1sol = 0.382538;
t2sol = 2.61716;

% ---------------
% A COMPLETER
p0_guess = [0.895089, 1.34263]';
p0_guess = [0.1, 2]';
% FIN A COMPLETER
% ---------------
y_guess  = [p0_guess];

% avec HamPath
fprintf('\n Avec HamPath \n');
[ ysol, Ssol, nSev, njev, flag] = ssolve(y_guess, options, par);

if(flag~=1) error('Pb de convergence lors du tir !'); end;

fprintf('\n');
fprintf(['      Initial guess                 : p0_guess = [%g, %g]\n'], p0_guess);
fprintf(['      Solution trouvée              : p0       = [%g, %g]\n'], ysol);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g, %g]\n'], Ssol);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], nSev);

%
disp('Appuyer sur une touche pour continuer...'); pause;

% avec fsolve de Matlab
fprintf('\n Avec fsolve de Matlab \n');
myfun                       = @(y) sfunjac(y, options, par);
tolX                        = hampathget(options,'TolX');
optionsNLE                  = optimoptions( 'fsolve', 'display', 'iter', 'Algorithm', 'levenberg-marquardt', 'StepTolerance', tolX );
[ysolMatlab, SsolMatlab, exitflag, output]    = fsolve(myfun, y_guess , optionsNLE);

fprintf('\n');
fprintf(['      Initial guess                 : p0_guess = [%g, %g]\n'], p0_guess);
fprintf(['      Solution trouvée              : p0       = [%g, %g]\n'], ysolMatlab);
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

%
p0sol       = ysol;

z0          = [x0; p0sol];
tspan       = linspace(t0, tf, 1e2);
[ tout, z, flag ] = exphvfun(tspan, z0, options, par);

% calcul du contrôle
u = control(tout, z, par);

subplot(nbFigs{:},1); hold on;

% on affiche les courbes de commutations : gamma_- et gamma_+
x2 = linspace(0.0, 1.5, 100);
x1_moins = -0.5*x2.^2;
x1_plus  =  0.5*x2.^2;
plot(x1_moins, x2, 'g--', 'LineWidth', 1.0);
plot(x1_plus, -x2, 'r--', 'LineWidth', 1.0);

% la trajectoire
plot(z(1,:), z(2,:), 'b', 'LineWidth', LW); axis([-1.2 0.2 -0.2 0.6]);

% controle et vecteur adjoint
subplot(nbFigs{:},2); hold on; xlim([tout(1) tout(end)]); ylim([-umax umax]);
daxes(t1sol, umax, 'k--'); daxes(t2sol, 0, 'k--'); daxes(0, -umax, 'k--'); plot(tout, u, 'b', 'LineWidth', LW);
subplot(nbFigs{:},3); hold on; xlim([tout(1) tout(end)]); plot(tout, z(n+1,:), 'b', 'LineWidth', LW);
subplot(nbFigs{:},4); hold on; xlim([tout(1) tout(end)]); ylim([-1.5 1.5]);
daxes(t1sol, 0, 'k--');
daxes(t2sol, 1, 'k--');
daxes(0, -1, 'k--');
plot(tout, z(n+2,:), 'b', 'LineWidth', LW);

% Les legendes et labels
subplot(nbFigs{:},1); daxes(0,0,'k--');
subplot(nbFigs{:},1); xlabel('x_1'); ylabel('x_2');
subplot(nbFigs{:},2); xlabel('t'); ylabel('u'); xlim([t0 tf]);
subplot(nbFigs{:},3); xlabel('t'); ylabel('p_1'); xlim([t0 tf]);
subplot(nbFigs{:},4); xlabel('t'); ylabel('p_2'); xlim([t0 tf]);
