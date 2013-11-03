function x = sgfilter(s, gwidth)
%
%sgfilter:
%
%Convolve a SAC object with a Gaussian Filter. This routine really
%  just calls the script gfilter which operates on vector time series.
%
%Usage:
%     x = gfilter(s, 2.5);
%

x = s;
x.d = rgfilter(s.d, gwidth, s.dt);
%
% reset header values in the convolution result
%
% reset the header amplitude values
%
if(isfield(x,'depmin'))
	x.depmin = min(x.d); 
end
if(isfield(x,'depmax'))
	x.depmax = max(x.d); 
end
if(isfield(x,'depmax'))
	x.depmen = mean(x.d);
end
%
