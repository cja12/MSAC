function wlevel_sweep(s,g,dt,wls,tshift)
%
%  function to perform a sweep of water level deconvolutions
%    and display the results
%
%  s,g are sac objects. g is deconvolved from s.
%  dt is the sample rate of both signals.
%  wls is a vector of water level values
%  tshift is the time shift to apply to the deconvolutions.
%
%   Usage: wlevel_sweep(s,g,dt,wls,tshift)
%

nd = length(wls);
%
clf;
for i = 1: nd
	[decon pred] = wlevel(s,g,wls(i),tshift);
	subplot(nd,1,i);
	plot(decon.t,decon.d,'k-');axis tight;
	title(sprintf('Water-Level = %f',wls(i)));
end
%
