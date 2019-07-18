function [ err ] = fGetErrPhi(h,Qb,w,m)
% Error propagation analysis for lateral flow contraction

% INPUT: 


% OUTPUT:
% err [m³/s] discharge error (vector of size n x 1);

%% DEFINE SINGULAR ERRORS (uncertainties)
err_Cc = 0.02773;   %[-] slope corrected discharge coefficient
err_D84= 0.000791^2;  %[m] grain sieving curves
err_hl = 0.0035^2;    %[m] flow depth at lateral contractions
err_hv = 0.002^2;     %[m] flow depth at vertical contractions
err_hn = 0.0008^2;	%[m] flow depth without contraction
err_m  = 0.1486^2;    %[-] bank slope
err_Q  = 0.02;      %[-] relative value --> use as multiple of Q!
err_Qb = 0.002;     %[-] relative value --> use as multiple of Qb!
err_w  = 0.0188^2;    %[m] channel bottom width

%% OTHER VARIABLES
g = 9.81;
D84 = 0.01368;
rhof=1000;
s = 2.68;
%% COMPUTE
err = nan(size(h));
for i = 1:numel(h)
    wm = w+h(i)*m;
    err(i) = Qb(i)/(wm*rhof*sqrt((s-1)*g*D84^3))*(err_Qb+...
                (err_w+h(i)*err_m+m*err_hn)/wm+...
                1.5*err_D84/D84);
end
end




