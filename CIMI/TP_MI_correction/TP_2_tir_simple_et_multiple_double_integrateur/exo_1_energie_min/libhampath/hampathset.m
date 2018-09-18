function options = hampathset(varargin)
% hampathset -- Sets options for hampath packages.
%
% Usage
%  options = hampathset(name1, value1, ...)
%
% Or
%  options = hampathset(oldopts, name1, value1,...) 
%  creates a copy of oldopts with the named parameters altered
%  with the specified values.
%
% Inputs
%  name1   string, option name
%  value1  any, option value
%  ...
%
% Outputs
%  options struct, options
%
% Description - options names and default values are:
%
%  Derivative       - Derivation method.           [{'eqvar’},’finite’,’ind’]
%                     'finite' corresponds to finite differences.
%                     'eqvar'  corresponds to variational equations.
%                     ‘ind’    corresponds to internal numerical derivative.
%                     Used by expdhvfun (only ind and eqvar), 
%                     hampath, sjac, ssolve.
%
%  DispIter         - Display each mod(iter,DispIter)==0            [     1 ]
%                     Used by hampath.
%
%  Display          - Display results                       [ 'off' | {'on'}]
%                     Used by hampath, ssolve.
%
%  DoSavePath       - Save path in file "SavedPath(n).py" (python interface)
%                     or "SavedPath(n).m" (other interface) during homotopy
%                                                           [ {'off'} | 'on']
%                     Used by hampath.
%
%  MaxFEval         - Maximum number of calls to the function       [   2000]
%                     Used by ssolve.
%
%  MaxIterCorrection- Maximum number of iterations during correction [     7]
%                     Used by hampath.
%
%  MaxSf            - Maximum final arc length for hampath          [   1e5 ]
%                     Used by hampath.
%
%  MaxSfunNorm      - Maximal norm of the shooting function during homotopy.
%                     Used by hampath                               [   1e-1]
%
%  MaxStepsOde      - Maximum number of integration steps           [   1e5 ]
%                     Used by exp[d]hvfun, hampath, sfun, sjac, ssolve.
%
%  MaxStepsOdeHam   - Maximum number of homotopy steps              [   1e5 ]
%                     Used by hampath.
%
%  MaxStepSizeOde   - Maximum step size                             [     0 ]
%                     If equals 0 then the integrator 'ODE'
%                     has no constraint on the maximal step size.
%                     Used by exp[d]hvfun, hampath, sfun, sjac, ssolve.
%
%  MaxStepSizeOdeHam- Maximum step size during homotopy             [     0 ]
%                     If equals 0 then the integrator 'ODEHam'
%                     has no constraint on the maximal step size.
%                     Used by hampath.
%
%  MaxStepSizeHomPar- Maximum step size of homotopic parameter      [     0 ]
%                     during homotopy.
%                     If 0 then no constraint on the maximal step size.
%                     Used by hampath.
%
%  ODE              - Integrator name.
%
%                       - No step size control:
%
%                           - Explicit: 'rk4',
%                                       'rk5'
%                           - Implicit: 'gauss4',
%                                       'gauss6',
%                                       'gauss8',
%                                       'radaus' (symplectic radau of order 5)
%
%                       - With step size control:
%
%                            - Explicit: {'dopri5'} (default),
%                                        'dop853'
%
%                            - Implicit: 'radau5',
%                                        'radau9',
%                                        'radau13'
%                                        'radau' (adaptative order 5, 9 and 13)
%
%                     Used by exp[d]hvfun, hampath, sfun, sjac, ssolve.
%
%  ODEHam           - Integrator name for homotopy
%
%                       - With step size control:
%
%                            - Explicit: {'dopri5'} (default),
%                                        'dop853'
%
%                            - Implicit: 'radau5',
%                                        'radau9',
%                                        'radau13'
%                                        'radau' (adaptative order 5, 9 and 13)
%
%                     Used by hampath.
%
%  SolverMethod     - Type of solver                              [{'hybrj'}]
%                     Used by ssolve.
%
%  StopAtTurningPoint - Stop or not after turning point             [{0} | 1]
%                     Used by hampath.
%
%  TolOdeAbs        - Absolute error tolerance of the integrator    [ 1e-14 ]
%                     Used by exp[d]hvfun, hampath, sfun, sjac, ssolve.
%
%  TolOdeRel        - Relative error tolerance of the integrator    [  1e-8 ]
%                     Used by exp[d]hvfun, hampath, sfun, sjac, ssolve.
%
%  TolOdeHamAbs     - Absolute error tolerance for hampath          [ 1e-14 ]
%                     Used by hampath.
%
%  TolOdeHamRel     - Relative error tolerance for hampath          [  1e-8 ]
%                     Used by hampath.
%
%  TolDenseHamEnd   - Absolute Dense output tolerance               [  1e-8 ]
%                     Absolute tolerance to detect if the final homotopic
%                     parameter has been reached.
%                     Used by hampath.
%
%  TolDenseHamX     - Relative Dense output tolerance               [  1e-8 ]
%                     The homotopy stops when the homotopic parameter do not
%                     evolve relatively, iteration per iteration, during ten 
%                     following steps.
%                     Used by hampath.
%
%  TolX             - Relative tolerance between iterates (ssolve)  [  1e-8 ]
%                     Used by ssolve.
%
%
%  See also
%  hampathget
%
if(nargout~=1)
error('wrong number of outputs: try help');
end

if (mod(nargin, 2) ~= 0)
options = varargin{1};
n = (nargin-1) / 2;
for i=1:nargin-1
varargin{i}=varargin{i+1};
end
else
options.Derivative          = 'eqvar';
options.DispIter            = 1;
options.Display             = 'on';
options.DoSavePath          = 'off';
options.IrkInit             = '2';
options.IrkSolver           = 'newton';
options.MaxFEval            = 2000;
options.MaxIterCorrection   = 7;
options.MaxSf               = 1e5;
options.MaxSfunNorm         = 1e-1;
options.MaxStepsOde         = 1e5;
options.MaxStepsOdeHam      = 1e5;
options.MaxStepSizeOde      = 0.0;
options.MaxStepSizeOdeHam   = 0.0;
options.MaxStepSizeHomPar   = 0.0;
options.ODE                 = 'dopri5';
options.ODEHam              = 'dopri5';
options.SolverMethod        = 'hybrj';
options.StopAtTurningPoint  = 0;
options.TolOdeAbs           = 1e-14;
options.TolOdeRel           = 1e-8;
options.TolOdeHamAbs        = 1e-14;
options.TolOdeHamRel        = 1e-8;
options.TolDenseHamEnd      = 1e-8;
options.TolDenseHamX        = 1e-8;
options.TolX                = 1e-8;
n = nargin / 2;
end;

for i = 1:n
  switch lower(varargin{1+2*(i-1)})

    case 'derivative' 
        options.Derivative = lower(varargin{2+2*(i-1)});
    case 'dispiter' 
        options.DispIter = varargin{2+2*(i-1)};
    case 'display' 
        options.Display = lower(varargin{2+2*(i-1)});
    case 'dosavepath' 
        options.DoSavePath = lower(varargin{2+2*(i-1)});
    case 'maxsf' 
        options.MaxSf = varargin{2+2*(i-1)};
    case 'maxsfunnorm' 
        options.MaxSfunNorm = varargin{2+2*(i-1)};
    case 'maxstepsode' 
        options.MaxStepsOde = varargin{2+2*(i-1)};
    case 'maxstepsodeham' 
        options.MaxStepsOdeHam = varargin{2+2*(i-1)};
    case 'maxstepsizeode' 
        options.MaxStepSizeOde = varargin{2+2*(i-1)};
    case 'maxstepsizeodeham' 
        options.MaxStepSizeOdeHam = varargin{2+2*(i-1)};
    case 'maxstepsizehompar'
        options.MaxStepSizeHomPar = varargin{2+2*(i-1)};
    case 'ode' 
        options.ODE = lower(varargin{2+2*(i-1)});
    case 'odeham' 
        options.ODEHam = lower(varargin{2+2*(i-1)});
    case 'stopatturningpoint' 
        options.StopAtTurningPoint = varargin{2+2*(i-1)};
    case 'tolodeabs' 
        options.TolOdeAbs = varargin{2+2*(i-1)};
    case 'toloderel' 
        options.TolOdeRel = varargin{2+2*(i-1)};
    case 'tolodehamabs' 
        options.TolOdeHamAbs = varargin{2+2*(i-1)};
    case 'tolodehamrel' 
        options.TolOdeHamRel = varargin{2+2*(i-1)};
    case 'toldensehamend' 
        options.TolDenseHamEnd = varargin{2+2*(i-1)};
    case 'toldensehamx' 
        options.TolDenseHamX = varargin{2+2*(i-1)};
    case 'tolx'
        options.TolX = varargin{2+2*(i-1)};
    case 'irkinit'
        options.IrkInit = lower(varargin{2+2*(i-1)});
    case 'irksolver'
        options.IrkSolver = lower(varargin{2+2*(i-1)});
    case 'maxfeval'
        options.MaxFEval = lower(varargin{2+2*(i-1)});
    case 'solvermethod'
        options.SolverMethod = lower(varargin{2+2*(i-1)});
    case 'maxitercorrection'
        options.MaxIterCorrection = lower(varargin{2+2*(i-1)});
    otherwise
      error(sprintf('Unrecognized property name ''%s''.', ...
                  varargin{1+2*(i-1)}));
  end;
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
