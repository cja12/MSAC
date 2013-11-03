function x = shilbert(s)
%
%shilbert
%
%Compute the Hilbert Transform of a seismogram in a SAC structure.
%
%Usage:
%     x = shilbert(s);
%     s is a SAC structure (imported with rsac)
%
if nargin < 1
	disp('usage: x = shilbert(s)');
	return;
end
%
x = s;
p = nextpow2(length(s.d));
n = 2^p;
halfpts = n / 2;
X = fft(x.d,n);
Y = imag(X) + i * real(X);
Y(halfpts+1:n) = -real(Y(halfpts+1:n)) + i * imag(Y(halfpts+1:n));
Y = real(ifft(Y,n));
x.d = Y(1:x.npts);
%
% reset header values in the convolution result
%
% reset the header amplitude values
%
x.depmin = min(x.d); x.depmax = max(x.d); x.depmen = mean(x.d);
%
