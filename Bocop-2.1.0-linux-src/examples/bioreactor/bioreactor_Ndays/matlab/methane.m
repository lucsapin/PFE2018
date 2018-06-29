% draw methane solution in 2x2 format - [y s; x u]

figure

subplot(2,2,1)
plot(time,state(:,1),'k','LineWidth',2)
%xlabel('TIME','FontSize',16)
title('MICROALGAE(Y)','FontSize',20)
ax=axes
set(ax,'FontSize',20)

subplot(2,2,2)
plot(time,state(:,2),'k','LineWidth',2)
%xlabel('TIME','FontSize',16)
title('SUBSTRATE(S)','FontSize',20)

subplot(2,2,3)
plot(time,state(:,3),'k','LineWidth',2)
%xlabel('TIME','FontSize',16)
title('BIOMASS(X)','FontSize',20)

subplot(2,2,4)
plot(time(1:end-1),control_average(:,1),'k','LineWidth',2)
%xlabel('TIME','FontSize',16)
title('INPUT FLOW(U)','FontSize',20)