function theTimes = first_arrival(v,th,x,z)
%
%   function to compute the first arrival time 
%     for a surface source to the distances in 
%     the vector x.
%   

%
for i=1:length(x)
	vmax = v(1);
	tmin = 1e6;
	% find the fastest head-wave
	for j = 2:length(v)
		if(v(j) > vmax)
			vmax = v(j);
			p = 1 / vmax;
			tt = headwavett(v(1:j),th(1:j),x(i));
			if(tt < tmin)
				tmin = tt;
				lmin = j;
			end
		end
	end
	theTimes(i) = tmin;
end
			
			
function tt = headwavett(v,th,x)
%
% do the vertical travel time
%

lyr = length(v);
%
vtt = 0;
psquared = 1/(v(lyr)*v(lyr));
for i = 1:lyr-1
	vtt = vtt + th(i) * sqrt(1/(v(i)*v(i)) - psquared);
end
%
% add the horizontal phase delay
%
tt = 2 * vtt + x / v(lyr);
%
