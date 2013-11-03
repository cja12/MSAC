function [retaz, retslofk] = DoFk(s,Phcut1,Phcut2,Event,Phase,band)
%
% Outputs - retaz, retslofk
%           az - azimuth in degrees of the mean  peak of the FK spectrum
%           slofk - slowness in seconds/km of the mean peak of the FK
% Inputs - s,Phcut1,Phcut2,Event,Phase
%          s - array of SAC structures for array elements
%          Phcut1 - time of start of phase cut
%          Phcut2 - time of stop of phase cut
%          Event - string of event name
%          Phase - string of phase name
%	   band - low frequency, high frequency band limits
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
sc = scut(s,Phcut1,Phcut2);
sc = srmean(sc);
% p1sac(sc);
sc = staper(sc,.1);
sc = srmean(sc);
time = sc(1).t;
close all;
figure(1);
p1sac(sc);
orient landscape ;
plotname = strcat(Event,'_',Phase,'.ps');
print('-dps2', plotname );
%
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
maxslow = 0.3;
numslow = 81;
%band = [2, 4];
slow = linspace ( -maxslow, maxslow, numslow );
islozero = find(slow == 0);
delslow = 2.*maxslow/numslow;
%
% Compute FK and Fdet for the cut waveform
%   
[FK, Fdet] = fk ( data, samprate, x, y, slow, band );
% Normalize FK.
%
[maxFK,r] = max(FK);
[maxFK,c] = max(maxFK);
FK = FK/maxFK;
frac = 0.7;
fracmaxFK = frac;
% Plot FK in dB.
%
close all;
figure(2);
%menucbar;
imagesc ( slow, slow, 10*log10(abs(FK)+eps) );
%contour(slow, slow, 10*log10(abs(FK)+eps), [10*log10(fracmaxFK) 10*log10(fracmaxFK)], '-w' );
axis xy;
%
  axis image;
  colormap ( 'jet' );
  xlabel ( 'Sx (Seconds/km)' );
  ylabel ( 'Sy (Seconds/km)' );
  set ( gca, 'TickDir', 'out' );
  hold on;
  plot3 ( slow(c), slow(r(c)), ones(size(c)), 'xw',...
          'MarkerSize', 12,...
          'LineWidth', 2 );
  [X,Y] = meshgrid(slow,slow);
  contour3(X, Y, FK, [ frac frac ],'-w');
% 
plotname = strcat(Event,'_',Phase,'_FK.ps');
print('-dps2', plotname );
%
% [row, column]  = max( max( FK ) );
% row is N/S or y and column is E/W or x index
%
[az,slofk] = cart2pol( slow(r(c)), slow(c) );
az = az*180/pi;
if az<0
  az = az + 360;
end
%
% Greater than frac Energy region
%
% [row, column]  = find( FK >= fracmaxFK );
% row is N/S or y and column is E/W or x index
%
[iy,ix] = find( FK >= fracmaxFK );
slox = slow( ix );
sloy = slow( iy );
%
[azfrac,slofrac] = cart2pol(sloy,slox);
%
minslo = min(slofrac);
maxslo = max(slofrac);
%
azfrac = azfrac*180/pi;
[ineg] = find( azfrac < 0 );
azfrac(ineg) = azfrac(ineg) + 360;
%
minaz = min(azfrac);
maxaz = max(azfrac);
%
delslo = abs( maxslo - minslo );
delaz = abs( maxaz - minaz );
%
FKnorm = sum ( sum( FK( [iy,ix] ) ) );
meanslox = sum( sum( slox * FK( [iy,ix] )/FKnorm ) );
meansloy = sum( sum( sloy * FK( [iy,ix] )/FKnorm ) );
stdslox = sum( sum( (slox-meanslox).*(slox-meanslox) * FK( [iy,ix] )/FKnorm ) );
stdsloy = sum( sum( (sloy-meansloy).*(sloy-meansloy) * FK( [iy,ix] )/FKnorm ) );
cxy = sum( sum( (slox-meanslox).*(sloy-meansloy) * FK( [iy,ix] )/FKnorm ) );
[meanaz, meanslo] = cart2pol( meansloy, meanslox );
meanaz = meanaz*180/pi;
if meanaz<0
  meanaz = meanaz + 360;
