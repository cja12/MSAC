function [ps, f] = spfftWelch(a, flimit)
%
%Script to take a SAC object and plot the seismogram power spectrum
% computed using the default values of pwelch (8 window average).
% The values returned are in units of radians per sample (the
% MATLAB command's default). I need to fix this someday.
% This function is best for stationary time series like noise,
% not for transient signals.
%
%Usage: spfftWelch(a, [flimit])
%
%   a is an array of sac object read in using rsac, with the same
%   sample rate and dt (within a power of two).
%
%   [flimit] is an array for the frequency limits of the plot
%
%   example:
%                  [pspectr, f] = spfftWelch([s1,s2],[0 10])
%
for i=1:length(a)
    s = a(i);
    p = nextpow2(length(s.d));
    n = 2^p;
    halfpts = n / 2;
    %
    dt = s.t(2) - s.t(1);
    nyquist = 1 / (2 * dt);
    %
    [Pxx w] = pwelch(s.d);
    Xa = dt*sqrt(Pxx*(2*pi)*length(Pxx));
    f = w/pi * nyquist;
    clear Pxx;
    %
    txt = sprintf('\nThe zero frequency power spectrum amplitude is: %e', Xa(1));
    %disp(txt);
    %
    plot(f,Xa,'k');
    grid on;
    myaxes = gca;
    set(myaxes,'XScale','log');
    set(myaxes,'YScale','log');
    %
    if nargin == 1
        range = [1e-9 1.1*nyquist 0 5 * max(Xa)];
    else
        range = [ flimit 0 5*max(Xa)];
    end
    %
    axis( range );
    %
    if isunix
        set(myaxes, 'Fontname', 'helvetica', 'fontsize', 18);
        xlabel('Frequency (Hertz)','Fontname', 'helvetica', 'fontsize', 18);
        ylabel('Power Spectrum (radians per sample)','Fontname', 'helvetica', 'fontsize', 18);
    else
        set(myaxes, 'Fontname', 'tekton', 'fontsize', 18);
        xlabel('Frequency (hertz)','Fontname', 'tekton', 'fontsize', 18);
    end
    hold on;

    ps{i} = Xa;

end
hold off;

% clean up
%
