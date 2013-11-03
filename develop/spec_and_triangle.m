nft = 2^ nextpow2(s.npts);
df = 1 / (nft * s.dt);
halfpts = nft / 2;
f = (0:halfpts) * df;
%
X = fft(s.d,nft)/nft;
%
w = triangle(s.npts);
sw = s.d .* w';
Y = fft(sw,nft)/nft;
%
n = halfpts+1;
plot(f,abs(X(1:n)),'r',f,abs(Y(1:n)),'k');
axis tight; grid on;
