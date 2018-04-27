function output = getTimeMinDistL2(T_CR3BP, Q_CR3BP)

% Get the time corresponding to the minimum distance between the spacecraft
% (trajectoriy computed by DriftCompare) and the point L2.

UC = get_Univers_Constants();

L2_position = [UC.xL2; 0.0; 0.0];

position_spacecraft = Q_CR3BP(1:3,:);

diff = position_spacecraft - L2_position;

[position_min, I] = min(diff);

time_min = T_CR3BP(I(1));



