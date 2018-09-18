function [ x, y, iflag, nfev ] = hybrd(nlefun, x0, options, varargin)
% hybrd -- Hybrid Powell method.
%
%  Usage
%    [ x, y, iflag, nfev ] = hybrd(nlefun, x0, options, p1, ...)
%
%  Inputs
%    nlefun  string, function y = nlefun(x, p1, ...)
%    x0      real vector, initial guess
%    options struct vector, options
%    p1      any, optional argument passed to nlefun
%    ...
%
%  Outputs
%    x       real vector, zero
%    y       real vector, value of nlefun at x
%    iflag   integer, hybrd solver output (should be 1)
%    nfev    number of evaluations of nlefun
%
%  Description
%    Matlab interface of Fortran hybrd. Function nlefun must return
%    a column vector.
%
%  See also
%    hybrdset, hybrdget
%
if(nargout~=4)
error('wrong number of outputs: try help');
end

[ n, N ] = size(x0);
opt = options;
if isempty(opt.MaxFev)
  opt.MaxFev = 800 * (n+1);
end;
if isempty(opt.ml)
  opt.ml = n-1;
end;
if isempty(opt.mu)
  opt.mu = n-1;
end;
if isempty(opt.diag)
  opt.diag = ones(n, 1);
end;

switch lower(opt.display)
    case 'on'
        dsp = 1.0;
    case 'off'
        dsp = 0.0;
    otherwise
      error('display option must be ''on'' or ''off''!');
end;

x = [];
for i = 1:N
  [ xi, y, iflag, nfev ] = hybrd_m(nlefun    , ...
                                   x0(:, i)  , ...
                                   opt.xTol  , ...
 		   		           opt.MaxFev, ...
				           opt.ml    , ...
				           opt.mu    , ...
				           opt.EpsFcn, ...
				           opt.diag  , ...
				           opt.mode  , ...
				           opt.factor, ...
                                           dsp, ...
                                   varargin{:});
  x = [ x xi ];
end;

 % Written on Sun Oct  3 17:51:35 CEST 2004 
 % by Jean-Baptiste Caillau - ENSEEIHT-IRIT (UMR CNRS 5505)

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
