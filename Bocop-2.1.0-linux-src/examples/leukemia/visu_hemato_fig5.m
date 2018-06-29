% Visualization - hemtao problem
% Pierre Martinon
% Inria Saclay and Cmap Ecole Polytechnique,
% 2017

clear all; 
close all;

% read solution
verbose = 0;
path = input('Solution file path (default: problem.sol): ','s');
if isempty(path)
    path = 'problem.sol';
end
[dim_state,dim_control,dim_algebraic,dim_optimvars,dim_constant,...
    dim_boundarycond,dim_pathcond,time_steps,...
    time,stage,state,control,control_average,algebraic,constants,optimvars,...
    state_lb,state_ub,control_lb,control_ub,...
    boundarycond,boundarycond_lb,boundarycond_ub,...
    path_constraint, pathcond_lb,pathcond_ub,...
    dynamic_constraint,...
    adjoint,pathconstraint_mult,zl_state,zu_state,zl_control,zu_control,...
    objective,constraints_Infnorm,iterations] = readsolfile2(path,verbose);

% state and control
R = state(:,1);
P = state(:,8);
P2 = state(:,9);
u = control_average(:,1)*constants(6);
v = control_average(:,2)*constants(7);

% plot Fig5
figure()
hold on
xlabel('TIME (DAYS)');
ylabel('DRUGS (day^-1) / CELL POPULATION (10^5 CELLS)');
plot(time(1:end-1),u,'r','LineWidth',2)
plot(time(1:end-1),v,'g','LineWidth',2)
plot(time,P2/1e5,'k','LineWidth',2) %non weighted
legend('CYTOTOXIC u','CYTOSTATIC v','CELLS P2')