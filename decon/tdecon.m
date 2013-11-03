function [decon, predicted] = tdecon(s,w,npts,dt,tol)
%
% [decon, predicted] = tdecon(s,w,npts,dt,tol)
%
% Time-domain deconvolution of the wavelet, w from
%   the signal, s. That is, w(t)*decon(t) = s(t), is
%   solved for decon(t).
%
%  s    is convoluted time series
%  w    is the wavelet
%  npts is the number of points in the wavelet
%  dt   is the sample rate of the signals (all must be the same)
%  tol  is the truncation fraction used in the deconvolution
% 

ns = length(s); nw = length(w);
%
% set up the "G" matrix
%
G = zeros(ns,npts);
%
% build one column of G at a time
for i = 1:npts
   g = (1:ns) * 0; g = g';
   ebg = min(ns,i+nw-1);
   ebw = min(nw,ns-i+1);
   g(i:ebg) = w(1:ebw);
   G(:,i) = g;
end
% 
% for a proper convolution, we must include dt
G = G * dt;
%
% compute the SVD of G, truncate, and solve the equations
%
[U,L,V] = svd(G,0);
%
[m,n] = size(G);
%
if m > 1, sd = diag(L);
   elseif m == 1, sd = L(1);
   else sd = 0;
end
%
stol = tol * max(sd);
%
p = sum(sd > stol);
disp(sprintf('Using %d out of %d singular values.',p,length(diag(sd))));
%
if (p == 0)
   decon = zeros(size(G')) * s;
   disp(sprintf('Warning: You have truncated everything.'));
else
   sd = diag(ones(p,1)./sd(1:p));
   decon = V(:,1:p)*sd*U(:,1:p)' * s;
end
%
%  compute the misfit of the inverison
%
predicted = G * decon; % the convolution
residual  = s - predicted;
fmisfit   = (residual'*residual)/(s'*s);
disp(sprintf('The L2 fractional misfit is %.2f',fmisfit));
