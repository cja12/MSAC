function x = swgfilter(s,gwidth,T0,dt)
%
%   Filter a time series with a band-pass Gaussian Filter
%
%   x = swgfilter(s, gwidth, T0, dt)
%
%      s  is the vector of amplitudes with sample rate dt
%      T0 is the filter center period, gwidth is the filter
%            width control parameter.
%
%   example:
%                  x = sgfilter(s, 2.5, 20, 0.1)


%
% set up the spectral parameters
%
omega0 = 2 * pi / T0;
p = nextpow2(length(s));
n = 2^p;
halfpts = n / 2;
nyquist = 1 / (2 * dt);
df      = 1 / (n * dt);
fpos    = df * (0:halfpts);
fneg    = (fpos(2:halfpts) - nyquist);
f       = [fpos fneg];
omega = f * 2 * pi;
df = abs(omega) - omega0;
gain = sqrt((gwidth*pi)/(omega0*omega0));
gain = 1;
%
%  compute the filter
%
filter = gain * exp(-gwidth*df.*df / (omega0*omega0));
%
%
x0 = real(ifft(fft(s,n) .* filter'));
%
%Truncate the length to the original signal length
%
x = x0(1:length(s));
%
