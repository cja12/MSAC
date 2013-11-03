function [Semblance] = DoSemblance(s,Phcut1,Phcut2,Event,Phase,az,slow,band)
%
% Outputs - Semblance
%           Semblance array of semblance vs freq over band
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
%band = [2, 4];
%
% Compute Semblance for the cut waveform
%   
[Semblance] = semblance ( data, samprate, x, y, az, slow, band );
% Normalize FK.
%
%FK = FK/max(max(FK));
% Plot FK in dB.
%
close all;
figure(2);
[dum, numSem] = size( Semblance );
frq = linspace( band(1), band(2), numSem );
%plot( frq, Semblance );
loglog( frq, Semblance );
xlim([.1 20.]);
xlabel( 'Frequency (Hz)' );
ylabel( 'Semblance' );
title( strcat('Event:   ',Event,'  Phase:   ',Phase,'  Semblance') );
%orient landscape ;
plotname = strcat(Event,'_',Phase,'_','Semblance.ps');
print('-dps2', plotname );

%menucbar;
return  ;
