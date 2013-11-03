function [ AvgSpec, AvgNoiseSpec, SNR, band ] = DoArrSpec(s,PhaseOn,PhaseOff,NoiseOn,NoiseOff,Event,Phase)
%
% Count the number of Sac Structures in the Array
%
[r,c] = size(s) ;
%
% Cut (eventually the Phase of interest), rmean and plot
%
sc = scut(s,PhaseOn,PhaseOff);
sc = srmean(sc);
% p1sac(sc);
sc = staper(sc,.1);
sc = srmean(sc);
time = sc(1).t;
close all;
npts = size(sc(1).d);
npts = npts(1);
%
% Copy SAC waveforms for FFT
%
for n=1:c
    data(:,n) = sc(n).d ;
end
dt = getfield( sc(1), 'delta' );
samprate = ( 1.00 / dt );
%x = delx' ;
%y = dely' ;
N2pow = 2^( nextpow2(npts) );
%
% FFT and compute average Spectral Amplitude over array for Signal window
%
Spec = abs( fft( data, N2pow) );
AvgSpec = sum( Spec' );
%
% Cut (eventually the Noise of interest), rmean and plot
%
sc = scut(s,NoiseOn,NoiseOff);
sc = srmean(sc);
% p1sac(sc);
sc = staper(sc,.1);
sc = srmean(sc);
npts = size(sc(1).d);
%
% Copy SAC waveforms for FFT
%
for n=1:c
    ndata(:,n) = sc(n).d ;
end
%dt = getfield( sc(1), 'delta' );
%samprate = ( 1.00 / dt );
%N2pow = 2^( nextpow2(npts) );
%
% FFT and compute average Spectral Amplitude over array for Signal window
%
NoiseSpec = abs( fft( ndata, N2pow) );
AvgNoiseSpec = sum( NoiseSpec' );
%   
%
%   
close all;
%figure(1);
fmin = 0;
fmax = samprate/2.0 ;
delf = samprate / N2pow;
xlim([ fmin fmax ]);
freq = linspace(delf,fmax,N2pow/2);
%subplot(2,1,1);
figure(1);
%plotname = strcat(Event,'_',Phase,'_Array.ps');
%print('-dps2', plotname );
loglog(freq,AvgSpec(2:N2pow/2+1),freq,AvgNoiseSpec(2:N2pow/2+1)); 
xlim([ 0.1 fmax ]);
title( strcat('Event:   ',Event,'  Phase:   ',Phase,'  Spectra') );
xlabel( 'Frequency (Hz)' );
ylabel( 'Spectral Amplitude (counts/Hz)' );
%axis([fmin fmax]);
%
plotname = strcat(Event,'_',Phase,'_Spectra.ps');
print('-dps2', plotname );
%
SNR = 20.* ( log10(AvgSpec) - log10(AvgNoiseSpec) );
SSNR = medfilt1(SNR,11);
figure(2);
%semilogx(freq,SNR(2:N2pow/2+1),freq,SSNR(2:N2pow/2+1));
semilogx(freq,SSNR(2:N2pow/2+1));
xlim([ 0.1 fmax ]);
title( strcat('Event:   ',Event,'  Phase:   ',Phase,'  Spectra') );
xlabel( 'Frequency (Hz)' );
ylabel( 'SNR (dB/Hz)' );
%
plotname = strcat(Event,'_',Phase,'_SNR.ps');
print('-dps2', plotname );
%
maxSSNR = max(SSNR(2:N2pow/2+1));
level = maxSSNR - 6. ;
indicies = find( SSNR(2:N2pow/2+1) > level );
bandmin = delf * min(indicies);
bandmax = delf * max(indicies);
band = [ bandmin bandmax ];
