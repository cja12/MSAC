function [decon, amps, p, misfit] = tridecon(s,w,tw,nt,dt,tol)
%
% [decon, amps, p, misfit] = tridecon(s,w,tw,nt,dt,tol)
%
%  function to perform a triangle deconvolution
%
%  That is, we solve s = w * decon, for decon
%
%  The output decon is a time function consisting 
%   of a set of overlapping triangles with width tw.
%
%   nt is the number of triangles
%   dt is the sample interval of the signal
%   tol is a tolerance for the inversion
%
%   decon is the time function
%   amps are the triangle amplitudes
%   p is the prediction
%   misfit is the the sum of the square misfits normalized
%     by the sum of the square amplitudes of s
%
ns = length(s); nw = length(w);
%
G = zeros(ns,nt);
%
toffset = round(0.5 *tw)/dt;
%
wt = trifilter(w,tw,dt);
%
for i = 1:nt
   j = 1 + (i-1)*toffset;
   g = (1:ns) * 0;
   g(j:nw) = wt(1:(nw-j+1));
   G(:,i) = g';
end
%
% Solve the linar algebra using a singular value decomposition
%
stol = max(size(G))*norm(G)*tol;
amps = pinv(G,stol)*s;
%
% now compute the deconvolution time function and
%   the predictions
%
g = (1:(nt*tw)) * 0;
% set up the spikes at the toffset spacing
for i = 1:nt
   j = 1 + (i-1)*toffset;
   g(j) = amps(i);
end
%
decon = trifilter(g',tw,dt);
% the predictions:
p  = G * amps;
plot(0:(ns-1),s,0:(ns-1),p);pause;
%
misfit = (s-p)'*(s-p);
mystring = sprintf('\nFractional Misfit: %.2f%%\n',100*misfit/(sum(s'*s)));
disp(mystring);
%
