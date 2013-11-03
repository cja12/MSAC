function x = sswgfilter(s, gwidth, T0)
%
%sgfilter:
%
%Convolve a SAC object with a Band-Pass Gaussian Filter. This routine really
%  just calls the script swgfilter which operates on vector time series.
%
%Usage:
%     x = sswgfilter(s, 57, 20);
%
x = s;
x.d = swgfilter(s.d, gwidth, T0, x.dt);
%
% reset header values in the convolution result
%
% reset the header amplitude values
%
x.depmin = min(x.d); x.depmax = max(x.d); x.depmen = mean(x.d);
%
