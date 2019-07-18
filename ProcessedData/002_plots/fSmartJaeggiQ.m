function[Phi] = fSmartJaeggiQ(D,D30,D90,h,I,m,w0,Q)
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
%        --> for dimensions: Qb = Phi*A*sqrt(g*(s-1)*D)
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
%Q = fGetQ(h,I);
A_tot = h.*(w0+h.*m);
u = Q./A_tot;

% Solid discharge over main channel
% Rh_main = h.*w0./(2.*h+w0);
C_main = u./(g.*h.*I).^0.5;
the_main = h.*I./((s-1).*D);
Phi_main = 4*(D90/D30)^0.2*I.^0.6.*C_main.*the_main.^0.5.*(the_main-TauCrit);
%*u./sqrt(g*(s-1)*D).*(Rh_main.*I./((s-1)*D)*0.85-TauCrit);

% Solid discharge over banks
% Rh_bank = h.*m./(1+sind(atand(1/m)));
C_bank = u./(g.*0.5*h.*I).^0.5;
the_bank = 0.5*h.*I./((s-1).*D);
Phi_bank = 4*(D90/D30)^0.2*I.^0.6.*C_bank.*the_bank.^0.5.*(the_bank-TauCrit);
% Phi_bank = 4.*(D90/D30)^0.2*I.^0.6.*u./sqrt(g*(s-1)*D).*(Rh_bank.*I./((s-1)*D)*0.85-TauCrit);

Phi = nan(size(Phi_main));
for ij = 1:numel(Phi_main) % eliminate non-sense values
    if Phi_bank(ij) > 0
        Phi(ij) = Phi_main(ij)+2*Phi_bank(ij);
    else
        Phi(ij) = Phi_main(ij);
    end
    if Phi(ij) < 0
        Phi(ij) = nan;
    end
end

    