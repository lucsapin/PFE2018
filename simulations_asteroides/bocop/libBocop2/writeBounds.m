function [] = writeBounds(dims,bounds,path)

fid = fopen(path,'w+');
fprintf(fid,'# This file contains all the bounds of your problem.\n');
fprintf(fid,'# Bounds are stored in standard format :\n# [lower bound]  [upper bound] [type of bound]\n\n');
fprintf(fid,'# Dimensions (boundary conditions, state, control, algebraic \n');
fprintf(fid,'# variables, optimization parameters, path constraints) : \n');
labels={'boundarycond', 'state', 'control', 'algebraic', 'parameter', 'constraint'};

dimensions = zeros(1,length(labels));
for i=1:length(labels)
    label = labels{i};
    if (i == 1)
        dimensions(i) = dims.(label);
    else
        dimensions(i) = dimensions(i-1) + dims.(label);
    end
    fprintf(fid,'%d ',dims.(label));
end
fprintf(fid,'\n\n');

fprintf(fid,'# Bounds for the initial and final conditions : \n');
dim_bounds = size(bounds,1);
for i=1:dim_bounds
    lb = bounds(i,1);
    ub = bounds(i,2);
    if (lb == ub)
        type = 'equal';
    elseif (lb == -2e20 && ub == 2e20)
        lb = 0;
        ub = 0;
        type = 'free';
    elseif (lb > -2e20 && ub < 2e20)
        type = 'both';
    elseif (lb > -2e20)
        type = 'lower';
    else
        type = 'upper';
    end
    fprintf(fid,'%s %s %s\n',num2str(lb),num2str(ub),type);
    
    if (i == dimensions(1))
        fprintf(fid,'\n');
        fprintf(fid,'# Bounds for the state variables : \n');
    end

    if (i == dimensions(2))
        fprintf(fid,'\n');
        fprintf(fid,'# Bounds for the control variables : \n');
    end

    if (i == dimensions(3))
        fprintf(fid,'\n');
        fprintf(fid,'# Bounds for the algebraic variables : \n');
    end

    if (i == dimensions(4))
        fprintf(fid,'\n');
        fprintf(fid,'# Bounds for the optimization parameters : \n');
    end
    
    if (i == dimensions(5))
        fprintf(fid,'\n');
        fprintf(fid,'# Bounds for the path constraints : \n');
    end
end

