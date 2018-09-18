function options = hybrdset(varargin)
% hybrdset -- Sets hybrd options.
%
%  Usage
%    options = hybrdset(name1, value1, ...)
%
%  Inputs
%    name1   string, option name
%    value1  any, option value
%    ...
%
%  Outputs
%    options struct, options
%
%  Description
%    Options are:
%      xTol   - Relative tolerance between iterates      [        1e-8 ]
%      MaxFev - Max number of function evaluations       [ 800 x (n+1) ]
%      ml     - Number of banded Jacobian subdiagonals   [         n-1 ]
%      mu     - Number of banded Jacobian superdiagonals [         n-1 ]
%      EpsFcn - Used for FD step length computation      [           0 ]
%      diag   - Used for scaling if mode = 2             [  [1 ... 1]' ]
%      mode   - Automatic scaling if 1, manual if 2      [           1 ]
%      factor - Used for initial step bound              [         1e2 ]
%      display- Display or not intermediate information  [{'on'}, 'off']
%
%  See also
%    hybrd, hybrdget
%
if(nargout~=1)
error('wrong number of outputs: try help');
end

options.xTol   = 1e-8;
options.MaxFev = []  ;
options.ml     = []  ;
options.mu     = []  ;
options.EpsFcn = 0   ;
options.diag   = []  ;
options.mode   = 1   ;
options.factor = 1e2 ;
options.display= 'on';

if (mod(nargin, 2) ~= 0)
  error('Not enough input arguments.');
end;

n = nargin / 2;
for i = 1:n
  switch lower(varargin{1+2*(i-1)})
    case 'xtol'
      options.xTol = varargin{2+2*(i-1)};
    case 'maxfev'
      options.MaxFev = varargin{2+2*(i-1)};
    case 'ml'
      options.ml = varargin{2+2*(i-1)};
    case 'mu'
      options.mu = varargin{2+2*(i-1)};
    case 'epsfcn'
      options.EpsFcn = varargin{2+2*(i-1)};
    case 'diag'
      options.diag = varargin{2+2*(i-1)};
    case 'mode'
      options.mode = varargin{2+2*(i-1)};
    case 'factor'
      options.factor = varargin{2+2*(i-1)};
    case 'display'
      options.display = varargin{2+2*(i-1)};
    otherwise
      error(sprintf('Unknown option: %s.', varargin{1+2*(i-1)}));
  end; 
end;

 % Written on Fri Oct  1 11:05:34 CEST 2004 
 % by Jean-Baptiste Caillau - ENSEEIHT-IRIT (UMR CNRS 5505)
 %

%% -----------------------------------------------------------------------------
%%
%% Copyright 2016, Olivier Cots, Jean-Baptiste Caillau.
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
