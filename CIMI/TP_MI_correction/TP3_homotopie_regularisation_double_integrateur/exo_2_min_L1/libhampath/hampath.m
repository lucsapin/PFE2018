function [ parout, yout, sout, viout, dets, normS, ps, flag ] = hampath(parspan,y0,options)
%-------------------------------------------------------------------------------------------
%
%    hampath (needs sfun.f90)
%
%    Description
%
%        Interface of the homotopic method.
%
%    Options used
%
%        Derivative, DispIter, Display, DoSavePath, FreeFinalTime, MaxIterCorrection,
%        MaxSf, MaxSfunNorm, MaxStepsOde, MaxStepsOdeHam, MaxStepSizeOde, MaxStepSizeOdeHam,
%        MaxStepSizeHomPar, ODE, ODEHam, StopAtTurningPoint, TolOdeAbs, TolOdeRel,
%        TolOdeHamAbs, TolOdeHamRel, TolDenseHamEnd, TolDenseHamX
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [parout,yout,sout,viout,dets,normS,ps,flag] = hampath(parspan,y0,options)
%
%    Inputs
%
%        parspan - real matrix, parspan = [par0 parf]. parspan(:,i) is a parameter vector
%                    given to hfun and efun. The homotopy is from par0 to parf and of
%                    the form : (1-lambda)*par0 + lambda*parf, unless a fortran file with
%                    the subroutine parfun(lambda,lpar,par0,parf,parout), with lambda
%                    from 0 to 1, is provided.
%        y0      - initial solution, ie "sfun(y0,options,par0) = 0"
%        options - struct, hampathset options
%
%
%    Outputs
%
%        parout  - real matrix, parameters at each integration step.
%        yout    - real matrix, solutions along the paths, ie
%                   "sfun(yout(:,k),options,parout(:,k) = 0"
%        sout    - real vector, arc length at each integration step
%        viout   - real matrix, viout(:,k) = dot_c(:,k) where c = (y, lambda) and
%                   dot is the derivative w.r.t. arc length
%        dets    - real vector, det(h'(c(s)),c'(s)) at each integration step, where
%                   h is the homotpic function
%        normS   - real vector, norm of the shooting function at each integration step
%        ps      - real vector, <c'(s_old),c'(s)> at each integ. step
%        flag    - integer, flag should be 1 (ODE integrator output)
%                    if flag==0  then Sfmax is too small
%                    if flag==-1 then input is not consistent
%                    if flag==-2 then larger MaxSteps is needed
%                    if flag==-3 then step size became too small
%                    if flag==-4 then problem is problably stiff
%                    if flag==-5 then |S| is greater than NormeSfunMax
%                    if flag==-6 then the homotopic parameter do not
%                            evolve relatively wrt TolDenseHamX
%                    if flag==-7 then a turning point occurs
%
%
%-------------------------------------------------------------------------------------------
if(nargin~=3 || nargout>8)
    error('wrong syntax: try help');
end

if(size(parspan,2)==2)
    if(abs(parspan(:,1)-parspan(:,2))==0)
        parout = parspan(:,1);
        yout   = y0;
        sout   = -1;
        viout  = [];
        dets   = -1;
        normS  = -1;
        ps     = -1;
        flag   = -1;
        fprintf('\n');
        fprintf('Warning: no continuation performed because parspan is not valid.');
        fprintf('\n');
        return
    end
end

value   = hampathget(options,'getoptionsformex');
dw      = value.dw;
iw      = value.iw;
sw      = value.sw;
lsw     = value.lsw;

%try
    gfortranMatlab(1);
    [ parout, yout, sout, viout, dets, normS, ps, flag] = hampath_m(parspan,y0,dw,iw,sw,lsw);
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
