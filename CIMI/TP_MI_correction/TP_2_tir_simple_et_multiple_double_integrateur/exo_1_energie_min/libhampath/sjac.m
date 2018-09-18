function j = sjac(y,options,par,ipar)
%-------------------------------------------------------------------------------------------
%
%    sjac (needs sfun.f90)
%
%    Description
%
%        Computes the Jacobian of the shooting-homotopic function
%
%    Options used
%
%        Derivative, FreeFinalTime, MaxStepsOde, MaxStepSizeOde, ODE, TolOdeAbs,
%        TolOdeRel
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        j = sjac(y,options,par)
%        j = sjac(y,options,par,ipar)
%
%    Inputs
%
%        y       - real vector, shooting variable
%        options - struct, hampathset options
%        par     - real vector, par in hfun and efun, par=[] if no parameters
%        ipar    - integer vector, index of parameters for which the derivative is computed
%
%    Outputs
%
%        j       - real matrix, jacobian of the shooting/homotopic function
%
%-------------------------------------------------------------------------------------------
nrhs0min = 3;
if(nargin<nrhs0min || nargin>nrhs0min+1 || nargout>1)
    error('wrong syntax: try help');
end

if(nargin==nrhs0min)
    ipar=[];
else
    nmin=min(ipar);
    nmax=max(ipar);
    if(nmin<1)
        error('ipar must contain values between 1 and length(par)');
    end
    if(nmax>length(par))
        error('ipar must contain values between 1 and length(par)');
    end
end

value   = hampathget(options,'getoptionsformex');
dw      = value.dw;
iw      = value.iw;
sw      = value.sw;
lsw     = value.lsw;

%try
    j = sjac_m(y,par,ipar,dw,iw,sw,lsw);
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
