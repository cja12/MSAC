np = 12;
z  = linspace(2.5,57.5,np);
dh = z(2) - z(1);
th = ones(np,1)*dh;
v  = [5.8, 6.1, 6.125, 6.15, 6.5, 6.6, 6.7, 6.8, 6.85, 8.0, 8.1, 8.1]./sqrt(3);
%
x  = z / 30 - 1;
[min(x) max(x)]
dx = x(2) - x(1);
%
% compute the weight function fo the Tn(x)
w  = sqrt(1 - (x .* x));
%
% compute the Chebyshev Polynomials
%
nterms = 500; % number of terms in the series
%
T      = ones(nterms,np);
T(2,:) = x;
%
for i = 3:nterms
	T(i,:) = ( 2 * x .* T(i-1,:) - T(i-2,:));
end
% 
% compute the coefficients
%
C = zeros(1,nterms); % a vector of coefficients
%
% skip the first term - it's too hard to integrate numerically
%    instead, remove the mean from the velocity and 
%    put it back later.
vtmp = v - mean(v);
%
for i = 2:nterms
	f = vtmp .* T(i,:) ./ w;
	norm = trapz(x,T(i,:) .* T(i,:) ./ w); % numerical normalization
	C(i) = (1/norm) * trapz(x,f);  % Integrate Normalization for Tn
	vtmp = vtmp - C(i) * T(i,:); % it's more stable if you remove the
								 %   components you've already mapped
end
%
%  Compute the predictions
%
s = zeros(1,np);     % the vector to hold the predictions
%
nterms = 2;
s = zeros(1,np) + mean(v);
for i = 2:nterms
	s = s + C(i) * T(i,:);
end
%
% The real work is all done, the rest is just display
%
subplot(2,3,1);
%plot(z,v,'ks-',z,s,'ko-');
plotlayers(s,th);
hold on;
plotlayers(v,th);
hold off;
h = gca;
set(h,'YDir','reverse');
set(h,'FontSize',14);
set(h,'FontName','Helvetica');
mylines = get(h,'Children');
set(mylines(1),'Color',[0 0 0]);
set(mylines(2),'Color',[1 0 0]);
set(h,'XAxisLocation','bottom');
set(h,'XTick',3:0.5:5);
ylabel('Depth (km)')
xlabel('Velocity (km/s)');
title('Two Terms','Fontsize',14);
grid on;
%
s = zeros(1,np);     % the vector to hold the predictions
%
%
nterms = 5;
s = zeros(1,np) + mean(v);
for i = 2:nterms
	s = s + C(i) * T(i,:);
end
%
subplot(2,3,2);
%plot(z,v,'ks-',z,s,'ko-');
plotlayers(s,th);
hold on;
plotlayers(v,th);
hold off;
h = gca;
set(h,'YDir','reverse');
set(h,'FontSize',14);
set(h,'FontName','Helvetica');
mylines = get(h,'Children');
set(mylines(1),'Color',[0 0 0]);
set(mylines(2),'Color',[1 0 0]);
set(h,'XAxisLocation','bottom');
set(h,'XTick',3:0.5:5);
ylabel('Depth (km)')
xlabel('Velocity (km/s)');
title('Five Terms','Fontsize',14);
grid on;
%
%
%C(2) = C(2) * 1.15;
nterms = 50;
s = zeros(1,np) + mean(v);
for i = 2:nterms
	s = s + C(i) * T(i,:);
end
%
subplot(2,3,3);
%plot(z,v,'ks-',z,s,'ko-');
plotlayers(s,th);
hold on;
plotlayers(v,th);
hold off;
h = gca;
set(h,'YDir','reverse');
set(h,'FontSize',14);
set(h,'FontName','Helvetica');
mylines = get(h,'Children');
set(mylines(1),'Color',[0 0 0]);
set(mylines(2),'Color',[1 0 0]);
set(h,'XAxisLocation','bottom');
set(h,'XTick',3:0.5:5);
ylabel('Depth (km)')
xlabel('Velocity (km/s)');
title('Fifty Terms','Fontsize',14);
grid on;
%
%
%
subplot(2,2,3);
C(1) = mean(v);
stem(C,'k','Filled');
title('Chebyshev Coefficients','Fontsize',14);
axis([0 nterms+1 -1 5]);
grid on;
h = gca;
set(h,'FontSize',14);
set(h,'FontName','Helvetica');
xlabel('Polynomial Number')
set(h,'XTick',0:10:50);
%
subplot(2,2,4);
C(1) = mean(v);
stem(3:nterms,C(3:nterms),'k','Filled');
title('Chebyshev Coefficients','Fontsize',14);
axis([0 nterms+1 -1 8]);
axis([0 nterms+1 -0.15 .15]);
grid on;
h = gca;
set(h,'FontSize',14);
set(h,'FontName','Helvetica');
set(h,'YTick',-.15:0.05:.15);
xlabel('Polynomial Number');
set(h,'XTick',0:10:50);
