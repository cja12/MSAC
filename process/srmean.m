function x = srmean(s)
%
%srmean:
%
%Remove the mean from the amplitudes in the SAC structure
%
%Usage:
%     x = srmean(s);
%
%
[nr nseis] = size(s);
%
for ns = 1:nseis
    %
    x(ns) = s(ns);
    x(ns).d = s(ns).d - mean(s(ns).d);
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
