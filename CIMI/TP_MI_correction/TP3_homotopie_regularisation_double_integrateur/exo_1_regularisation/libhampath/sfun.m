function s  = sfun(y,options,par)
%-------------------------------------------------------------------------------------------
%
%    sfun (needs sfun.f90)
%
%    Description
%
%        Computes the shooting function
%
%    Options used
%
%        FreeFinalTime, MaxStepsOde, MaxStepSizeOde, ODE, TolOdeAbs, TolOdeRel
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        s = sfun(y,options,par)
%
%    Inputs
%
%        y       - real vector, shooting variable
%        options - struct, hampathset options
%        par     - real vector, par in hfun and sfun, par=[] if no parameters
%
%    Outputs
%
%        s       - real vector, shooting value
%
%-------------------------------------------------------------------------------------------
if(nargin~=3 || nargout>1)
    error('wrong syntax: try help');
end

value   = hampathget(options,'getoptionsformex');
dw      = value.dw;
iw      = value.iw;
sw      = value.sw;
lsw     = value.lsw;

%try
    s = sfun_m(y,par,dw,iw,sw,lsw);
%catch err
%    error('Problem during execution!');
%end


%% -----------------------------------------------------------------------------
%%
%% Copyright 2016, Olivier Cots.
%%
%% This file is part of HamPath.
%%
%% HamPath is free software: you can redistribute it and/or modify
%% it under the terms of the GNU Lesser General Public License as published by
%% the Free Software Foundation, either version 3 of the License, or
%% (at your option) any later version.
%%
%% HamPath is distributed in the hope that it will be useful,
%% but WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%% GNU Lesser General Public License for more details.
%%
%% You should have received a copy of the GNU Lesser General Public License
%% along with HamPath. If not, see <http://www.gnu.org/licenses/>.
%%
%% -----------------------------------------------------------------------------
%%
