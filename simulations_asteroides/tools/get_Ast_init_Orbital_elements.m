function [xOrb, period] = get_Ast_init_Orbital_elements(asteroids_orbital_params, numAsteroid)

% We assume we want the orbital elements in the Heliocentric referentiel
xOrb    = asteroids_orbital_params(:,numAsteroid);

return
