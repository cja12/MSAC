function x = trifilter(s, twidth, dt)
%
%   x = trifilter(s, twidth, dt)
%
%   script to convolve a vector with a unit area
%      triangle
%
%   example:
%                  x = trifilter(s, 3, 0.1)
%

%
p = nextpow2(length(s));
ns = 2^p;
%
% build the triangle
%
n = round(twidth/dt/2) + 1;
%
triangle(1:n) = 0:n-1; % the first point is a zero
%
triangle(n+1:2*n-1) = fliplr(triangle(1:n-1));
%
% make the triangle unit area
triangle = triangle/(dt*sum(triangle));
%
% perform the convolution in the frequency domain
%
x0 = real(ifft(fft(s,ns) .* fft(triangle',ns)));
%
%Truncate the length to the original signal length
%
x = x0(1:length(s));
%

