function [decon] = iterdecon(xi,yi,dt,shift,tw,niter,tol)
%
%  [decon, misfit] = iterdecon(xi,yi,dt,shift,tw,niter,tol)
%
%   iteratively deconvolve x from y
%
%     y(t) = s(t) * x(t), find s(t)
%
%   the time function estimated by this routine is a sum of triangles
%   with a single width, specified by the user. The triangle width
%   is really only accurate for a width that is an odd multiple of dt.
%
%   example:
%      [decon misfit] = iterdecon(x,y,t,25, 13,0.001);
%
%   xi is the wavelet, 
%   yi is the signal from which x will be deconvolved
%   shift is the amount x is shifted left and y is shifted right
%   dt is the sample rate
%   tw is the triangle width
%   niter is the number of iterations (bumps)
%   tol is the maximum fractional misfit to accept
%
nrp = 2;
ncp = 3;
np = 1;
%
% put the triangle into the "egf" or whatever it is.
%
x = [xi' zeros(1,shift)]';
y = [zeros(1,shift) yi']';
t = dt * (1:length(y));
dd = trifilter(x,tw,dt);
w = dd(1:length(x)); clear dd;
%
%dd = trifilter(y,tw,dt);
%yt = dd(1:length(y));clear dd;
yt = y;
res = yt;
s = zeros(length(w),1);
misfit = zeros(niter,1);
%
w0 = sum(w.*w);
y0 = sum(yt.*yt);
%
%------------------------------------------------------------
subplot(nrp,ncp,np); 
plot((1:length(w))*dt,w/max(w) - 0.6,t,yt/max(yt)+0.6);
np=np+1;axis tight;grid on;xlabel('Time (s)');
%legend('Observed','Wavelet',0);
%------------------------------------------------------------
%
[rxx lxx] = sccor(w,w,t);
[rxy lxy] = sccor(w,yt,t);
rxy       = rxy * sqrt(w0 * y0);
%
for i = 1:niter
   np = 2;
   % 
   %  cross correlate the wavelet, w, with
   %  the residual vector to find the next bump.
   %
   [rwr lwr] = sccor(res,w,t);
%------------------------------------------------------------
   subplot(nrp,ncp,np); plot(lwr,rwr,'k-');np=np+1;
   title('Cross Correlation');xlabel('Lag (s)');
   axis tight;grid on;
%------------------------------------------------------------
   % find the max value and lag index
   % only positive lags right now
   lmax = 45;lmin=1;
   %[theamp ilag] = max(rwr(1:(length(rwr)/2)));
   [theamp ilag] = max(rwr(lmin:lmax));
   theamp = theamp * sqrt(w0 * sum(res.* res));
   %
   % compute the index for the spike in the time function
   %
   thelag = lwr(ilag);
   %
   theindex = round(thelag / dt) + 1;
   %
   %
   theamp = (theamp / w0);
   %
   s(theindex) = s(theindex) + theamp;
   %
   %  compute the predictions
   %
   clear p; p = real( vconv(s,w,dt) );
 %------------------------------------------------------------
   subplot(nrp,ncp,np); plot(t,yt,t,p);grid on;
   xlabel('Time (s)');
   legend('Observed','Predicted',0); axis tight;
   np = np + 1;
 %------------------------------------------------------------
  %
   misfit(i) = sum((yt-p).*(yt-p))/y0;
 %------------------------------------------------------------
   decon.spikes(i) = theamp;
   decon.lags(i) = thelag;
 %------------------------------------------------------------
   subplot(nrp,ncp,np);
   plot((1:i),misfit(1:i),'ko-');title('Fractional Misfit');
   xlabel('Iteration'); np = np+1; grid on; axis([0 niter+1 0 1]);
 %------------------------------------------------------------
   %
   disp(sprintf('%03d %10.3f %10.3f %10f (%3.f)',i,theamp,thelag-shift,misfit(i),100*(1-misfit(i))));
   %
   res = yt - p;
 %------------------------------------------------------------
   subplot(nrp,ncp,np); plot(t,yt,t,res); 
   grid on; axis tight;
   %legend('Observed','Residual',0); 
   np = np+1;
 %------------------------------------------------------------
   %
   decon.d = trifilter(s,tw,dt);
   decon.t = dt*(0:(length(decon.d)-1))-shift;
   
 %------------------------------------------------------------
   subplot(nrp,ncp,np);plot(decon.t,decon.d,'k-');np = np+1;
   xlabel('Time (s)');
   axis([ -shift 100 [-0.1 1.1]*max(decon.d) ]);
   grid on; 
   mylabel = sprintf('Deconvolution (Triangle Width = %.1f)',tw);
   title(mylabel);
   
 %------------------------------------------------------------
   drawnow;
   if(misfit(i) < tol) break; end
   if(i > 1) if(misfit(i-1,1) < misfit(i)) break; end; end;
end
%
% create a deconvolution structure for the return
%
decon.fit = 100*(1-misfit(1:i));
decon.dt = dt;
decon.beg = -shift;
decon.a = 0;
decon.npts = length(decon.d);
decon.e = decon.t(decon.npts);
decon.type = 'iterdecon';
% 
% see also decon.lags, decon.spikes listed above (lines 118 and 119)
