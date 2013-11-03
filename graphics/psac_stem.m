function psac(s, astyle)
%
%psac help: **************************************************************
%
%Plot a sac object (read in with cja's rsac) with tight axes, a grid,
% and a label that is defaulted in seconds.
%
% Usage: psac(s, 'equal')
%
% The option 'equal' will set the ylmin and ymax to the same absolute
% value. The default is a variable scale extrema.
%
% For Reference, here are some useful plot options for annotating
% the resulting plot.
%
% h = gca;
% set(myaxes, 'Fontname', 'tekton', 'fontsize', 14);
% set(h,'PlotBoxAspectRatio',[1 0.3 1]);
% ylabel('Displacement (m)','Fontname', 'tekton', 'fontsize', 14);
%  
%end psac help ***********************************************************
%
nargin
if nargin < 2, 
	astyle = 'uneven'; 
end
%
mylines = stem(s.t,s.d,'filled');
myaxes = gca;
% set up some nice axes
%
npts = length(s.d);
amin = min(s.d);
amax = max(s.d);
ymin = amin - 0.05 * abs(amin);
ymax = amax + 0.05 * abs(amax);
%
if strcmp(astyle, 'equal'),
	mamp = max([abs(ymin) abs(ymax)]);
	ymin = -mamp - 0.05 * abs(mamp);
	ymax = -ymin;
end
%
axis([s.t(1) s.t(npts) ymin ymax]);
%
grid on;
%
set(mylines,'color',[0 0 0]);
%
if isunix
	set(myaxes, 'Fontname', helvetica, 'fontsize', 14);
	xlabel('Time (seconds)','Fontname', 'helvetica', 'fontsize', 14);
else
	set(myaxes, 'Fontname', 'tekton', 'fontsize', 14);
	xlabel('Time (seconds)','Fontname', 'tekton', 'fontsize', 14);
end
%
