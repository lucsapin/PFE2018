%script to plot the swimmer displacement, to execute after loading the
%solution with bocop.m

%retrieve state
coeff = 10;
x = coeff * state(:,1);
y = state(:,2);
theta = state(:,3);
beta1 = state(:,4);
beta3 = state(:,5);


%plot swimmer
f=figure

for i = 1:size(time)
    clf(f)
    axis([-5 2 -1 1])
    axis equal % ELSE STICK SIZES LOOK DEFORMED !!
    ax=axis;
    hold on
    [swimx,swimy] = compute_swimmer(x(i),y(i),theta(i),beta1(i),beta3(i));
    plot(swimx,swimy,'LineWidth',2);
    plot([x(i) x(i)],[ax(3) ax(4)],'--')
    M(i) = getframe;
end

%movie(M) save M
