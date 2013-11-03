%
fid = fopen('HALM_Stevens.model', 'rt'); % open for reading text only
%  
[A,count] = fscanf(fid,'%f %f %f %f %f %f %f %f',[8,inf]);
%
A = A';
%
fclose(fid);
%
ths = A(:,5);
%
[nlyrs, ncols] = size(A);
%
dhs = zeros(nlyrs,1);
for i = 2:nlyrs
	dhs(i) = dhs(i-1)+ths(i-1);
end
%
vps = A(:,2);
vss = A(:,3);
rhos = A(:,4);
%
tst(1) = 0;
dvss(1) = 0;
tp = 0;
ts = 0;
for i = 1:(nlyrs-1)
	dvss(i+1) = (vss(i+1) - vss(i));
	tp = tp + ths(i) / vps(i);
	ts = ts + ths(i) / vss(i);
	tst(i+1) = ts - tp;
end
[nlyrs length(tst)]
%
%
subplot(1,2,1);
plotlayers(vss,ths);
%
%
% MOKHTAR
%
%
fid = fopen('HALM_Mokhtar_revised.model', 'rt'); % open for reading text only
%  
[A,count] = fscanf(fid,'%f %f %f %f %f %f %f %f',[8,inf]);
%
A = A';
%
fclose(fid)
%
thm = A(:,5);
%
[nlyrs, ncols] = size(A);
%
dhm = zeros(nlyrs,1);
for i = 2:nlyrs
	dhm(i) = dhm(i-1)+thm(i-1);
end
%
vpm = A(:,2);
vsm = A(:,3);
rhom = A(:,4);
%
tm(1) = 0;
dvsm(1) = 0;
tp = 0;
ts = 0;
for i = 1:(nlyrs-1)
	dvsm(i+1) = (vsm(i+1) - vsm(i));
	tp = tp + thm(i) / vpm(i);
	ts = ts + thm(i) / vsm(i);
	tm(i+1) = ts - tp;
end
%
%
hold on;
%
plotlayers(vsm,thm);
%
hold off;
%
ymin = -1;
ymax = 80;
xmin = 3;
xmax = 5;
%
hl = gca;
mylines = get(hl,'Children');
set(mylines(1))
set(mylines(1),'Color',[0 0 0])
set(mylines(2),'Color',[1 0 0])
set(hl,'YDir','reverse');
ylim([ymin ymax]);xlim([xmin xmax]);
set(hl,'FontName','Helvetica','FontSize',14)
set(hl,'XAxisLocation','top');
xlabel('Shear Velocity (km/s)')
ylabel('Depth (km)')
grid on;
%
subplot(1,2,2);
plot(dvss,tst,'r',dvsm,tm,'k');
hr = gca;
set(hr,'YDir','reverse');
ylim([0 8.4]);
xlim(0.4*[-1 1]);
grid on;
set(hr,'FontName','Helvetica','FontSize',14)
set(hr,'XAxisLocation','top');
set(hr,'YAxisLocation','left');
xlabel('Shear Velocity Constrast (km/s)')
ylabel('S - P travel time (s)')
