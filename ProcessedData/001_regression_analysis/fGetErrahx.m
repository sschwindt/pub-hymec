function [ err ] = fGetErrahx(a,h)
% Error propagation analysis

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
err_a  = 0.001;     %[m] contraction height (calliper)

%% OTHER VARIABLES
g = 9.81;
D84 = 0.01368;

%% COMPUTE
err = nan(size(h));
for i = 1:numel(h)
    err(i) = 1/h(i)*err_a-a(i)/h(i)^2*err_hv;
end
end




