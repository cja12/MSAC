function [outFK, outFdet] = fk ( data, samprate, x, y, slow, band )
%FK	Calculate FK transform of array data.
%	OUT = FK(DATA,SAMPRATE,LOC,REF,SLOW,BAND) returns the FK transform 
%	in 2-D slowness space. 
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
%	SLOW is a vector of slowness values (in S/deg) that defines the beam 
%	set. SLOW is used for both N-S and E-W directions. SLOW defaults 
%	to (-40:1:40). 
%
%	BAND is the [low,high] frequency band (in Hz) to use for the beam. 
%	BAND defaults to [0,nyquist]. 
%
%	OUT is the length(SLOW) x length(SLOW) FK matrix. 
%
%	FK(DATA,SAMPRATE,LOC,REF,SLOW,BAND) without an output argument plots 
%	the FK in dB as an image. 

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
if nargin > 4
  if isempty(slow)
    error ( 'SLOW must be a vector.' );
  end
  slow = slow(:)';
else
  slow = (-40:1:40);
end
numslow = size(slow,2);

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
% Create a stopbar.
%
% h = stopbar ( 'Calculating FK', 0, numslow );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the FFT for all waveforms.
% Transpose transform for later use.
%
data = fft(data)';

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get phase delay factors for array
% offsets and slowness grid.
% Use negative slowness to place FK 
% output in the correct quadrant.
%
pdx = x * (-slow);
pdy = y * (-slow);

epdxf = exp( -j * 2 * pi * dfreq * pdx(:) * f );
epdyf = exp( -j * 2 * pi * dfreq * pdy(:) * f );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Preallocate FK matrix.
%
FK = zeros(numslow,numslow);
if ( nargout == 2 )
     Fdet = zeros(numslow,numslow);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate FK for each x,y slowness in a loop.
%
for sx = 1:numslow
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Get phase delays for this x slowness.
  %
  sxx = (sx-1)*numchan + chans;
  epdxfsxx = epdxf(sxx,:);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Delay data for this x slowness.
  %
  epdxfsxx = epdxfsxx .* data;

  for sy = 1:numslow
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get phase delays for this y slowness.
    %
    syy = (sy-1)*numchan + chans;
    epdyfsyy = epdyf(syy,:);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Incorporate delays for this y slowness.
    %
    pdata = epdxfsxx .* epdyfsyy;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Sum delayed data for each frequency, 
    % then square and sum magnitude for all frequencies.
    %
    FK(sy,sx) = sum(abs(sum(pdata)).^2);
    if ( nargout == 2 )
         beam = sum(pdata)/numchan ;
	 for i = 1:numchan
	        pdata(i,:) = pdata(i,:) - beam;
	 end
	 Num = sum(abs(beam).^2);
	 Denom = sum(sum(abs(pdata).^2));
	 Fdet(sy,sx) = Num/Denom;
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Update stopbar.
  %
  % stop = stopbar ( h, sx/numslow );
  %if stop
  %  break;
  %end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Delete stopbar.
%
% stopbar ( h, 'delete' );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot FK if output is not requested.
%
if nargout == 0
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Create figure for plot.
  %
  plotfig = figure...
  (...
    'Name', 'FK'...
  );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Normalize FK.
  %
  FK = FK/max(max(FK));

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Plot FK in dB.
  %
  imagesc ( slow, slow, 10*log10(abs(FK)+eps) );
  axis xy;

  axis image;
  colormap ( 'jet' );
  xlabel ( 'Sx (Seconds/Degree)' );
  ylabel ( 'Sy (Seconds/Degree)' );
  set ( gca, 'TickDir', 'out' );
  hold on;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Plot axes crosshairs.
  %
  plot3 ( slow, zeros(1,numslow), ones(1,numslow), 'w' );
  plot3 ( zeros(1,numslow), slow, ones(1,numslow), 'w' );

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Plot max value.
  %
  [maxFK,r] = max(FK);
  [maxFK,c] = max(maxFK);
  plot3 ( slow(c), slow(r(c)), ones(size(c)), 'xw',...
          'MarkerSize', 12,...
          'LineWidth', 2 );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Otherwise return FK transform.
%
elseif nargout == 1
  outFK = FK;
elseif ( nargout == 2 )
  outFK = FK;
  outFdet = numchan*(numchan-1)*Fdet;
end
