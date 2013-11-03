function [theCentroid] = scentroid(s_in)
%
%Compute the centroid of SAC object seismogram
%
%Usage:  scentroid(s);
%
s = s_in;
%
numerator = s.t' * s.d * s.dt;
denominator = sum(s.d) * s.dt;
if denominator == 0
	disp('Problem in scentroid, area of function is zero.');
	theCentroid = -1e9;
	return;
end
%
theCentroid = numerator / denominator;
%
