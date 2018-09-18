function gfortranMatlab(cas)

global MATLAB_LD_LIBRARY_PATH

if(nargin==0)
  error('Wrong syntax!');
end;

if(cas==1)

setenv('GFORTRAN_STDIN_UNIT','5');
setenv('GFORTRAN_STDOUT_UNIT','6');
setenv('GFORTRAN_STDERR_UNIT','0');
%
% Library du au message
MATLAB_LD_LIBRARY_PATH = getenv('LD_LIBRARY_PATH');
HAMPATH_LD_LIBRARY_PATH = ['/usr/lib/x86_64-linux-gnu:' MATLAB_LD_LIBRARY_PATH];
setenv('LD_LIBRARY_PATH', HAMPATH_LD_LIBRARY_PATH);

else

setenv('GFORTRAN_STDIN_UNIT','-1');
setenv('GFORTRAN_STDOUT_UNIT','-1');
setenv('GFORTRAN_STDERR_UNIT','-1');

setenv('LD_LIBRARY_PATH', MATLAB_LD_LIBRARY_PATH)

end;

return
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
