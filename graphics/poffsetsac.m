function poffsetsac(sm, varargin)
%
%p2sac help: **************************************************************
%
%Plot a sac object (read in with cja's rsac) with tight axes, a grid,
% and a label that is defaulted in seconds.
%
% Usage: poffsetsac([s1, s2, s2, ...], 'athick')
%        poffsetsac([s1, s2, s2, ...], 'acolor')
%        poffsetsac([s1, s2, s2, ...], 'agray')
%        poffsetsac([s1, s2, s2, ...], 'acolor', 'athick')
%        poffsetsac([s1, s2, s2, ...], 'agray', 'athick')
%
% The option 'athick' will set the line thicknesses to vary.
% The option 'acolor' will set the line colors to vary.
%
% For Reference, here are some useful plot options for annotating
% the resulting plot.
%
% h = gca;
% set(h,'PlotBoxAspectRatio',[1 0.3 1]);
% ylabel('Displacement (m)','Fontname', 'tekton', 'fontsize', 14);
%  
%end psac help ***********************************************************
%
% black, red, blue, green, purple, cyan, yellow, magenta
mycolors = [0,0,0; 1,0,0; 0,0,1; 0,1,0; 0.5,0.0,0.5; 1,0,1; 0,1,1; 1,1,0]; % 
%
mygrays  = [0,0,0; 0.5 0.5 0.5; 0.2 0.2 0.2];
%
astyle = 'uneven'; 
acolor = 0;
athick = 0;
theColors = mycolors;
%
if nargin > 1
	for k = 1:nargin-1
		opt = lower(varargin(k));
		if strcmp(opt,'acolor')
				acolor = 1;
				theColors = mycolors;
		elseif strcmp(opt,'athick')
				athick = 1;
		elseif strcmp(opt,'agray')
				theColors = mygrays;
		end
	end
end
%
[nr nseis] = size(sm);
%
gymax = -1e20; gymin = 1e20;
tmin = 1e20; tmax = -1e20;
%
dy = 0;
for i = 1:nseis
	ht = max(sm(i).d) - min(sm(i).d);
    if(ht > dy) 
        dy = ht;
    end
end
%
for i = 1:nseis
	sm(i).d = sm(i).d + (nseis-1-i)*dy;
end

for i = 1:nseis
	mylines = plot(sm(i).t,sm(i).d);
	myaxes = gca;
	% set up some nice axes
	%
	npts = length(sm(i).d);
	amin = min(sm(i).d);
	amax = max(sm(i).d);
	ymin = amin - 0.05 * abs(amin);
	ymax = amax + 0.05 * abs(amax);
	% compute values for setting the axes after all traces
	% have been plotted.
	if ymax > gymax
		gymax = ymax;
	end
	if ymin < gymin
		gymin = ymin;
	end
	if sm(i).t(npts) > tmax
		tmax = sm(i).t(npts);
	end
	if sm(i).t(1) < tmin
		tmin = sm(i).t(1);
	end
	% end of computation for axes adjustment
	%
	grid on;
	%
	% adjust the color if necessary
	if acolor == 1
		ic = mod((i-1),length(theColors)) + 1;
		set(mylines,'color',theColors(ic,:));
	else
		set(mylines,'color',theColors(1,:)); % black
	end
	% 
	% line width is set as a multiple of 0.5 points
	if athick == 1
		set(mylines,'LineWidth',[0.25 + (i-1)*0.5]);
	end
	%

		set(myaxes, 'Fontname', 'helvetica', 'fontsize', 14);
		xlabel('Time (seconds)','Fontname', 'helvetica', 'fontsize', 14);
	%
	hold on;
end
%
axis([tmin tmax gymin gymax]);
%
hold off;
