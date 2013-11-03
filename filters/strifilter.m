function x = strifilter(s, twidth)
%
%sgfilter:
%
%Convolve a SAC object with a Triangle Filter. This routine really
%  just calls the script gfilter which operates on vector time series.
%
%Usage:
%     x = trifilter(s, 2.5);
%
x = s;
x.d = trifilter(s.d, twidth, x.dt);
%
% reset header values in the convolution result
%
% reset the header amplitude values
%
x.depmin = min(x.d); x.depmax = max(x.d); x.depmen = mean(x.d);
%
