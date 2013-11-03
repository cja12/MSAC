function plotlayers(v,h)
%
% plotlayers(v,h)
%

n = length(v);
%
vl = zeros(2*n,1);hl = zeros(2*n,1);
%
depth = 0;
for i = 1:n
	j = 2*i;
	vl(j-1) = v(i);
	vl(j)   = v(i);
	hl(j-1) = depth;
	depth   = depth + h(i);
	hl(j)   = depth;
end
%
h = gca;
myline = plot(vl,hl);
set(h,'YDir','reverse');
set(myline,'Color',[0 0 0]);
grid on;
