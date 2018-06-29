%script to plot the 3link Purcell swimmer
function [swimx,swimy] = compute_swimmer(x,y,theta,beta1,beta3)

% L1 = 1; L2 = 2; L3 = 1;

%N2 - N3 (central link)
x2 = x + cos(pi+theta);
y2 = y + sin(pi+theta);
x3 = x + cos(theta);
y3 = y + sin(theta);

%N1 (first link)
x1 = x2 + cos(pi+theta-beta1);
y1 = y2 + sin(pi+theta-beta1);

%N4 (third link)
x4 = x3 + cos(theta+beta3);
y4 = y3 + sin(theta+beta3);

swimx = [x1 x2 x3 x4];
swimy = [y1 y2 y3 y4];

end