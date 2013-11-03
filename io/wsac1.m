function ok = wsac1(file,amps,dt,beg)
%
%   write out an array as a simple SAC file
%
%  George Randall (LANL) and Charles J Ammon (Penn State)
%

ok = 1;
h = sacheader;
h.npts = length(amps);
h.dt = dt;
h.beg = beg;
h.d = amps;
h.depmen = mean(amps);
h.depmax = max(amps);
h.depmin = min(amps);

ok = wsac(h,file);
