function ok = wsac( s, file, pathname )
% RSAC writes the data from a binary SAC time series file
%
% format wsac(s,['file']); "s" is a SAC structure!
% To see the data once you've read it, type plot(s.t,s.d)
%

ok = 1;
%
if nargin < 2
	[file, pathname] = uiputfile('*', 'Name the SAC file', 10, 10);
	if file == 0                          % cancel chosen in uigetfile
		return;
	end
	if isunix
	  eval(['cd ' pathname]); 
	else
		cd(pathname);
	end
%
elseif nargin > 2
  	if s                                  % error return from cd
    	disp('Usage: wsac(s, filename, pathname)');
    	disp(['       pathname: ', pathname]);
    	return
  	end
end
%
fid = fopen(file, 'w');
if ( fid > 0 )
   fwrite(fid, s.dt, 'float');
   fwrite(fid,min(s.d),'float');
   fwrite(fid,max(s.d),'float');
   wundeff(fid,2);
   fwrite(fid, s.beg, 'float');
   fwrite(fid, s.e, 'float');
   fwrite(fid, s.o, 'float');
   fwrite(fid, s.a, 'float');
   fwrite(fid, -12345, 'float');
   fwrite(fid, s.picks(1:10), 'float');
   wundeff(fid,11);
   fwrite(fid, s.stla, 'float');
   fwrite(fid, s.stlo, 'float');
   fwrite(fid, s.stel, 'float');
   fwrite(fid, s.stdp, 'float');
   fwrite(fid, s.evla, 'float');
   fwrite(fid, s.evlo, 'float');
   fwrite(fid, s.evel, 'float');
   fwrite(fid, s.evdp, 'float');
   fwrite(fid, s.mag , 'float');
   fwrite(fid, s.user(1:10), 'float');
   fwrite(fid, s.dist, 'float');
   fwrite(fid, s.az, 'float');
   fwrite(fid, s.baz, 'float');
   fwrite(fid, s.gcarc, 'float');
   wundeff(fid,16);
   fwrite(fid, s.nz(1:6), 'int');
   fwrite(fid,6,'int'); % SAC version number
   fwrite(fid, 0, 'int'); % norid
   fwrite(fid, 0, 'int'); % nevid
   fwrite(fid, s.npts, 'int');
   wundefi(fid,5);
   fwrite(fid, 1, 'int');   
   wundefi(fid,19);
   fwrite(fid, 1, 'int'); % leven
   fwrite(fid, 1, 'int'); % lpsol
   fwrite(fid, 1, 'int'); % lovrok
   fwrite(fid, 1, 'int'); % lcalda
   fwrite(fid, -12345, 'int');
   %
   fprintf(fid,sprintf('%8.8s',s.kstnm),'char');
   fprintf(fid,sprintf('%16.16s',s.kevnm),'char');
   %
   for i=1:21
	      fprintf(fid,'        ','char'); % I'm writing blank strings
   end
   %
   % write in the floating point values
   %
   fwrite(fid, s.d(1:s.npts), 'float'); 
   %
   st = fclose(fid);     
else
  disp(['Error reading file ', file]);
   st = fclose(fid);     
  return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function wundefi(fid, n)
% function writes -12345 n times
iundef = -12345;
for i=1:n
	fwrite(fid,iundef,'int');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function wundeff(fid, n)
% function writes -12345 n times
fundef = -12345;
for i=1:n
	fwrite(fid,fundef,'float');
end
