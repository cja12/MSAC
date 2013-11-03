function [ beam, Fdet, res ] = DoArrBeam(s,Beamon,Beamoff,azimuth,slowness,sbb,Event,Phase,band)
%
% Count the number of Sac Structures in the Array
%
[r,c] = size(s) ;
%
% Get the delx and dely Offsets within the array in km
%
for n=1:c
   delx(n) = getfield(s(n),'user7');
   dely(n) = getfield(s(n),'user8');
end
%
% Cut (eventually the Phase of interest), rmean and plot
%
sc = scut(s,Beamon,Beamoff);
sc = srmean(sc);
% p1sac(sc);
sc = staper(sc,.1);
sc = srmean(sc);
time = sc(1).t;
close all;
figure(1);
p1sac(sc);
orient landscape ;
plotname = strcat(Event,'_',Phase,'_Array.ps');
print('-dps2', plotname );
npts = size(sc(1).d);
%
% Copy SAC waveforms to pass to Beam former
% Set up the samprate, azimuth and slowness for the
% call to Frequency Domain Beam Former
%
for n=1:c
    data(:,n) = sc(n).d ;
end
dt = getfield( sc(1), 'delta' );
samprate = ( 1.00 / dt );
x = delx' ;
y = dely' ;
%
%azimuth = 124. ;
%slowness = 0.125 ;
nthroot = 1 ;
%
% Got the Beam and F detector trace, full bandwidth
% build SAC Header from BB offset 0,0 with Beam and F Detector data
% and header variables, user5 = azimuth, user6 = slowness
% Write SacFiles
%   
[ beam, Fdet, res ] = fdbeam ( data, samprate, x, y, azimuth, slowness, nthroot );
clear sbb.b;
clear sbb.e;
clear sbb.beg;
clear sbb.npts ;
sbb.b = sc(1).b;
sbb.e = sc(1).e;
sbb.beg = sc(1).b;
sbb.npts = sc(1).npts;
sbb.d = beam(1:npts);
sbb.kstnm = 'MKAR';
sbb.kcmpnm = strcat('Beam',Phase);
sbb.user5 = azimuth;
sbb.user6 = slowness;
sbb.user(6) = azimuth;
sbb.user(7) = slowness;
filename = strcat(Event,'_',Phase,'_','Beam');
ok = WriteSacFile(sbb, filename);
beamout = sbb;
sbb.d = Fdet;
sbb.kcpnm = strcat('Fdet',Phase);
filename = strcat(Event,'_',Phase,'_','Fdet');
ok = WriteSacFile(sbb, filename);
Fdetout = sbb;
%
% Write out the residuals to SAC files
%
ressac = sc ;
for n=1:c
   clear ressac(n).b;
   clear ressac(n).e;
   clear ressac(n).beg;
   clear ressac(n).npts;
   ressac(n).b = sc(n).b;
   ressac(n).e = sc(n).e;
   ressac(n).beg = sc(n).b;
   ressac(n).npts = sc(n).npts;
   ressac(n).d = res(1:npts,n);
   %ressac(n).kstnm = sc(n).kstnm;
   ressac(n).kcmpnm = strcat('Res',Phase);
   ressac(n).user5 = azimuth;
   ressac(n).user6 = slowness;
   ressac(n).user(6) = azimuth;
   ressac(n).user(7) = slowness;
   filename = strcat(Event,'_',sc(n).kstnm,'_',Phase,'_','Res');
   ok = WriteSacFile(ressac(n), filename);
end
%
close all;
figure(2);
tmin = sc(1).b;
tmax = sc(1).e;
xlim([ tmin tmax ]);
subplot(2,1,1);
amin = min(beam(1:npts));
amax = max(beam(1:npts));
ymin = amin - 0.05 * abs(amin);
ymax = amax + 0.05 * abs(amax);
% axis([tmin tmax ymin ymax]);[b,a] = 
plot(time,beam(1:npts)); axis([tmin tmax ymin ymax]);
%
subplot(2,1,2);
amin = min(Fdet(1:npts));
amax = max(Fdet(1:npts));
ymin = amin - 0.05 * abs(amin);
ymax = amax + 0.05 * abs(amax);
% axis([tmin tmax ymin ymax]);
plot(time,Fdet(1:npts)); axis([tmin tmax ymin ymax]);
plotname = strcat(Event,'_',Phase,'_Beam_Fdet.ps');
print('-dps2', plotname );
%
% Band Passed Section - this helps atttenuate the correlated microseisms
% and gives a better Fdetector trace for quality appraisal of the beam
% band is based on the band found from SNR 
%
%[b,a] = butter( 4, 0.1, 'high' );
Fnyq = 1. / ( 2. * s(1).delta );
bandw = band / Fnyq;
[b,a]  = butter( 4, bandw );
for n=1:c
   sc(n).d = filter( b, a, sc(n).d );
end
%
close all;
figure(3);
p1sac(sc);    
%
% For the Beam and F detector for the High Passed data and
% save as sacfiles
%
for n=1:c
    data(:,n) = sc(n).d ;
end
[ beamhp, Fdethp ] = fdbeam ( data, samprate, x, y, azimuth, slowness, nthroot );
clear sbb.b;
clear sbb.e;
clear sbb.beg;
clear sbb.npts ;
sbb.b = sc(1).b;
sbb.e = sc(1).e;
sbb.beg = sc(1).b;
sbb.npts = sc(1).npts;
sbb.d = beamhp(1:npts);
sbb.kstnm = 'MKAR';
sbb.kcmpnm = strcat('BeamHp',Phase);
sbb.user5 = azimuth;
sbb.user6 = slowness;
sbb.user(6) = azimuth;
sbb.user(7) = slowness;
filename = strcat(Event,'_',Phase,'_','BeamHp');
ok = WriteSacFile(sbb, filename);
sbb.d = Fdethp;
sbb.kcpnm = strcat('FdetHp',Phase);
filename = strcat(Event,'_',Phase,'_','FdetHp');
ok = WriteSacFile(sbb, filename);
%
close all;
figure(4);
tmin = sc(1).b;
tmax = sc(1).e;
xlim([ tmin tmax ]);
subplot(2,1,1);
amin = min(beamhp(1:npts));
amax = max(beamhp(1:npts));
ymin = amin - 0.05 * abs(amin);
ymax = amax + 0.05 * abs(amax);
% axis([tmin tmax ymin ymax]);[b,a] = 
plot(time,beamhp(1:npts)); axis([tmin tmax ymin ymax]);

%
subplot(2,1,2);
amin = min(Fdethp(1:npts));
amax = max(Fdethp(1:npts));
ymin = amin - 0.05 * abs(amin);
ymax = amax + 0.05 * abs(amax);
% axis([tmin tmax ymin ymax]);
plot(time,Fdethp(1:npts)); axis([tmin tmax ymin ymax]);
plotname = strcat(Event,'_',Phase,'_Beam_Fdet_hp.ps');
print('-dps2', plotname );
%
close all;
