function [ ysol, ssol, nfev, njev, flag] = ssolve(y0,options,par)
%-------------------------------------------------------------------------------------------
%
%    ssolve (needs sfun.f90)
%
%    Description
%
%        Interface of the Fortran non linear solver (hybrj) to solve the optimal
%        control problem described by the Fortran subroutines.
%
%    Options used
%        Derivative, Display, FreeFinalTime, MaxFEval, MaxStepsOde, MaxStepSizeOde, ODE,
%        SolverMethod, TolOdeAbs, TolOdeRel, TolX
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [ysol,ssol,nfev,njev,flag] = ssolve(y0,options,par)
%
%    Inputs
%
%        y0      - real vector, intial guess for shooting variable
%        options - struct vector, hampathset options
%        par     - real vector, par in hfun and sfun, par=[] if no parameters
%
%    Outputs
%
%        ysol    - real vector, shooting variable solution
%        ssol    - real vector, value of sfun at ysol
%        nfev    - integer, number of evaluations of sfun
%        njev    - integer, number of evaluations of sjac
%        flag    - integer, solver output (should be 1)
%
%-------------------------------------------------------------------------------------------
if(nargin~=3 || nargout~=5)
    error('wrong syntax: try help');
end

value   = hampathget(options,'getoptionsformex');
dw      = value.dw;
iw      = value.iw;
sw      = value.sw;
lsw     = value.lsw;

%try
    gfortranMatlab(1);
    [ ysol, ssol, nfev, njev, flag] = ssolve_m(y0,par,dw,iw,sw,lsw);
    gfortranMatlab(2);
%catch err
%    gfortranMatlab(2);
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
