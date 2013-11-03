function [ C, z, x ] = c_expandv(v_in,th,dz,nterms)
%
%  function to expand a velocity structure into
%    a sum of chebyshev polynomials
%
%       v_in is the velocity model
%       th is the vector of layer thicknesses
%       dz is the depth sampling rate
%       nterms is the number of terms in the expansion
%

% first resample the model to evenly spaced values
nlyrs      = length(v_in);
mystring = sprintf('The input model has %d layers',nlyrs);
disp(mystring)
%
% convert layer thicknesses to depths
%
depth = zeros(nlyrs,1);
for i = 2:nlyrs
	depth(i) = depth(i-1) + th(i);
end
%
[v, z] = sample_evenly(v_in,depth,dz);
%
plot(depth,v_in,z,v)
%xlim([0 50])
x = (z+0.5*dz) / (max(z+dz));
%
dx = x(2) - x(1);
%
% compute the weight function fo the Tn(x)
w  = sqrt(1 - (x .* x));
%
% compute the Chebyshev Polynomials
%
%
T      = ones(nterms,length(v));
T(2,:) = x;
%
for i = 3:nterms
	T(i,:) = ( 2 * x .* T(i-1,:) - T(i-2,:));
end
% 
% compute the coefficients
%
C = zeros(1,nterms); % a vector of coefficients
%
% skip the first term - it's too hard to integrate numerically
%    instead, remove the mean from the velocity and 
%    put it back later.
vtmp = v - mean(v);
%
C(1) = mean(v);
for i = 2:nterms
	f = vtmp .* T(i,:) ./ w;
	norm = trapz(x,T(i,:) .* T(i,:) ./ w); % numerical normalization
	C(i) = (1/norm) * trapz(x,f);  % Integrate Normalization for Tn
	vtmp = vtmp - C(i) * T(i,:); % it's more stable if you remove the
								 %   components you've already mapped
end
							 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function [xe, ze] = sample_evenly(x,z,dz)
%
%   sample the unevenly sample values in x and z
%      with an even sampling of dz
%

npts = length(x);
%
if(length(z) ~= npts)
	error = sprintf('Message from sample_even: x and z must have same number of points.');
	disp(error);
	return
end
%
n  = (z(npts) - z(1)) / dz + 1;
ze = z(1) + (0:n-1)*dz;
xe = zeros(n,1);
%
for i = 1:n
	j = 1;
	while (ze(i) > z(j)) & (j <= npts)
		j = j + 1;
	end
	xe(i) = x(j);
end
xe = xe';



