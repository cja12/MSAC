function x = rgfilter(s, gwidth, dt)
%
%   x = rgfilter(s, gwidth, dt)
%
%   script to filter a time series with a Gaussian Pulse
%
%   example:
%                  x = rgfilter(s, 2.5, 0.1)
%

%
% set up the spectral parameters
%
p = nextpow2(length(s));
n = 2^p;
halfpts = n / 2;
nyquist = 1 / (2 * dt);
df      = 1 / (n * dt);
fpos    = df * (0:halfpts);
fneg    = fpos(2:halfpts) - nyquist;
f       = [fpos fneg];
%
%  compute the filter
%
filter = exp(-2*pi*f.*f / (4 * gwidth*gwidth));
%
x0 = real(ifft(fft(s,n) .* filter'));
%
%Truncate the length to the original signal length
%
x = x0(1:length(s));
%
