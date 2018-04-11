function value = hybrdget(options, name)
% hybrdget -- Gets hybrd options.
%
%  Usage
%    value = hybrdget(options, name)
%
%  Inputs
%    options struct, options
%    name    string, option name
%
%  Outputs
%    value   any, option value
%
%  See help hybrdset for options description
%
%  See also
%    hybrd, hybrdset
%
if(nargout~=1)
error('wrong number of outputs: try help');
end

switch lower(name)
  case 'xtol'
    value = options.xTol;
  case 'maxfev'
    value = options.MaxFev;
  case 'ml'
    value = options.ml;
  case 'mu'
    value = options.mu;
  case 'epsfcn'
    value = options.EpsFcn;
  case 'diag'
    value = options.diag;
  case 'mode'
    value = options.mode;
  case 'factor'
    value = options.factor;
  case 'display'
    value = options.display;
  otherwise
    error(sprintf('Unrecognized property name ''%s''.', name));
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
