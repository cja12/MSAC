function x = sdif(s)
%
%sdif:
%
%Differentiate the signal in a SAC structure
%
%Usage:
%     x = sdif(s);
%
%
[nr nseis] = size(s);
%
for ns = 1:nseis
    %
    x(ns) = s(ns);
    n = x(ns).npts - 1;
    dh = 1.0/x(ns).delta;
    for i=1:n
        x(ns).d(i) = (x(ns).d(i+1) - x(ns).d(i))*dh;
    end
    x(ns).d(n+1) = x(ns).d(n);
    %
    % reset the header amplitude values
    %
    x(ns).depmin = min(x(ns).d); 
    x(ns).depmax = max(x(ns).d); 
    x(ns).depmen = mean(x(ns).d);
    %
end
%
return
