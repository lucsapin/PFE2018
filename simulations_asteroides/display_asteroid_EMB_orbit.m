% Script to show asteroid and EMB orbit

% ----------------------------------------------------------------------------------------------------
clear all;
close all;

set(0,  'defaultaxesfontsize'   ,  26     , ...
    'DefaultTextVerticalAlignment'  , 'bottom', ...
    'DefaultTextHorizontalAlignment', 'left'  , ...
    'DefaultTextFontSize'           ,  32     , ...
    'DefaultFigureWindowStyle','docked');

format shortE;
addpath('tools/');

% ----------------------------------------------------------------------------------------------------
% Load the 4258 asteroid's orbital parameters
% Are there in the Heliocentric referentiel ?
%
load('bdd/bdd_asteroids_oribtal_params');

% ----------------------------------------------------------------------------------------------------
DC          = get_Display_Constants(); % Display constants
UC          = get_Univers_Constants(); % Univers constants

% ----------------------------------------------------------------------------------------------------
% Figure for the space
hFigSpace   = figure('DefaultAxesColor', DC.color_Space); hold on; axis equal;

% ----------------------------------------------------------------------------------------------------
% Display sun
position_sun = [0.0 0.0 0.0]; display_sun(position_sun);

% ----------------------------------------------------------------------------------------------------
% Current date to visualize the position of the EMB and Asteroid
%
current_date = UC.epoch_t0 + 100;

% ----------------------------------------------------------------------------------------------------
% Asteroid's orbit
% ----------------------------------------------------------------------------------------------------
numAsteroid             = 1;
xOrb_t0_Ast             = get_Ast_init_Orbital_elements(asteroids_orbital_params, numAsteroid); % Initial orbital elements
[orbit_Ast, period_Ast] = get_Orbit(xOrb_t0_Ast);

plot3(orbit_Ast(1,:), orbit_Ast(2,:), orbit_Ast(3,:), 'Color', DC.color_Ast, 'LineWidth', DC.LW); hold on;

% Display initial and current asteroid's position at current_date
initial_state_Ast = get_Current_State_Cart(xOrb_t0_Ast, UC.epoch_t0) ; display_asteroid(initial_state_Ast(1:3), 'epoch_t0');
current_state_Ast = get_Current_State_Cart(xOrb_t0_Ast, current_date); display_asteroid(current_state_Ast(1:3), 'current');

% ----------------------------------------------------------------------------------------------------
% EMB's orbit
% ----------------------------------------------------------------------------------------------------
xOrb_t0_EMB             = get_EMB_init_Orbital_elements();  % Initial orbital elements
[orbit_EMB, period_EMB] = get_Orbit(xOrb_t0_EMB);

% Display EMB's trajectory
plot3(orbit_EMB(1,:), orbit_EMB(2,:), orbit_EMB(3,:), 'Color', DC.color_EMB, 'LineWidth', DC.LW); hold on;

% Display current EMB's position at current_date
initial_state_EMB = get_Current_State_Cart(xOrb_t0_EMB, UC.epoch_t0) ; display_EMB(initial_state_EMB(1:3), 'epoch_t0');
current_state_EMB = get_Current_State_Cart(xOrb_t0_EMB, current_date); display_EMB(current_state_EMB(1:3), 'current');

% ----------------------------------------------------------------------------------------------------
% L2's orbit
% ----------------------------------------------------------------------------------------------------
mu0_L2       = UC.mu0EMB + UC.mu0Earth + UC.mu0Moon;           % km^3/s^2 
[~, ~, q_epoch_t0_L2_EMB_LD] = get_Moon_Earth_L2_State_Cart_LD(UC.epoch_t0);
q_epoch_t0_EMB_SUN_AU = Orb2Cart(UC.mu0EMB, xOrb_t0_EMB);
q_epoch_t0_L2_SUN_AU = q_epoch_t0_EMB_SUN_AU + q_epoch_t0_L2_EMB_LD*UC.LD/UC.AU;
xOrb_epoch_t0_L2 = Cart2Orb(mu0_L2, q_epoch_t0_L2_SUN_AU);
[orbit_L2, period_L2] = get_Orbit(xOrb_epoch_t0_L2);

% Display L2's orbit
plot3(orbit_L2(1,:), orbit_L2(2,:), orbit_L2(3,:), 'Color', DC.color_L2, 'LineWidth', DC.LW); hold on;

% Display initial L2's position at t0 and t0+dt1+dtf
q0_L2   = get_Current_State_Cart(xOrb_epoch_t0_L2, UC.epoch_t0)     ; display_L2(q0_L2(1:3), 'return_t0');
qf_L2   = get_Current_State_Cart(xOrb_epoch_t0_L2, current_date)    ; display_L2(qf_L2(1:3), 'current');

% ----------------------------------------------------------------------------------------------------
% Moon's orbit
% % ----------------------------------------------------------------------------------------------------
% q_epoch_t0_Moon_SUN_AU = q_epoch_t0_EMB_SUN_AU + q_epoch_t0_Moon_EMB_LD*UC.LD/UC.AU;
% xOrb_epoch_t0_Moon = Cart2Orb(UC.mu0Moon, q_epoch_t0_Moon_SUN_AU);
% [orbit_Moon, period_Moon] = get_Orbit(xOrb_epoch_t0_Moon);
% plot3(orbit_Moon(1,:), orbit_Moon(2,:), orbit_Moon(3,:), 'Color', DC.color_Moon, 'LineWidth', DC.LW); hold on;
display_Moon();

