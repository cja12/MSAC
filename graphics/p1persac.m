function p1persac(sm, per, astyle)
%
%psac help: **************************************************************
%
%Plot a sac object (read in with cja's rsac) with tight axes, a grid,
% and a label that is defaulted in seconds.
%
% Usage: psac([s1, s2, s2, ...], 'equal')
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
if nargin < 3, 
	astyle = 'uneven'; 
end
%
[nr nnseis] = size(sm);
%
nplots = nnseis / per;
i = 1;
%
for n = 1:nplots
	%
	%
	for k = 1:per
		subplot(per,1,k)
		if(i < nnseis)
			mylines = plot(sm(i).t,sm(i).d);
			myaxes = gca;
			% set up some nice axes
			%
			npts = length(sm(i).d);
			amin = min(sm(i).d);
			amax = max(sm(i).d);
			ymin = amin - 0.05 * abs(amin);
			ymax = amax + 0.05 * abs(amax);
			%
			if strcmp(astyle, 'equal'),
				mamp = max([abs(ymin) abs(ymax)]);
				ymin = -mamp - 0.05 * abs(mamp);
				ymax = -ymin;
			end
			%
			axis([sm(i).t(1) sm(i).t(npts) ymin ymax]);
			%
			grid on;
			%
			set(mylines,'color',[0 0 0]);
			%
			if isunix
				set(myaxes, 'Fontname', 'helvetica', 'fontsize', 14);
			else
				set(myaxes, 'Fontname', 'tekton', 'fontsize', 14);
			end
			%
			i = i+1;
		end
	end
	%
	xlabel('Time (seconds)','Fontname', 'tekton', 'fontsize', 14);
	%
	pause
end
%
