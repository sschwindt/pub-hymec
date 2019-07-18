function [ err ] = fGetErrFr(h,Q,w,m)
% Error propagation analysis for lateral flow contraction

% INPUT: 
% VECTORS!

% OUTPUT:
% err [m³/s] discharge error (vector of size n x 1);

%% DEFINE SINGULAR ERRORS (uncertainties)
err_Cc = 0.02773;   %[-] slope corrected discharge coefficient
err_D84= 0.000791^2;  %[m] grain sieving curves
err_hl = 0.0035^2;    %[m] flow depth at lateral contractions
err_hv = 0.002^2;     %[m] flow depth at vertical contractions
err_hn = 0.0008^2;	%[m] flow depth without contraction
err_m  = 0.1486^2;    %[-] bank slope
err_Q  = 0.02;      %[-] percentage value --> use as multiple of Q!
err_w  = 0.0188^2;    %[m] channel bottom width

%% OTHER VARIABLES
g = 9.81;
D84 = 0.01368;

%% COMPUTE
err = nan(size(Q));
for i = 1:numel(Q)
    wm = w+h(i)*m;
    err(i) = abs(Q(i)/(wm*h(i)*sqrt(g*D84))*(err_Q-(err_hn*(w+2*h(i)*m)+...
        err_w*h(i)+err_m*h(i)^2)/(wm*h(i))-0.5*err_D84/sqrt(D84)));
end
end




