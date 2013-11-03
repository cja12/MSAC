function conv = sconv(x, y)
%
%Convolve two SAC object time series
%
%Example:
%      conv = sconv(x,y)
%
% returns a SAC object with the header values of x, and a 
% time series of the same length of x, but convolved with the
% time series in the SAC object y
%
conv = x; % the x objects header values are used in the output
%
%  compute the number of points
%
if x.dt ~= y.dt, 
	disp('Error: The files must have the same dt to perform convolution.");
	return;
end;
%
p1 = nextpow2(length(x));
n1 = 2^p1;
p2 = nextpow2(length(y));
n2 = 2^p2;
n = n1;
if n < n2
   n = n2;
end
%
X = fft(x,n);
Y = fft(y,n);
%
% the ifft has a divide by 1/N which is dt * df,
%   for convolution, we need another dt from the other
%   transform.
%
c = real(ifft(X .* Y));
conv.d = x.dt * c(1:length(x)); % Don't change the length of x
%
clear c, X, Y, dt;
%
% reset header values in the convolution result
%
% reset the header amplitude values
%
x.depmin = min(x.d); x.depmax = max(x.d); x.depmen = mean(x.d);
%
