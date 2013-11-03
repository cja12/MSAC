function [a,b,r,h] = rdm96(file)
%
%   function to parse a seismic model in M96 format
%
%   see also plotlayers(v,h)
%
%   a = P-velocity
%   b = S-velocity
%   r = density
%   h = thickness
%

if nargin < 1
	[file, pathname] = uigetfile('*', 'Choose a M96 format file', 10, 10);
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
mystring = fgetl(fid);
for i=1:11
    astring = fgetl(fid);
end
disp(sprintf('Model Name: %s\n',mystring));
%
A = fscanf(fid,'%f',[10,Inf]);
A = A';
a = A(:,2); b = A(:,3); r = A(:,4); h = A(:,1);
%
fclose(fid);
