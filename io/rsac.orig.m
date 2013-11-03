function s = rsac( file, pathname )
% RSAC reads the data from a binary SAC time series file
%
% format s = readsac('file'); Returns a structure!
% To see the data once you've read it, type plot(s.t,s.d)
%
if nargin < 1
	[file, pathname] = uigetfile('*', 'Choose a SAC file', 10, 10);
	if file == 0                          % cancel chosen in uigetfile
		return;
	end
	if isunix
	  eval(['cd ' pathname]); 
	else
		cd(pathname);
	end
%
elseif nargin > 1
  	if s                                  % error return from cd
    	disp('Usage: readsac(filename, pathname)');
    	disp(['       pathname: ', pathname]);
    	return
  	end
end
%
fid = fopen(file, 'r');
if ( fid > 0 )
   s.dt = fread(fid, 1, 'float');
   status = fseek(fid, 4*4, 'cof'); % skip an internal value
   s.beg = fread(fid, 1, 'float');
   s.e = fread(fid, 1, 'float');
   s.o = fread(fid, 1, 'float');
   s.a = fread(fid, 1, 'float');
   status = fseek(fid, 1*4, 'cof'); % skip an internal value
   s.picks = fread(fid, 10, 'float');
   status = fseek(fid, 11*4, 'cof'); % skip an internal value
   s.stla = fread(fid, 1, 'float');
   s.stlo = fread(fid, 1, 'float');
   s.stel = fread(fid, 1, 'float');
   s.stdp = fread(fid, 1, 'float');
   s.evla = fread(fid, 1, 'float');
   s.evlo = fread(fid, 1, 'float');
   s.evel = fread(fid, 1, 'float');
   s.evdp = fread(fid, 1, 'float');
   s.mag  = fread(fid, 1, 'float');
   s.user = fread(fid, 10, 'float');
   s.dist = fread(fid, 1, 'float');
   s.az = fread(fid, 1, 'float');
   s.baz  = fread(fid, 1, 'float');
   s.gcarc = fread(fid, 1, 'float');
   status = fseek(fid, 16*4, 'cof'); % skip an internal value
   s.nz = fread(fid, 6, 'int');
   status = fseek(fid, 3*4, 'cof'); % skip an internal value
   s.npts = fread(fid, 1, 'int');
   status = fseek(fid, 30*4, 'cof'); % skip an internal value
   s.kstnm = fscanf(fid,'%8s',1);
   s.kevnm = fscanf(fid,'%16s',1);
   %
   % read in the floating point values
   %
   status = fseek(fid, 632, 'bof');
   [s.d, nread] = fread(fid, Inf, 'float'); 
   % build a time array - clear it if you are using lots of memory
   %
   s.t = [s.beg:s.dt:s.beg+s.dt*(length(s.d)-1)]';
   % compute some values of the min,max,mean
   s.depmin = min(s.d);
   s.depmax = max(s.d);
   s.depmen = mean(s.d);
   s.filename = file; 
   s.mytype = 'SAC_STRUCTURE';
   st = fclose(fid);     
else
  disp(['Error reading file ', file])
   if(fid ~= -1)
    st = fclose(fid);  
   end
  return
end
