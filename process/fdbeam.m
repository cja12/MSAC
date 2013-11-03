function [ beam, Fdet, res ] = fdbeam ( data, samprate, x, y, azimuth, slowness, nthroot )
%FDBEAM	Frequency Domain Time-delay beamformer.
%	[ BEAM, Fdet ] = FDBEAM(DATA,SAMPRATE,LOC,REF,AZIMUTH,SLOWNESS,NTHROOT) returns 
%	the time-delay-and-sum beam of DATA to the direction defined by 
%	AZIMUTH and SLOWNESS. 
%	FDBEAM will beam to one direction with each call. 
%
%	DATA is an N-column matrix of data vectors. 
%	SAMPRATE is the scalor sample rate of all data vectors. 
%
%       X and Y are the offsets in degs of the elements of the array
%       relative to a reference point in km

%	AZIMUTH is the scalor beam azimuth clockwise from north (in degrees). 
%	SLOWNESS is the scalor beam slowness (in sec/km). 
%
%	NTHROOT is an optional parameter that specifies the root factor 
%	for Nth root robust stacking (Muirhead & Datt, 1976, GJRAS #47).
%
%	BEAM is a column vector of the data beamed to AZIMUTH and SLOWNESS. 
%
%       Fdet is a column vector of the F detector value (Blandford, 197X, Geophysics VYY).
%
%       res is the N-column matrix of residual vectors

%	MatSeis 1.6
%       George Randall, grandall@lanl.gov
%       Based on tdbeam.m of:
%	Mark Harris, mharris@sandia.gov
%	Copyright (c) 1996-97 Sandia National Laboratories. All rights reserved.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check arguments.
%
if nargin < 6
  error ( 'Not enough arguments.' );
end
if size(data,2) < 2
  error ( 'DATA must be an N-column matrix.' );
end
samprate = samprate(1);         %problems if different sample rates!!!!
if size(x,1) ~= size(data,2) & size(y,1) ~= size(data,2)
  error ( 'rows of LOC must match columns of DATA.' );
end
azimuth = azimuth(1);
slowness = slowness(1);
if nargin < 7
  nthroot = 0;
else
  nthroot = nthroot(1);
end

if nargout == 3
  resret = 1;
else
  resret = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup data, beam, rsidual matrcies.
% Zero padding is in FFT if N2pow > Ndata
%

[ Ndata, Mchan ] = size( data );
N2pow = 2^( nextpow2(Ndata) );

bias = mean(data);
for m = 1:Mchan
   data(:,m) = data(:,m) - bias(m) ;
end

dataf = fft(data,N2pow).';

beam = zeros(Mchan,N2pow);
Fdet = zeros(Ndata,1);
residual = zeros(Mchan,N2pow);

Fwin = 3.0;
Fwino2 = Fwin/2.;
Tdata = Ndata / samprate;
Nwin = fix( 2.*Tdata/Fwin - 1 ) ;
Toff = Fwino2 * samprate;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate time delays (integer number of samples to shift).
%

slowx = slowness * sin( azimuth*pi/180 ) ;
slowy = slowness * cos( azimuth*pi/180 ) ;
delayx = x .* slowx ;
delayy = y .* slowy ;
delay = delayx + delayy ;

dfreq = samprate/N2pow;		% delta freq for this transform size
f = [ 0.:1:N2pow/2 -(N2pow/2 - 1):1:-1 ] ;
delayfr = delay * f ;
% edelay = exp( -j * 2 * pi * dfreq * delay .* f );
edelay = exp( -j * 2 * pi * dfreq * delayfr );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Shift data.
%

beam = dataf .* edelay;
residual = beam ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stack and average beam.
%

beam = sum ( beam ) / Mchan;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Form Residuals at each station
%

for m = 1:Mchan
   residual(m,:) = residual(m,:) - beam ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse FFT's for Beam and residuals into Time domain
%

residual = real( ifft(residual.',N2pow) );

if resret == 1
   res = residual(1:Ndata,:);
end

beam = real( ifft(beam,N2pow).' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute the F detector waveform
%

for i = 1:Nwin
    i1 = round( (i-1)*Toff +1 );
    i2 = round( i1 + 2*Toff );
    BeamEv = sum( beam(i1:i2).^2 ) ;
    Fval = (Mchan - 1) * BeamEv ;
    %DatSq =  sum( data(i1:i2,:).^2 );
    %Fval = Fval / ( sum( DatSq )/Mchan - BeamEv );
    ResSq = sum( sum( residual(i1:i2,:).^2 ) );
    Fval = Mchan * Fval / ( ResSq ) ;
    Fdet(i1:i2,1) = Fval;
end

