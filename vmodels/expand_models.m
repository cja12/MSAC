%
nterms = 50;
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
[Cs, zs, xs] = c_expandv(vps',ths',1,nterms);
%
%
%
fid = fopen('HALM_Mokhtar_revised.model', 'rt'); % open for reading text only
%  
[A,count] = fscanf(fid,'%f %f %f %f %f %f %f %f',[8,inf]);
%
A = A';
%
fclose(fid);
%
thm = A(:,5);
%
[nlyrs, ncols] = size(A);
%
dhs = zeros(nlyrs,1);
for i = 2:nlyrs
	dhs(i) = dhs(i-1)+ths(i-1);
end
%
vpm = A(:,2);
vsm = A(:,3);
rhom = A(:,4);
%
[Cm, zm, xm] = c_expandv(vpm',thm',1,nterms);
%
ymin = -1; ymax = 1;
%
%   GRAPHICS
%
subplot(2,1,1)
stem(Cs(1:length(Cs)))
hold on;
stem(Cm(1:length(Cm)))
Hold off;
hg = gca;
set(hg,'FontSize',14);
mc = get(hg,'Children');
amc = mc
set(mc,'Color',[0 0 0]);
set(mc(2),'Marker','o'); set(mc(2),'MarkerEdgeColor',[0 0 0]);
set(mc(2),'MarkerFaceColor',[.75 .75 .75]);
set(mc(2),'MarkerSize',7);
set(mc(4),'Marker','o'); set(mc(4),'MarkerEdgeColor',[0 0 0]);
set(mc(4),'MarkerFaceColor',[1 .15 .15]);
set(mc(4),'MarkerSize',7);
xlabel('Coefficient Number (Polynomial Order)');
% The difference
subplot(2,1,2)
stem(Cs(1:length(Cs)) - Cm(1:length(Cm)))
hg = gca;
set(hg,'FontSize',14);
ylabel('Difference');
mc = get(hg,'Children');
set(mc(2),'Marker','o'); set(mc(2),'MarkerEdgeColor',[0 0 0]);
set(mc(2),'MarkerFaceColor',[.95 .15 .15]);
set(mc(2),'MarkerSize',9);
set(mc,'Color',[0 0 0]);
xlabel('Coefficient Number (Polynomial Order)');
