function [ beamout, Fdetout ] = DoArrBeam(s,Beamon,Beamoff,azimuth,slowness,sbb,band)
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
figure(1);
p1sac(sc);
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
[ beam, Fdet ] = fdbeam ( data, samprate, x, y, azimuth, slowness, nthroot );
clear sbb.b, sbb.e, sbb.beg, sbb.npts ;
sbb.b = sc(1).b;
sbb.e = sc(1).e;
sbb.beg = sc(1).b;
sbb.npts = sc(1).npts;
sbb.d = beam(1:npts);
sbb.kstnm = 'MKAR';
sbb.kcmpnm = 'Beam';
sbb.user5 = azimuth;
sbb.user6 = slowness;
sbb.user(6) = azimuth;
sbb.user(7) = slowness;
ok = WriteSacFile(sbb, 'MKAR.Beam');
beamout = sbb;
sbb.d = Fdet;
sbb.kcpnm = 'Fdet';
ok = WriteSacFile(sbb, 'MKAR.Fdet');
Fdetout = sbb;
%
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
clear sbb.b, sbb.e, sbb.beg, sbb.npts ;
sbb.b = sc(1).b;
sbb.e = sc(1).e;
sbb.beg = sc(1).b;
sbb.npts = sc(1).npts;
sbb.d = beamhp(1:npts);
sbb.kstnm = 'MKAR';
sbb.kcmpnm = 'BeamHp';
sbb.user5 = azimuth;
sbb.user6 = slowness;
sbb.user(6) = azimuth;
sbb.user(7) = slowness;
ok = WriteSacFile(sbb, 'MKAR.BeamHp');
sbb.d = Fdethp;
sbb.kcpnm = 'FdetHp';
ok = WriteSacFile(sbb, 'MKAR.FdetHp');
%
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
%
