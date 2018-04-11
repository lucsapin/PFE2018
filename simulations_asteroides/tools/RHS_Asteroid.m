function state_dot_cart = RHS_Asteroid(t,state,par)

% Dynamique à 2 corps
%
mu                  = par(1);
state_dot_cart      = zeros(6,1);
state_dot_cart(1:3) = state(4:6);
state_dot_cart(4:6) = -mu*state(1:3)/(norm(state(1:3))^3);

return
