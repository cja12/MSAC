function sxdiv(xdiv)
%
%sxdiv help: **************************************************************
%
%Set the x divisions (ticks) on a SAC plot such as a p1sac;
% affects all subplots on active figure.
%
% Usage: sxdiv(60)
%
%end sxdiv help ***********************************************************
%
h = gcf;
a = get(h,'Children');
[nr nc] = size(a);
%
for i = 1:nr
	xt = get(a(i),'XTick');
	xmin = round(min(xt)/xdiv - 0.5) * xdiv;
	xmax = round(max(xt)/xdiv + 0.5) * xdiv;;
	set(a(i),'XTick',xmin:xdiv:xmax);
end
