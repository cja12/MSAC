function [decon, pred] = wlevel(num, den, level, tshift)
%
%   [decon t] = wlevel(num,den,level,tshift)
%
%   script to perform a water-level stabilized deconvolution
%     of the SAC object den from the SAC object num
%
%   example:
%                  [decon t] = wlevel(m,e,0.001,200)

%
p1 = nextpow2(length(num.d));
n1 = 2^p1;
p2 = nextpow2(length(den.d));
n2 = 2^p2;
n = n1;
if n < n2
   n = n2
end
%
halfpts = n / 2;
%
dt = num.t(2) - num.t(1);
nyquist = 1 / (2 * dt);
df = 1 / (n * dt);
fpos = df * (0:halfpts);
fneg = fpos(2:halfpts) - nyquist;
f = [fpos fneg];
%
%  compute a time shift
%
shift = exp(sqrt(-1)*2*pi*f*tshift);
%
Xn = fft(num.d,n);
Xd = fft(den.d,n);
%
TOP    = Xn .* conj(Xd) .* shift';
BOTTOM = Xd .* conj(Xd);
amax   = level * max(BOTTOM);
%
for i=1:length(BOTTOM)
   if BOTTOM(i) < amax
      BOTTOM(i) = amax;
   end
end
%
pred = num;
%
TOP    = TOP ./ BOTTOM;
predd   = n*real(ifft(TOP .* Xd .* conj(shift')*dt*df));
res    = ( num.d - predd(1:length(num.d) ));
misfit = res'*res / (num.d'*num.d);
disp(sprintf('The Water-Level Fractional L2 misfit is %.5f',misfit));
%
np = length(pred.d);
pred.d = predd(1:np);
%
% create a deconvolution structure for the return
%
decon.d = n*real(ifft(TOP)*df);
%
decon.fit = 100*(1-misfit);
decon.t = (dt * (0:n-1) - tshift)';
decon.dt = dt;
decon.beg = -tshift;
decon.e = decon.t(n);
decon.a = 0;
decon.npts = n;
decon.type = 'wlevel';
