function tri = triangle(npts)
%
%Compute and return a triangle
%
%  If the number of points is odd, the center
%    point has an amplitude of 1.0
%
%  If the number of points is even, the two middle
%    points have equal values, less than one. The triangle
%    "peaks" between these samples.
%
%  It's best to call this with an odd number of points.
%
%  Example: mytriangle = triangle(35);

m = npts;
m2 = round( npts / 2) ;
% compute the window
tri(1:m) = 1;
%
if mod(m,2) == 1
	tri(1:m2) = (0:(m2-1))/(m2-1);
	tri((m2+1):m)=(m-((m2+1):m))/(m2-1);
else
	tri(1:m2) = (0:(m2-1))/(m2);
	tri((m2+1):m)=(m-((m2+1):m))/(m2);
end
