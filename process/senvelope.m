function x = senvelope(s)
%
%senvelope:
%
%Compute the envelope of a seismogram in a SAC structure.
%
%Usage:
%     x = senvelope(s); % a SAC structure is returned
%     s is a SAC structure (imported with rsac)
%
if nargin < 1
	disp('usage: x = senvelope(s)');
	return;
end
%
x = s;
p = nextpow2(length(s.d));
n = 2^p;
halfpts = n / 2;
Y = fft(x.d,n);
Y(halfpts+1:n) = 0;
Y = abs(ifft(2*Y));
x.d = Y(1:x.npts);
%
% reset header values in the convolution result
%
% reset the header amplitude values
%
x.depmin = min(x.d); x.depmax = max(x.d); x.depmen = mean(x.d);
%
