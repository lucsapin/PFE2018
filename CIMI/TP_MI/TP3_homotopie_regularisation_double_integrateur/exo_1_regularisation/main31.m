% Auteur : Olivier Cots, INP-ENSEEIHT & IRIT
% Date   : 2018
%
% Etude du probleme de controle optimal (double integrateur) :
%
% min J(u) = int_{t0}^{tf} |u(t)|^(2-lambda) dt
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
fprintf(' \n Double intégrateur. Problème de minimisation L1 avec régularisation et contraintes sur le contrôle.\n\n')
fprintf('   min J(u) = int_{t0}^{tf} |u(t)|^(2-lambda) dt\n')
fprintf('   \n')
fprintf('   dot{x1}(t) = x1(t),\n')
fprintf('   dot{x1}(t) = u(t), |u(t)| <= umax,\n')
fprintf('   \n')
fprintf('   x(t0) = x0,\n')
fprintf('   x(tf) = xf,\n')
fprintf('   \n')
fprintf('   t0 = 0, tf = 3, x0 = (-1,0), xf = (0,0), umax = 1, lambda in [0, 1[.\n')
fprintf('   \n')

% Definition des parametres : par = [t0, tf, x0, xf, umax, lambda]
% Et du tspan
%
t0      = 0.0;
tf      = 3.0;
x0      = [-1.0; 0.0];
xf      = [ 0.0; 0.0];
umax    = 1.0;
lambda  = 0.0;
par     = [t0; tf; x0; xf; umax; lambda];

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

disp(tirets); fprintf('\n Résolution du problème de contrôle optimal via la méthode de tir simple indirect : \n\n');

p0_guess = [0.5; 0.5];              % prediction du vecteur adjoint initial

% avec HamPath
fprintf('\n Avec HamPath \n');
[ p0sol, Ssol, nSev, njev, flag] = ssolve(p0_guess, options, par);

if(flag~=1) error('Pb de convergence lors du tir !'); end;

fprintf('\n');
fprintf(['      Initial guess                 : p0_guess = [%g, %g]\n'], p0_guess);
fprintf(['      Solution trouvée              : p0       = [%g, %g]\n'], p0sol);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g, %g]\n'], Ssol);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], nSev);

%
disp('Appuyer sur une touche pour continuer...'); pause;

% avec fsolve de Matlab
fprintf('\n Avec fsolve de Matlab \n');
myfun                       = @(y) sfunjac(y, options, par);
tolX                        = hampathget(options,'TolX');
optionsNLE                  = optimoptions( 'fsolve', 'display', 'iter', 'Algorithm', 'levenberg-marquardt', 'StepTolerance', tolX );
[p0solMatlab, SsolMatlab, exitflag, output]    = fsolve(myfun, p0_guess , optionsNLE);

fprintf('\n');
fprintf(['      Initial guess                 : p0_guess = [%g, %g]\n'], p0_guess);
fprintf(['      Solution trouvée              : p0       = [%g, %g]\n'], p0solMatlab);
fprintf(['      Valeur de la fonction de tir  : S(p0)    = [%g, %g]\n'], SsolMatlab);
fprintf(['      Nombre évaluations de S       : nSev     = %i\n\n'], output.funcCount);

%
disp('Appuyer sur une touche pour continuer...'); pause;

%-------------------------------------------------------------------------------------------------------------
% Homotopie
%-------------------------------------------------------------------------------------------------------------
%
%

par0 = par;
parf = par;
iumax   = 7;
ilambda = 8; % homotopie sur lambda et umax en meme temps
par0(iumax)     = 1e3;
parf(ilambda)   = 1.0-4e-2;
parspan = [par0 parf];
[parout,yout,sout,viout,dets,normS,ps,flag] = hampath(parspan,p0sol,options);

if(flag~=1) error('Pb de convergence lors de l''homotopie !'); end;

%-------------------------------------------------------------------------------------------------------------
% Informations pour le tir multiple pour le pb min L1
%-------------------------------------------------------------------------------------------------------------
%
%

