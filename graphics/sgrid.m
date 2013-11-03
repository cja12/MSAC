function sgrid(on_or_off)
%
%sgrid help: **************************************************************
%
%   Toggle the grid option on panel plots;
%       affects all subplots on active figure.
%
% Usage: sgrid('on') or sgrid('off')
%
%end sgrid help ***********************************************************
%

if nargin < 1
	disp('Usage: sgrid(arg), where arg is on or off');
	return
end

h = gcf;
a = get(h,'Children');
[nr nc] = size(a);
%
for i = 1:nr
	if(on_or_off == 'on')
		set(a(i),'YGrid','on');
		set(a(i),'XGrid','on');
	else
		set(a(i),'YGrid','off');
		set(a(i),'XGrid','off');
	end	
end