end
[ az, slofk, meanaz, meanslo, delaz, delslo, sqrt(stdslox), sqrt(stdsloy), cxy ]
%
% Plot Fdet
close all;
figure(3);
%menucbar;
[maxFdet,rd] = max(Fdet);
[maxFdet,cd] = max(maxFdet);
Fdet = Fdet/maxFdet;
%
imagesc ( slow, slow, 10*log10(abs(Fdet)) + eps );
axis xy;
%
  axis image;
  colormap ( 'jet' );
  xlabel ( 'Sx (Seconds/Degree)' );
  ylabel ( 'Sy (Seconds/Degree)' );
  set ( gca, 'TickDir', 'out' );
  hold on;
  plot3 ( slow(cd), slow(r(cd)), ones(size(c)), 'xw',...
          'MarkerSize', 12,...
          'LineWidth', 2 );
  [X,Y] = meshgrid(slow,slow);
  contour3(X, Y, FK, [ frac frac ],'-w');
%
plotname = strcat(Event,'_',Phase,'_FK_Fdet.ps');
print('-dps2', plotname );
[azd,slofd] = cart2pol(slow(cd), slow(rd(cd)));
azd = 90-azd*180/pi;
if azd<0
  azd = azd + 360;
end
%
close all;
%
% Greater than frac Energy region for Fdetector of FK
%
[maxFdet,r] = max(Fdet);
[maxFdet,c] = max(maxFdet);
frac = 0.7;
Fdet = Fdet/maxFdet;
fracmaxFdet = frac;
%
% [row, column]  = max( max( FK ) );
% row is N/S or y and column is E/W or x index
%
[azFdet,sloFdet] = cart2pol( slow(r(c)), slow(c) );
azFdet = azFdet*180/pi;
if azFdet<0
  azFdet = azFdet + 360;
end
%
% Greater than frac Energy region
%
% [row, column]  = find( FK >= fracmaxFK );
% row is N/S or y and column is E/W or x index
%
[iy,ix] = find( Fdet >= fracmaxFdet );
slox = slow( ix );
sloy = slow( iy );
%
[azfrac,slofrac] = cart2pol(sloy,slox);
%
minslo = min(slofrac);
maxslo = max(slofrac);
%
azfrac =  azfrac*180/pi;
[ineg] = find( azfrac < 0 );
azfrac(ineg) = azfrac(ineg) + 360;
minaz = min(azfrac);
%minaz = 90-minaz*180/pi;
%if minaz<0
%  minaz = minaz + 360;
%end
maxaz = max(azfrac);
%maxaz = 90-maxaz*180/pi;
%if maxaz<0
%  maxaz = maxaz + 360;
%end
delslo = abs( maxslo - minslo );
delaz = abs( maxaz - minaz );
%
Fdetnorm = sum ( sum( Fdet( [iy,ix] ) ) );
meanslox = sum( sum( slox * Fdet( [iy,ix] )/Fdetnorm ) );
meansloy = sum( sum( sloy * Fdet( [iy,ix] )/Fdetnorm ) );
stdslox = sum( sum( (slox-meanslox).*(slox-meanslox) * Fdet( [iy,ix] )/Fdetnorm ) );
stdsloy = sum( sum( (sloy-meansloy).*(sloy-meansloy) * Fdet( [iy,ix] )/Fdetnorm ) );
cxy = sum( sum( (slox-meanslox).*(sloy-meansloy) * Fdet( [iy,ix] )/Fdetnorm ) );
[meanaz, meanslo] = cart2pol( meansloy, meanslox );
meanaz = meanaz*180/pi;
if meanaz<0
  meanaz = meanaz + 360;
end
[ azFdet, sloFdet, meanaz, meanslo, delaz, delslo, sqrt(stdslox), sqrt(stdsloy), cxy ]
retaz = meanaz; 
retslofk = meanslo;
%return [az,slofk] ;
return  ;
