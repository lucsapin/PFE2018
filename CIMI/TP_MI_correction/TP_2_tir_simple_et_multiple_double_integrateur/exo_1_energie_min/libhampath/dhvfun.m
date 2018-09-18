function [hv,dhv] = dhvfun(arg1,arg2,arg3,arg4,arg5)
%-------------------------------------------------------------------------------------------
%
%    dhvfun (needs hfun.f90)
%
%    Description
%
%        Computes the second member of the variational system associated to H.
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [hv, dhv] = dhvfun(t, z, dz,     par) : single arc
%        [hv, dhv] = dhvfun(t, z, dz, ti, par) : multiple arcs
%
%    Inputs
%
%        t    -  real row vector, t(i) = i-th time
%        z    -  real matrix, z(:,i) = i-th state and costate
%        dz   -  real matrix, dz(:,(i-1)*k+1:i*k) = the k i-th Jacobi fields
%        ti   -  real row vector, in multiple shooting case, ti = [t0 t1 ... t_nbarc-1 tf]
%        par  -  real vector, parameters given to hfun par=[] if no parameters
%
%    Outputs
%
%        hv   -  real matrix, hamiltonian vector field at time(s) t
%        dhv  -  real matrix, Linearized of the Hamiltonian vector field at time(s) t
%
%-------------------------------------------------------------------------------------------
nrhs0min = 4;
if(nargin<nrhs0min || nargin>nrhs0min+1 || nargout>2)
    error('wrong syntax: try help');
end

t=arg1;
z=arg2;
dz=arg3;
if(nargin==nrhs0min)
    ti =[t(1) t(end)];
    par=arg4;
elseif(nargin==nrhs0min+1)
    ti=arg4;
    par=arg5;
end

%try
    [hv, dhv] = dhvfun_m(t, z, dz, ti, par);
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
