function [outSemblance] = semblance ( data, samprate, x, y, az, slow, band )
%FK	Calculate Semblance of array data.
%	Semblance = semblance(DATA,SAMPRATE,LOC,REF,SLOW,BAND) returns the Semblance 
%
%	DATA is an N-column matrix of data vectors for the array. 
%
%	SAMPRATE is the scalor sample rate of all data vectors. 
%
%	LOC is the N-row matrix of station locations [lat,lon]. 
%
%       X and Y are the offsets in degs of the elements of the array
%       relative to a reference point
%
%	AZ is the azimuth of approach
%
%	SLOW is the slowness in sec/km 
%
%	BAND is the [low,high] frequency band (in Hz) to use for the beam. 
%	BAND defaults to [0,nyquist]. 
%
%	OUT is the Semblance over the band 
%
%       modified from fk.m by G.E. Randall, EES-11 LANL
%	MatSeis 1.6
%	Julian Trujillo, jrtruji@sandia.gov
%	Chris Young, cjyoung@sandia.gov
%	Mark Harris, mharris@sandia.gov
%	Copyright (c) 1996-2001 Sandia National Laboratories. All rights reserved.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check arguments.
%
if nargin < 4
  error ( 'Not enough arguments.' );
end
if size(data,2) < 2
  error ( 'DATA must be an N-column matrix.' );
end
samprate = samprate(1);         %problems if different sample rates!!!!
if size(x,1) ~= size(data,2) & size(y,1) ~= size(data,2) 
  error ( 'rows of LOC must match columns of DATA.' );
end
if nargin > 5
  if any ( size(band) ~= [1,2] )
    error ( 'BAND must be a 1x2 frequency band vector.' );
  end
  if any ( band < 0 ) | any ( band > samprate/2 ) | min(band) == max(band)
    error ( 'BAND is out-of-range.' );
  end
else
  band = [ 0 samprate/2 ];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the FFT for all waveforms.
% Transpose transform for later use.
%
[ Ndata, Mchan ] = size( data );
N2pow = 2^( nextpow2(Ndata) );

data = fft(data,N2pow)';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get frequency index limits.
%
dfreq = samprate/size(data,2);
lfreq = ceil(min(band)/dfreq) + 1;
hfreq = floor(max(band)/dfreq) + 1;

f = lfreq:hfreq;
data = data(:,f);
numchan = size(data,1);
chans = 1:numchan;

slowx = slow * cos( az ) ;
slowy = slow * sin( az ) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get phase delay factors for array
% offsets and slowness grid.
% Use negative slowness to place FK 
% output in the correct quadrant.
%
pdx = x * (-slowx);
pdy = y * (-slowy);

epdxf = exp( -j * 2 * pi * dfreq * pdx(:) * f );
epdyf = exp( -j * 2 * pi * dfreq * pdy(:) * f );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocate Semblance matrix.
%
Semblance = zeros( (hfreq - lfreq + 1) );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate Semblance for each x,y slowness in a loop.
%
%for sx = 1:numslow
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Get phase delays for this x slowness.
  %
  %sxx = (sx-1)*numchan + chans;
  %epdxfsxx = epdxf;
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Delay data for this x slowness.
  %
  epdxf = epdxf .* data;

  %for sy = 1:numslow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get phase delays for this y slowness.
    %
    %syy = (sy-1)*numchan + chans;
    %epdyfsyy = epdyf;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Incorporate delays for this y slowness.
    %
    pdata = epdxf .* epdyf;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sum delayed data for each frequency, 
    % then square and sum magnitude for all frequencies.
    %
    %FK(sy,sx) = sum(abs(sum(pdata)).^2);
    %if ( nargout == 2 )
         beam = sum(pdata) ;
	 %for i = 1:numchan
	 %       pdata(i,:) = pdata(i,:) - beam;
	 %end
	 Num = abs(beam).^2;
	 Denom = sum(abs(pdata).^2);
	 Denom = Denom + 0.0001*max(Denom); 
	 outSemblance = Num ./ Denom;
    %end
  %end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Update stopbar.
  %
  % stop = stopbar ( h, sx/numslow );
  %if stop
  %  break;
  %end

%end

return  ;
