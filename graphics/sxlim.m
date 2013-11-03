function sxlim(limits)
%
%sxlim help: **************************************************************
%
%Set the xlimits on a SAC plot such as a p1sac;
% affects all subplots on active figure.
%
% Usage: sxlim([xmin xmax])
%
%end sxlim help ***********************************************************
%
h = gcf;
a = get(h,'Children');
[nr nc] = size(a);
%
for i = 1:nr
  ax = a(i);
  if ishandle(ax) & strcmp(get(ax, 'type'), 'axes')
	xlim( ax, limits );
  end
end
