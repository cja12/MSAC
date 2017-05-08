function [X, f] = sfft(s)
%
%   sfft(s)
%   script to compute and return an fft of a real valued signal
%    s is a sac object read in using rsac.
%
%   example:
%                  [S f] = sfft(s)
%
p = nextpow2(length(s.d));
n = 2^p;
halfpts = n / 2;
%
dt = s.t(2) - s.t(1);
nyquist = 1 / (2 * dt);
df = 1 / (n * dt);
f = df * (0:(halfpts+1) - 1);
%
X = fft(s.d,n);
X = dt*X(1:(halfpts+1));
%

