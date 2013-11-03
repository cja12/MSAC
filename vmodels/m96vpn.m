function [vpn, tau] = m96vpn(m96Name,mindist,maxdist)
%
% modelvpn(x,t)
%

% these are the distances used for line fit
%mindist = 150;
%maxdist = 350;
%  read in the m96 file
%
[a,b,r,h]  = rdm96(m96Name);
clf
subplot(1,2,1)
h0 = gca;
set(h0,'Fontsize',18);
plotlayers(a,h);
ylim([0 100]);
xlabel('P-Velocity (km/s)');
ylabel('Depth (km)');
%
% compute the travel-time distance curve
x = 2:2:maxdist; 
t = first_arrival(a,h,x,0);
%
i0 = find(x > mindist);
x0 = x(i0);
t0 = t(i0);
i0 = find(x0 < maxdist);
x1 = x0(i0);
t1 = t0(i0);

[P,S] = polyfit(x1,t1,1);
p = P(1);
tau = P(2);
vpn = 1/p;
%
disp('-----------------------------------------------');
disp('m96vpn output:');
disp('-----------------------------------------------');
disp(date);
disp(pwd);
disp(sprintf('Model Name: %s',m96Name))
disp(sprintf('Vpn ~ %.3f km/s\ntau ~ %.2f sec',vpn,tau))
disp(sprintf('MinDistance: %d km, MaxDistance: %d km',mindist,maxdist))
disp('-----------------------------------------------');
%
%
subplot(1,2,2);
h0 = gca;
set(h0,'Fontsize',18);
plot(x,t,'b.');
xlabel('Travel Time (sec)');
ylabel('Distance (km)');
grid on;
tmin = p * mindist + tau;
tmax = p * maxdist + tau;
hold on;
plot([mindist maxdist],[tmin tmax],'r-','lineWidth',2);
hold off;