function spfft(s, flimit)
%
%Script to take a SAC object and plot the amplitude spectrum
%
%Usage: spfft(s, [flimit])
%
%   s is a sac object read in using rsac.
%   [flimit] is an array for the frequency limits of the plot
%
%   example:
%                  spfft(s,[0.001 0.1])
%
p = nextpow2(length(s.d));
n = 2^p;
halfpts = n / 2;
%
dt = s.t(2) - s.t(1);
nyquist = 1 / (2 * dt);
df = 1 / (n * dt);
f = df * (0:halfpts-1);
%
X = fft(s.d,n);
Xa = dt * abs(X);
clear X;
%
% if taking the log, don't try to plot the zero value
%
txt = sprintf('\nThe zero frequency spectral amplitude is: %e', Xa(1));
%disp(txt);
%
plot(f(2:halfpts),Xa(2:halfpts),'k');
grid on;
myaxes = gca;
set(myaxes,'XScale','log');
set(myaxes,'YScale','log');
%
if nargin == 1
   range = [df 1.1*nyquist 0 5 * max(Xa(1:halfpts))];
else
   range = [ flimit 0 5 * max(Xa(1:halfpts))];
end
%
axis( range );%
if isunix
	set(myaxes, 'Fontname', 'helvetica', 'fontsize', 14);
	xlabel('Frequency (Hertz)','Fontname', 'helvetica', 'fontsize', 14);
else
	set(myaxes, 'Fontname', 'tekton', 'fontsize', 14);
	xlabel('Frequency (hertz)','Fontname', 'tekton', 'fontsize', 14);
end
% clean up
%
