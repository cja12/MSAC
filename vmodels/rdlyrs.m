function [a,b,r,h] = rdlyrs(file)
%
%   function to parse a seismic model in TJO format
%
%   a = P-velocity
%   b = S-velocity
%   r = density
%   h = thickness
%

if nargin < 1
	[file, pathname] = uigetfile('*', 'Choose a TJO format file', 10, 10);
	if file == 0                          % cancel chosen in uigetfile
		return;
	end
	%
	if isunix
	  eval(['cd ' pathname]); 
	else
		cd(pathname);
	end
%
elseif nargin > 1
  	if s                                  % error return from cd
    	disp('Usage: rdlyrs(filename)');
    	return
  	end
end
%

fid = fopen(file,'rt');
nlyrs = fscanf(fid,'%4d')
mystring = fgetl(fid);
disp(sprintf('Model Name: %s',mystring));
%
A = fscanf(fid,'%f',[9,nlyrs]);
A = A';
a = A(:,2); b = A(:,3); r = A(:,4); h = A(:,5);
%
fclose(fid);
