function x = lpfilter(s, corner, nPoles, nPasses)
%
%   x = lpfilter(s (sac structure), corner (Hz), nPoles, nPasses (1 or 2))
%
%   Low-pass filter a time series with a Butterworth filter.
%
%   example:
%                  x = lpfilter(s, 0.1, 4, 2)
%

%
x = s;
nyquist = 1.0 / (2.0 * x.delta);
%
[b,a] = butter(nPoles,corner/nyquist,'low');
%
y = filter(b,a,x.d);
%
if(nPasses == 2)
	z0 = flipud(y);
	z1 = filter(b,a,z0);
	y = flipud(z1);
end
%
x.d = y(1:length(s.d));
%