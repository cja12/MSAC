function x = hpfilter(s, corner, nPoles, nPasses)
%
%   x = hpfilter(s (sac structure), corner (Hz), nPoles,  nPasses (1 or 2))
%
%   High-pass filter a time series with a Butterworth filter.
%
%   example:
%                  x = hpfilter(s, 0.1, 4, 2)
%

%
x = s;
nyquist = 1 / (2 * x.delta);
%
if(corner >= nyquist) 
    return;
end
%
[b,a] = butter(nPoles,corner/nyquist,'high');
%
y = filter(b,a,s.d);
%
if(nPasses == 2)
	z0 = flipud(y);
	z1 = filter(b,a,z0);
	y = flipud(z1);
end
%
x.d = y(1:length(s.d));
%