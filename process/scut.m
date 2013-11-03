function [s] = scut(s_in, tmin, tmax)
%
%Cut a SAC object seismogram
%
%Usage:  scut(s, 20, 40);
%
%
[nr nseis] = size(s_in);
%
for ns = 1:nseis
     %
     stmp = s_in(ns);
     %
     istart = round( (tmin - stmp.beg)/stmp.dt + 1);
     if(istart <= 0), istart = 1; end;
     %
     istop = round( (tmax - stmp.beg)/stmp.dt + 1);
     if(istop > stmp.npts), istop = stmp.npts; end;
     %
     nt = stmp.t(istart:istop);
     na = stmp.d(istart:istop);
     %
     % reset the header values
     %
     stmp.beg = (istart-1)*stmp.dt + stmp.beg;
     stmp.b   = stmp.beg;
     stmp.e   = stmp.beg + (length(nt) - 1)*stmp.dt;
     stmp.npts = length(na);
     %
     % replace the data
     %
     clear stmp.d, stmp.t;
     stmp.d = na;
     stmp.t = nt;
     clear na, nt;
     %
     % reset the header values
     %
     if(isfield(stmp,'depmin'))
     	stmp.depmin = min(stmp.d); 
     end
     if(isfield(stmp,'depmax'))
     	stmp.depmax = max(stmp.d); 
     end
     if(isfield(stmp,'depmax'))
     	stmp.depmen = mean(stmp.d);
     end
     s(ns) = stmp;
     %
end
%     
return
% end
