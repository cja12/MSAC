function sylim(limits)
%
%sylim help: **************************************************************
%
%Set the ylimits on a SAC plot such as a p1sac;
% affects all subplots on active figure.
%
% Usage: sylim([ymin ymax])
%
%end sylim help ***********************************************************
%
h = gcf;
a = get(h,'Children');
[nr nc] = size(a);
%
for i = 1:nr
	ylim(a(i),limits);
end
