function [ err ] = fGetErrfhx(f,h)
% Error propagation analysis

% INPUT: 
% VECTORS!

% OUTPUT:
% err [m³/s] discharge error (vector of size n x 1);

%% DEFINE SINGULAR ERRORS (uncertainties)
err_Cc = 0.02773;   %[-] slope corrected discharge coefficient
err_D84= 0.000791;  %[m] grain sieving curves
err_hl = 0.0035^2;    %[m] flow depth at lateral contractions
err_hf = 0.004;     %[m] flow depth at vertical contractions
err_hn = 0.0008^2;	%[m] flow depth without contraction
err_m  = 0.1486^2;    %[-] bank slope
err_Q  = 0.02;      %[-] percentage value --> use as multiple of Q!
err_w  = 0.0188^2;    %[m] channel bottom width
err_a  = 0.001;     %[m] contraction height (calliper)
err_f  = 0.001;     %[m] mechanical barrier clearance height (calliper)

%% OTHER VARIABLES
g = 9.81;
D84 = 0.01368;

%% COMPUTE
err = nan(size(h));
for i = 1:numel(h)
    %old ! err(i) = D84/h(i)*err_f-f(i)/h(i)^2*err_hf^2*D84+f(i)/h(i)*err_D84^2;
    err(i) = -f(i)/h(i)^2*err_hf^2*D84;
end
end




