function eta = verticalSlowness(v,p)
% Compute the vertical slowness from the speed and 
%  horizontal slowness.

eta = sqrt(1.0/(v*v) - p*p);
%