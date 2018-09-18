function [s,j] = sfunjac(y,options,par)

    s = sfun(y,options,par);
    if(nargout>1)
        j = sjac(y,options,par);
    end

return
