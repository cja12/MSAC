function x = sint(s)
%
%sint:
%
%Integrate the signal in a SAC structure
%
%Usage:
%     x = sint(s);
%
%
[nr nseis] = size(s);
%
for ns = 1:nseis
    %
    x(ns) = s(ns);
    dh = 1.0/x(ns).delta;
    x(ns).d = dh*cumsum(s(ns).d);
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
