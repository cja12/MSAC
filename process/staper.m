function x = staper(s,f)
%
%Apply a cosine taper to a SAC object. This script modifies the
%   SAC object data.
%
%  To taper the SAC seismogram, use
%               x = staper(s,f);
%
%   s is a vector, f is the fraction of the length of s
%      to be tapered
%
if nargin < 2
	disp('usage: x = staper(s,fraction)');
	return;
end
%
if f > 0.5
	disp('Tapering with a fraction greater than 0.5 is not a good idea.');
	disp('Taper fraction set to 0.5');
	f = 0.5;
end
%
[nr nseis] = size(s);
%
for ns = 1:nseis

    x(ns) = s(ns);
    n  = length(s(ns).d);
    nt = round(n * f);
    %
    taper = 1 - cos(pi/2 * (1 - (1:nt))/(nt - 1));
    %
    %
    x(ns).d(1:nt) = s(ns).d(1:nt) .* taper';
    %
    taper = fliplr(taper);
    %
    x(ns).d((n-nt+1):n) = s(ns).d(n-nt+1:n) .* taper';
end
