function [ time_out, state_out ]  = exprhsfun(rhsfun, tspan, state_init, options, par)
%-------------------------------------------------------------------------------------------
%
%    exprhsfun
%
%    Description
%
%        Computes the chronological exponential of rhsfun.
%
%-------------------------------------------------------------------------------------------
%
%    Matlab Usage
%
%        [time_out, state_span] = exphvfun(tspan, z0, options, par)
%
%    Inputs
%
%        rhsfun     - rhs of the form                   : x_dot = rhs(t,x,par)
%        tspan      - real row vector of dimension 2    : tspan = [t0 tf]
%        state_init - real vector                       : initial flow
%        options    - struct vector                     : odeset options
%        par        - real vector                       : parameters, par=[] if no parameters
%
%    Outputs
%
%        time_out   - real row vector                   : time at each integration step
%        state_out  - real matrix                       : state_out(:,i) : flow at time_out(i)
%
%-------------------------------------------------------------------------------------------

odefun      = @(t,x) rhsfun(t,x,par);
[tout, z]   = ode45(odefun, tspan, state_init, options);
time_out    = tout';
state_out  = z';
