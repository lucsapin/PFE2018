function [] = writeDefFile(init,t0,tf,freetf,dims,disc_steps,disc_method,path,namesDef)
fid = fopen(path,'w+');

% write input data
fprintf(fid,'# This file defines all dimensions and parameters\n# values for your problem :\n');
fprintf(fid,'\n# Initial and final time :\ntime.free string %s\n',freetf);
fprintf(fid,'time.initial double %s\ntime.final double %s\n',t0,tf);
fprintf(fid,'\n# Dimensions :\n');

labels={'state', 'control', 'algebraic', 'parameter', 'constant','boundarycond','constraint'};
for i=1:length(labels)
    label = labels{i};
    fprintf(fid,'%s.dimension integer %d\n',label,dims.(label));
end

fprintf(fid,'\n# Discretization :\ndiscretization.steps integer %s\ndiscretization.method string %s\n\n'...
    ,disc_steps,disc_method);

% write fixed part
fixedpart = {'# Optimization :'
    'optimization.type string single'
    'batch.type integer 0'
    'batch.index integer 0'
    'batch.nrange integer 1'
    'batch.lowerbound double 0'
    'batch.upperbound double 0'
    'batch.directory string none'
    ''
    };

for line = fixedpart'
    fprintf(fid,'%s\n',line{1});
end

fprintf(fid,'# Initialization :\n');
fprintf(fid,'initialization.type string %s\n',init.type);
fprintf(fid,'initialization.file string %s\n',init.file);

fixedpart = {''
    '# Parameter identification :'
    'paramid.type string false'
    'paramid.separator string ,'
    'paramid.file string no_directory'
    'paramid.dimension integer 0'
    ''
    '# Names :'
    };

for line = fixedpart'
    fprintf(fid,'%s\n',line{1});
end

for i = 1:length(namesDef)
    fprintf(fid,'%s\n',namesDef{i});
end

fixedpart = {''
    '# Solution file :'
    'solution.file string problem.sol'
    ''
    '# Iteration output frequency :'
    'iteration.output.frequency integer 0'
    };

for line = fixedpart'
    fprintf(fid,'%s\n',line{1});
end

fclose(fid);

end
