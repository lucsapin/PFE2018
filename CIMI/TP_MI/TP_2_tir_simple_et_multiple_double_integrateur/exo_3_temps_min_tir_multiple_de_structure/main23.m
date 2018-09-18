% Auteur : Olivier Cots, INP-ENSEEIHT & IRIT
% Date   : 2018
%
% Etude du probleme de controle optimal (double integrateur) :
%
% min J(u, tf) = tf
% dot{x1}(t) = x1(t),
% dot{x1}(t) = u(t), |u(t)| <= umax
% x(0)  = x0
% x(tf) = xf
%
% t0 = 0, x0 = (-1,0), xf = (0,0).
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

%
fprintf(' \n Double intégrateur. Problème de minimisation du temps final avec contraintes sur le contrôle.\n\n')
fprintf('   min J(u,tf) = tf\n')
fprintf('   \n')
fprintf('   dot{x1}(t) = x1(t),\n')
fprintf('   dot{x1}(t) = u(t), |u(t)| <= umax,\n')
fprintf('   \n')
fprintf('   x(0)  = x0,\n')
fprintf('   x(tf) = xf,\n')
fprintf('   \n')
fprintf('   x0 = (-1,0), xf = (0,0), umax = 1.\n')
fprintf('   \n')

% Definition des parametres : par = [x0, xf, umax]
% Et du tspan
%
x0      = [-1.0; 0.0];
xf      = [ 0.0; 0.0];
umax    = 1.0;
par     = [x0; xf; umax];

t0      = 0.0;
n       = length(x0);

% Definitions des options
%
disp(tirets);
fprintf('\n Options : \n\n');
options = hampathset;
disp(options)

%
disp('Appuyer sur une touche pour continuer...'); pause;

% Solution
%
p0_solution = [1.0; 1.0];
t1_solution = 1.0;
tf_solution = 2.0;

%-------------------------------------------------------------------------------------------------------------
% Resolution du probleme de controle optimal : ssolve
%-------------------------------------------------------------------------------------------------------------
%
%

disp(tirets); fprintf('\n Résolution du problème de contrôle optimal via la méthode de tir multiple indirect : \n');
fprintf(' on suppose une structure Bang-Bang : u=+1 suivi de u=-1.\n\n');

p0_guess = [0.5; 0.5];              % prediction du vecteur adjoint initial
t1_guess = 0.5;                     % prediction de l'instant de commutation
tf_guess = 3.0;                     % prediction du temps final
y_guess  = [p0_guess; tf_guess; t1_guess];

% avec HamPath
fprintf('\n Avec HamPath \n');
[ ysol, Ssol, nSev, njev, flag] = ssolve(y_guess, options, par);

if(flag~=1) error('Pb de convergence !'); end;

e = ysol - [p0_solution; tf_solution; t1_solution];

fprintf('\n');
fprintf(['      Initial guess                 : y_guess  = [%g, %g, %g, %g]\n'], y_guess);
fprintf(['      Solution trouvée              : p0       = [%g, %g]\n'], ysol(1:2));
fprintf(['      Solution trouvée              : tf       = %g\n'], ysol(3));
fprintf(['      Solution trouvée              : t1       = %g\n'], ysol(4));
fprintf(['      Ecart à la solution           : e        = [%g, %g, %g, %g]\n'], e);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g, %g, %g, %g]\n'], Ssol);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], nSev);

%
disp('Appuyer sur une touche pour continuer...'); pause;

% avec fsolve de Matlab
fprintf('\n Avec fsolve de Matlab \n');
myfun                       = @(y) sfunjac(y, options, par);
tolX                        = hampathget(options,'TolX');
optionsNLE                  = optimoptions( 'fsolve', 'display', 'iter', 'Algorithm', 'levenberg-marquardt', 'StepTolerance', tolX );
[ysolMatlab, SsolMatlab, exitflag, output]    = fsolve(myfun, y_guess , optionsNLE);
e = ysolMatlab - [p0_solution; tf_solution; t1_solution];

fprintf('\n');
fprintf(['      Initial guess                 : y_guess  = [%g, %g, %g, %g]\n'], y_guess);
fprintf(['      Solution trouvée              : p0       = [%g, %g]\n'], ysolMatlab(1:2));
fprintf(['      Solution trouvée              : tf       = %g\n'], ysolMatlab(3));
fprintf(['      Solution trouvée              : t1       = %g\n'], ysolMatlab(4));
fprintf(['      Ecart à la solution           : e        = [%g, %g, %g, %g]\n'], e);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g, %g, %g, %g]\n'], SsolMatlab);
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

p0sol       = ysol(1:n);
tfsol       = ysol(n+1);
t1sol       = ysol(n+2);

ti          = [t0 t1sol tfsol]; % pour integrer la trajectoire sur plusieurs arcs

z0          = [x0; p0sol];
tspan       = linspace(t0, tfsol, 1e4);
[ tout, z, flag ] = exphvfun(tspan, z0, ti, options, par);

% calcul du contrôle
u = control(tout, z, ti, par);

subplot(nbFigs{:},1); hold on;

% on affiche les courbes de commutations : gamma_- et gamma_+
x2 = linspace(0.0, 1.5, 100);
x1_moins = -0.5*x2.^2;
x1_plus  =  0.5*x2.^2;
plot(x1_moins, x2, 'g--', 'LineWidth', 1.0);
plot(x1_plus, -x2, 'r--', 'LineWidth', 1.0);

% la trajectoire
plot(z(1,:), z(2,:), 'b', 'LineWidth', LW); axis(1.5*[-1 1 -1 1]);

% controle et vecteur adjoint
subplot(nbFigs{:},2); hold on; xlim([tout(1) tout(end)]); daxes(0, umax, 'k--'); daxes(0, -umax, 'k--'); plot(tout, u,        'b', 'LineWidth', LW);
subplot(nbFigs{:},3); hold on; xlim([tout(1) tout(end)]); plot(tout, z(n+1,:), 'b', 'LineWidth', LW);
subplot(nbFigs{:},4); hold on; xlim([tout(1) tout(end)]); ylim([-1 1]); daxes(t1sol, 0, 'k--'); plot(tout, z(n+2,:), 'b', 'LineWidth', LW);

% Les legendes et labels
subplot(nbFigs{:},1); daxes(0,0,'k--');
subplot(nbFigs{:},1); xlabel('x_1'); ylabel('x_2');
subplot(nbFigs{:},2); xlabel('t'); ylabel('u'); xlim([t0 tfsol]);
subplot(nbFigs{:},3); xlabel('t'); ylabel('p_1'); xlim([t0 tfsol]);
subplot(nbFigs{:},4); xlabel('t'); ylabel('p_2'); xlim([t0 tfsol]);

