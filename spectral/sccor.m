function [ccor, lags] = sccor(x, y, t)
%
%   [ccor lags] = sccor(x,y,t)
%
%   script to compute the cross-correlation of two signals
%    the value is normalized by the power of each signal.
%    so that two functions with the same waveform but
%    different amplitudes will produce a result with a peak of
%    unity.
%
%   example:
%            [ccor lags] = sccor(x,6*x,t)
%     should produce a value with a maximum at 
%     lag = 0 (lag[halfpts]).
%
if(length(x) == 0 || length(y) == 0)
    ccor = 0;
    lags = 0;
    return
end
%
p1 = nextpow2(length(x));
n1 = 2^p1;
p2 = nextpow2(length(y));
n2 = 2^p2;
n = n1;
if n < n2
   n = n2
end
%
halfpts = n / 2;
%
dt = t(2) - t(1);
tmax = (halfpts+1) * dt;
df = 1 / (n * dt);
tpos = dt * (0:halfpts);
tneg = tpos(2:halfpts) - tmax;
lags = [tpos tneg];
%
X = fft(x,n);
Y = fft(y,n);
%
% ifft include a mulitplication by dt*df (1/N)
%  we need one more dt in denominator from the two integrals
ccor = real(ifft(X .* conj(Y)))/dt/sqrt((sum(x.*x)*sum(y.*y)));
%
