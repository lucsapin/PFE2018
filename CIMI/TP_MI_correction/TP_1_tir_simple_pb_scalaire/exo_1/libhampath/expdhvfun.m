function [tout,z,dz,flag,varargout] = expdhvfun(tspan,z0,dz0,varargin)
%-------------------------------------------------------------------------------------------
%
%    expdhvfun (needs hfun.f90)
%
%    Description
%
%        Computes the chronological exponential of the variational system associated to hv.
%
%    Options used
%
%        Derivative, MaxStepsOde, MaxStepSizeOde, ODE, TolOdeAbs, TolOdeRel
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [tout,z,dz,flag] = expdhvfun(tspan, z0, dz0,     options, par) : single arc
%        [tout,z,dz,flag] = expdhvfun(tspan, z0, dz0, ti, options, par) : multiple arcs
%
%    Inputs
%
%        tspan   - real row vector, tspan = [tspan1 tspan2 ... tspanf] must be sorted and
%                    included in ti, if any.
%        z0      - real vector, initial flow
%        dz0     - real matrix, initial Jacobi fields
%        ti      - real row vector, in multiple shooting case ti = [t0 t1 ... t_nbarc-1 tf]
%                    must be increasing.
%        options - struct vector, hampathset options
%        par     - real vector, parameters given to hfun par=[] if no parameters
%
%    Outputs
%
%        tout    - real row vector, time at each integration step
%        z       - real matrix, flow at time tout
%        dz      - real matrix, Jacobi fields at time tout
%        flag    - integer, flag should be 1 (ODE integrator output)
%
%-------------------------------------------------------------------------------------------
nrhs0min = 5;
if(nargin<nrhs0min || nargin>nrhs0min+1 || nargout>5 || nargout<4)
    error('wrong syntax: try help');
end

if(nargin==nrhs0min)
    ti =[tspan(1) tspan(end)];
    options=varargin{1};
    par=varargin{2};
elseif(nargin==nrhs0min+1)
    ti=varargin{1};
    options=varargin{2};
    par=varargin{3};
end

value   = hampathget(options,'getoptionsformex');
dw      = value.dw;
iw      = value.iw;
sw      = value.sw;
lsw     = value.lsw;

%try
    [tout,z,dz,flag,nfev]  = expdhvfun_m(tspan,z0,dz0,par,ti,dw,iw,sw,lsw);
%catch err
%    error('Problem during execution!');
%end

if(nargout==5)
    varargout{1} = nfev;
end;


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
