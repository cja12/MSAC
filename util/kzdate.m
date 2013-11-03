function [theDate, theNum] = kzdate(s)
%
%   s is a SAC structure 
%
%
    theNum  = datenum(s.nz(1),0,s.nz(2),s.nz(3),s.nz(4),s.nz(5)+s.nz(6)/1000);
	v       = datevec(theNum);
	d       = datestr(datenum(v(1),v(2),v(3)));
	theDate = sprintf('%s %02d:%02d:%02.3f',d,v(4),v(5),v(6));
	
