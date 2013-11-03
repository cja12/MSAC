function pr = pratioFromVpVs(Vp,Vs)
% Compute Poisson's Ratio from Vp and Vs. If you know the Vp/Vs ratio, set
% Vp to the ratio value and Vs to 1.0.

if(Vs == 0)
    pr = 0.5;
else
    k = Vp./Vs;
    ksq = k.*k;
    pr = (ksq-2.0)./(2.0*ksq-2.0)
end
%