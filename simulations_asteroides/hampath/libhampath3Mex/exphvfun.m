function [ tout, z, flag, varargout ]  = exphvfun(arg1,arg2,arg3,arg4,arg5)
%-------------------------------------------------------------------------------------------
%
%    exphvfun (needs hfun.f90)
%
%    Description
%
%        Computes the chronological exponential of the Hamiltonian vector field hv
%        defined by h.
%
%    Options used
%
%        MaxStepsOde, MaxStepSizeOde, ODE, TolOdeAbs, TolOdeRel
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [tout,z,flag ] = exphvfun(tspan, z0,     options, par) : single arc
%        [tout,z,flag ] = exphvfun(tspan, z0, ti, options, par) : multiple arcs
%
%    Inputs
%
%        tspan   - real row vector, tspan = [tspan1 tspan2 ... tspanf] must be sorted and
%                    included in ti, if any.
%        z0      - real vector, initial flow
%        ti      - real row vector, in multiple shooting case ti = [t0 t1 ... t_nbarc-1 tf]
%                    must be increasing.
%        options - struct vector, hampathset options
%        par     - real vector, parameters given to hfun par=[] if no parameters
%
%    Outputs
%
%        tout    - real row vector, time at each integration step
%        z       - real matrix, z(:,i) : flow at tout(i)
%        flag    - integer, flag should be 1 (ODE integrator output)
%
%-------------------------------------------------------------------------------------------
nrhs0min = 4;
if(nargin<nrhs0min || nargin>nrhs0min+1 || nargout>4 || nargout<3)
    error('wrong syntax: try help');
end

tspan=arg1;
z0=arg2;
if(nargin==nrhs0min)
    ti =[tspan(1) tspan(end)];
    options=arg3;
    par=arg4;
elseif(nargin==nrhs0min+1)
    ti=arg3;
    options=arg4;
    par=arg5;
end

value   = hampathget(options,'getoptionsformex');
dw      = value.dw;
iw      = value.iw;
sw      = value.sw;
lsw     = value.lsw;

%try
    [tout,z,flag,nfev]  = exphvfun_m(tspan,z0,par,ti,dw,iw,sw,lsw);
%catch err
%    error('Problem during execution!');
%end

if(nargout==4)
    varargout{1} = nfev;
end


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
