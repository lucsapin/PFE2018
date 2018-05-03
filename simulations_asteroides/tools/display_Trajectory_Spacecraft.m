function display_Trajectory_Spacecraft(states, etat)

%h       = gcf; figure(hFigSpace);

DC      = get_Display_Constants();

if strcmp(etat, 'outbound')
    plot3(states(1,:), states(2,:), states(3,:), 'Color', DC.color_SC, 'LineWidth', DC.LW); hold on;
elseif strcmp(etat, 'return')
    plot3(states(1,:), states(2,:), states(3,:), 'Color', DC.color_SC, 'LineWidth', DC.LW); hold on;
elseif strcmp(etat, 'return_compare')
    plot3(states(1,:), states(2,:), states(3,:), 'Color', DC.color_SC, 'LineWidth', DC.LW, 'LineStyle', '--'); hold on;
else
    error('Wrong argument to display the spacecraft');
end

%figure(h);

return
