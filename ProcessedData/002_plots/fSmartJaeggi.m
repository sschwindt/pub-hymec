function[Phi] = fSmartJaeggi(D,D30,D90,h,I,m,w0)
% October 2016
% function computes solid discharges using SMART/JAEGGI formula
% Computes bed load for trapezoidal bed shapes
% VALIDITY DOMAIN (checked by function)
% ++ Dm > 0.4 [mm] 
% ++ D90/D30 > 8.5 
% ++ 0.2 < J < 20 [%] 
% 
% INPUT:    D [m] SCALAR Representative grain size
%           h [m] VECTOR flow depth
%           I [-] SCALAR channel slope
%           m [-] SCALAR bank slope (1/tand(alpha))
%           w0[m] SCALAR channel base width
%
% OUTPUT: Phi [-] Dimensionless bedload (as defined by Einstein, 1950)
%
% Script requires function fGetQ.m
%
%% CONSTANTS
g = 9.81;               %[m/s²]
rhos = 2680;            %[kg/m³] densite sediment
rhof = 1000;            %[kg/m³] densite fluide
s = rhos/rhof;          %[-] densite relative


%% CONTROL VALIDITY
if or(I < 0.002,I > 0.2)
    disp('Warning: Channel slope out of validity range.')
end
if D < 0.4*10^-3
    disp('Warning: Grain size too small.')
end
if D90/D30 > 8.5
    disp('Warning: Grain size distribution too wide.')
end

%% COMPUTE PHI (Qbx)

TauCrit = 0.047;     %[-] dimless critical shear stress
Q = fGetQ(h,I);
A_tot = h.*(w0+h.*m);
u = Q./A_tot;
% Solid discharge over main channel
Rh_main = h.*w0./(2.*h+w0);
Phi_main = 4*(D90/D30)^0.2*I^0.6.*u./sqrt(g*(s-1)*D).*(Rh_main.*I./((s-1)*D)-TauCrit);

% Solid discharge over banks
Rh_bank = h.*m./(1+sind(atand(1/m)));
Phi_bank = 4*(D90/D30)^0.2*I^0.6.*u./sqrt(g*(s-1)*D).*(Rh_bank.*I./((s-1)*D)-TauCrit);

Phi = Phi_main+2*Phi_bank;
for i = 1:numel(Phi) % eliminate non-sense values
    if Phi(i) < 0
        Phi(i) = nan;
    end
end

    