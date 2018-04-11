function names = NamesDefFile(name_state,name_control,name_par,name_boundary,name_opti)
   
    names = {};
    
    for i = 1:length(name_state)
        names(end+1) = {['state.',num2str(i-1),' string ',name_state{i}]};
    end
    
    for j = 1:length(name_control)
        names(end+1) = {['control.',num2str(j-1),' string ',name_control{j}]};
    end

    for m = 1:length(name_opti)
        names(end+1) = {['parameter.',num2str(m-1),' string ',name_opti{m}]};
    end

    for k = 1:length(name_boundary)
        names(end+1) = {['boundarycond.',num2str(k-1),' string ',name_boundary{k}]};
    end
    
    for l = 1:length(name_par)
        names(end+1) = {['constant.',num2str(l-1),' string ',name_par{l}]};
    end


	
end
