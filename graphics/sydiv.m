function sydiv(ydiv)
%
%sydiv help: **************************************************************
%
%Set the y-divisions (ticks) on a SAC plot such as a p1sac;
% affects all subplots on active figure.
%
% Usage: sydiv(25)
%
%end sydiv help ***********************************************************
%
h = gcf;
a = get(h,'Children');
[nr nc] = size(a);
%
for i = 1:nr
	yt = get(a(i),'YTick');
	ymin = round(min(yt)/ydiv - 0.5) * ydiv;
	ymax = round(max(yt)/ydiv + 0.5) * ydiv;;
	set(a(i),'YTick',ymin:ydiv:ymax);
end
