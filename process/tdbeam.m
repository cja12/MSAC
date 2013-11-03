function beam = tdbeam ( data, samprate, x, y, azimuth, slowness, nthroot )
%TDBEAM	Time-delay beamformer.
%	BEAM = TDBEAM(DATA,SAMPRATE,LOC,REF,AZIMUTH,SLOWNESS,NTHROOT) returns 
%	the time-delay-and-sum beam of DATA to the direction defined by 
%	AZIMUTH and SLOWNESS. 
%	TDBEAM will beam to one direction with each call. 
%
%	DATA is an N-column matrix of data vectors. 
%	SAMPRATE is the scalor sample rate of all data vectors. 
%
%       X and Y are the offsets in degs of the elements of the array
%       relative to a reference point

%	AZIMUTH is the scalor beam azimuth clockwise from north (in degrees). 
%	SLOWNESS is the scalor beam slowness (in S/deg). 
%
%	NTHROOT is an optional parameter that specifies the root factor 
%	for Nth root robust stacking (Muirhead & Datt, 1976, GJRAS #47).
%
%	BEAM is a column vector of the data beamed to AZIMUTH and SLOWNESS. 

%	MatSeis 1.6
%	Mark Harris, mharris@sandia.gov
%	Copyright (c) 1996-2001 Sandia National Laboratories. All rights reserved.


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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup beam matrix.
%
data = data';
[M,N] = size(data);
beam = zeros(M,N);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate time delays (integer number of samples to shift).
%

dist = sqrt(x.^2 + y.^2);
az = 90 - rad2deg(atan2(y,x));      %includes conversion to seismo az 
delay = round ( ( dist*slowness ) .* cos ( (az-azimuth)*pi/180 ) .* samprate );
delay1 = max(delay,zeros(M,1));
delay2 = min(delay,zeros(M,1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate beam index.
%
b1 = delay1 + 1;
bN = delay2 + N;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate data vector index.
%
d1 = - delay2 + 1;
dN = - delay1 + N;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check Nth root.
%
if nthroot
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Shift data.
  %
  for m = 1:M
    wdata = data(m,d1(m):dN(m));
    wdata = ( sign(wdata) ) .* ( abs(wdata) .^ (1/nthroot) );
    beam(m,b1(m):bN(m)) = wdata;
  end
else
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Shift data.
  %
  for m = 1:M
    beam(m,b1(m):bN(m)) = data(m,d1(m):dN(m));
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Stack and average beam.
%
beam = sum ( beam ) ./ M;
beam = beam';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check Nth root.
%
if nthroot
  beam = ( sign(beam) ) .* ( abs(beam) .^ nthroot );
end
