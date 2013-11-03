function sg = sspgrm(s, w)
%
%  compute the spectrogram of a sac structure
%
%     s is the sac structure
%     w is the width of window in seconds
%     nw is the number of windows
%     flimits is the flimits for the plot
%     tlimits is the tlimits for the plot
%
%

n       = length(s.d);
% compute the parameters for the window
nw = w / (s.dt); % npts in window
hw = nw / 2;
% number of points in dft
n2      = nextpow2(nw);
nft     = 4 * 2^n2;
halfpts = nft / 2;
% spectrum/frequency parameters
nyquist = 1 / (2*s.dt);
df      = 1 / (nft * s.dt);
f = (0:(halfpts-1)) * df;
%
% compute and plot the spectrogram
%
sg = zeros(halfpts,n);
%
for iw = 1:n
	% indices for the signal
	ib = max(1,iw - hw);
	ie = min(n,iw + hw);
	% indices for the window
	m = round(ie-ib+1);
	m2 = round( m / 2) ;
	% compute the window
	window(1:m) = 1;
	window(1:m2) = (0:(m2-1))/(m2-1);
	window((m2+1):m)=(m-((m2+1):m))/(m2-1);
	% window the signal
	x = s.d(ib:ie) .* window(1:m)';
	% FFT the windowed signal
	X = fft(x,nft);
	% store the result (logarithm right now)
	sg(:,iw) = log(abs(X(1:halfpts))+1e-9);
end
%
% GRAPHICS
%
clim = [-10 -6];
subplot(2,1,1)
imagesc(s.t, f, sg, clim);axis xy; ylim([0 0.1]);
v = -1 * (0:7);
subplot(2,1,2)
plot(s.t, s.d,'k'); axis tight
