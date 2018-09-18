%
% Auteur : Olivier Cots, INP-ENSEEIHT & IRIT
% Date   : 2018
%
% Transfert orbital, temps min
%
clear all;
close all;
path(pathdef);

% On met a jour le path
%
addpath(['libhampathCIMI/']);
addpath(['ressources/']);

tirets  = ['---------------------------------------------------------------------'];
LW      = 1.5;
set(0,  'defaultaxesfontsize'   ,  14     , ...
'DefaultTextVerticalAlignment'  , 'bottom', ...
'DefaultTextHorizontalAlignment', 'left'  , ...
'DefaultTextFontSize'           ,  14     , ...
'DefaultFigureWindowStyle','docked');

%-------------------------------------------------------------------------------------------------------------
% Parametres et options
%-------------------------------------------------------------------------------------------------------------
%
% Parametres

t0      = 0.0;

x01     = -42272.67;
x02     = 0.0;
x03     = 0.0;
x04     = -5796.72;
q0      = [x01 x02 x03 x04]'                        % Etat initial

nparmin = 8;
mu      = 5.1658620912e12;
rf      = 42165.0;
gm      = 388.8;
par     = [nparmin x01 x02 x03 x04 mu rf gm]';
n       = length(q0);

% Definitions des options
%
disp(tirets);
fprintf('\n Options : \n\n');
options = hampathset;
disp(options)

%-------------------------------------------------------------------------------------------------------------
% Resolution du probleme de controle optimal : ssolve
%-------------------------------------------------------------------------------------------------------------
%
%
% Initial guess : yGuess = [p0Guess; tfGuess];
%
disp(tirets); fprintf('\n Résolution du problème de contrôle optimal via la méthode de tir simple indirect : \n\n');

%p0Guess = [-0.572178385635793E-03
%           -0.322746156724994E-04
%           -0.235363068133007E-03
%           -0.383359843227506E-02];
%tfGuess = 0.195483037881584E+02;

p0_guess = -1e-4*[1 1 1 1]';
tf_guess = 10.0;

y_guess  = [p0_guess; tf_guess];

% avec HamPath
fprintf('\n Avec HamPath \n');

[ySol,Ssol,nSev,njev,flag] = ssolve(y_guess, options, par);

if(flag~=1) error('Pb de convergence !'); end;

fprintf('\n');
fprintf(['      Initial guess                 : p0_guess = [%g,%g,%g,%g]\n'], p0_guess);
fprintf(['      Initial guess                 : tf_guess = %g\n'], tf_guess);
fprintf(['      Solution trouvée              : p0       = [%g,%g,%g,%g]\n'], ySol(1:4));
fprintf(['      Initial guess                 : tf       = %g\n'], ySol(5));
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g,%g,%g,%g,%g]\n'], Ssol);
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
fprintf(['      Initial guess                 : p0_guess = [%g,%g,%g,%g]\n'], p0_guess);
fprintf(['      Initial guess                 : tf_guess = %g\n'], tf_guess);
fprintf(['      Solution trouvée              : p0       = [%g,%g,%g,%g]\n'], ysolMatlab(1:4));
fprintf(['      Initial guess                 : tf       = %g\n'], ysolMatlab(5));
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g,%g,%g,%g,%g]\n'], SsolMatlab);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], output.funcCount);

%
disp('Appuyer sur une touche pour continuer...'); pause;

%-------------------------------------------------------------------------------------------------------------
% Affichage de la trajectoire avec les orbites initiale et finale
%-------------------------------------------------------------------------------------------------------------
%

disp(tirets); fprintf('\n Visualisation de la solution \n\n');

% Orbites initiale et finale
%
hFig    = figure;
nbFigs  = {2,4};
subplot(nbFigs{:},[1 2 5 6]);
orbite0f(q0, mu, rf); axis('square'); hold on;

% Solution
p0      = ySol(1:4);
tf      = ySol(5);

[tout,z,flag] = exphvfun([t0 tf], [q0;p0],options,par);
plot(z(1,:), z(2,:), 'k', 'LineWidth', LW);

% Controle
u       = control(tout,z,par);
subplot(nbFigs{:},[3 4]); plot(tout,u(1,:),'r'); xlabel('t'); ylabel('u_1'); xlim([t0 tf]);
subplot(nbFigs{:},[7 8]); plot(tout,u(2,:),'r'); xlabel('t'); ylabel('u_2'); xlim([t0 tf]);