disp(tirets); fprintf('\n Informations pour le tir multiple pour le pb min L1 : \n\n');

par     = parout(:,end);
p0      = yout(:,end);
z0      = [x0; p0];
tspan   = linspace(t0, tf, 1e4);

[ tout, z, flag ] = exphvfun(tspan, z0, options, par);

psi     = abs(z(n+2,:))-1.0;
I       = find(psi(2:end).*psi(1:end-1)<0);

if(length(I)~=2)
    error('abs(p2) doit prendre la valeur 1 deux fois !');
end
t1      = tspan(I(1));
t2      = tspan(I(2));

fprintf(['      Structure               : u=+1, u=0, u=-1 \n']);
fprintf(['      vecteur adjoint initial : p0 = [%g, %g]\n'], p0);
fprintf(['      Commutation             : t1 = %g\n'], t1);
fprintf(['      Commutation             : t2 = %g\n'], t2);
fprintf('\n');

%
disp('Appuyer sur une touche pour continuer...'); pause;

%-------------------------------------------------------------------------------------------------------------
% Visualisation de trajectoires issues de l'homotopie
%-------------------------------------------------------------------------------------------------------------
%
%

disp(tirets); fprintf('\n Visualisation de la solution \n\n');

%-------------------------------------------------------------------------------------------------------------
figRes = figure('units','normalized'); % Visualisation
nbFigs = {2,2};

% on affiche les courbes de commutations : gamma_- et gamma_+
subplot(nbFigs{:},1); hold on;
x2       = linspace(0.0, 1.5, 100);
x1_moins = -0.5*x2.^2;
x1_plus  =  0.5*x2.^2;
plot(x1_moins, x2, 'g--', 'LineWidth', 1.0);
plot(x1_plus, -x2, 'r--', 'LineWidth', 1.0);

% les trajectories
tspan   = linspace(t0, tf, 1e2);
lambdas = [0.0 0.3 0.6 1.0];

for lambda = lambdas

    [vv, ii] = min(abs(parout(ilambda,:)-lambda));
    par     = parout(:,ii);
    p0      = yout(:,ii);

    z0          = [x0; p0];
    [ tout, z, flag ] = exphvfun(tspan, z0, options, par);

    % calcul du contrôle
    u = control(tout, z, par);

    % la trajectoire dans le plan de phase
    subplot(nbFigs{:},1);
    plot(z(1,:), z(2,:), 'LineWidth', LW);
    if(lambda==lambdas(1))
        hold on;
        axis([-1.2 0.2 -0.2 0.6]);
    end

    % controle et vecteur adjoint
    subplot(nbFigs{:},2);
    if(lambda==lambdas(1))
        hold on; xlim([tout(1) tout(end)]);
        daxes(0, umax, 'k--');
        daxes(0, 0, 'k--');
        daxes(0, -umax, 'k--');
    end
    plot(tout, u, 'LineWidth', LW);

    % p1
    subplot(nbFigs{:},3);
    if(lambda==lambdas(1))
        hold on; xlim([tout(1) tout(end)]);
    end
    plot(tout, z(n+1,:), 'LineWidth', LW);

    % p2
    subplot(nbFigs{:},4);
    if(lambda==lambdas(1))
        hold on;
    xlim([tout(1) tout(end)]);
    ylim([-1.5 1.5]);
    daxes(0, -1, 'k--');
    daxes(0, 0, 'k--');
    daxes(0, 1, 'k--');
    end
    plot(tout, z(n+2,:), 'LineWidth', LW);

end

% Les legendes et labels
subplot(nbFigs{:},1); daxes(0,0,'k--');
subplot(nbFigs{:},1); xlabel('x_1'); ylabel('x_2');
subplot(nbFigs{:},2); xlabel('t'); ylabel('u');
subplot(nbFigs{:},3); xlabel('t'); ylabel('p_1');
subplot(nbFigs{:},4); xlabel('t'); ylabel('p_2');

