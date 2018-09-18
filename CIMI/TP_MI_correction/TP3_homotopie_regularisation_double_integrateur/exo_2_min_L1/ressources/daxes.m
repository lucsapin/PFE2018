function h = daxes(x, y, c)
% daxes -- Draw axes
%
%  Usage
%    daxes(x, y[, c])
%
%  Inputs
%    x, y   origin coordinates
%    c      color
%
%  Outputs
%    h       integer, current figure handle
%
%  Description
%    Draw axes with (x,y) origin.
%
%  See also
%    axis
%

if (nargin == 0)
   x = 0;
   y = 0;
   c = 'b';
elseif (nargin == 2)
   c = 'b';
end;

ax = axis;
washold = ishold;
if ~washold hold on; end;
plot([ax(1) ax(2)], [y y], c, 'LineWidth',1.0);
plot([x x], [ax(3) ax(4)], c, 'LineWidth',1.0);
if ~washold hold off; end;

h = gcf;

% Written on Fri Jan 29 15:21:59 MET 1999
% by Jean-Baptiste Caillau - ENSEEIHT-IRIT (UMR CNRS 5505)
