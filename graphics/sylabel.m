function sxlim(mylabel)
%
%sylabel help: **************************************************************
%
%Set the ylabels on a SAC plot such as a p1sac;
% affects all subplots on active figure.
%
% Usage: sylabel('Test')
%
%end sylabel help ***********************************************************
%
h = gcf;
a = get(h,'Children');
[nr nc] = size(a);
%
for i = 1:nr
	axes(a(i));
	ylabel(mylabel);
end
