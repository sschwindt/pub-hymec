function[Phi] = fRickenmannQ(D,D30,D90,h,I,m,w0,Q)
% October 2016
% function computes solid discharges using the dimensionless Rickenmann(91)
% formula for extended slope (not only steepmslope, ref. p1432+disc.)
% --> valid approach, as flow depth is used
%
% Computes bed load for trapezoidal bed shapes
% VALIDITY DOMAIN (checked by function)
% ++ Dm > 0.4 [mm] 
% ++ D90/D30 > 8.8 
% ++ 0.001 < J < 20 [%] 
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
if or(I < 0.001,I > 0.2)
    % ! changes for discharge based computation to 0.05<I<0.2!
    disp('Warning: Channel slope out of validity range.')
end
if D < 0.4*10^-3
    disp('Warning: Grain size too small.')
end
if D90/D30 > 8.8
    disp('Warning: Grain size distribution too wide.')
end


%% COMPUTE PHI (Qbx)

TauCrit = 0.047;     %[-] dimless critical shear stress
%Q = fGetQ(h,I);
A_tot = h.*(w0+h.*m);
Fr = (Q.^2.*(w0+2*h.*m)./(g.*A_tot.^3)).^0.5;

% Solid discharge over main channel
Rh_main = h.*w0./(2.*h+w0);
theta_m = Rh_main.*I./((s-1)*D);
Phi_main = 3.1./sqrt(s-1).*(D90/D30)^0.2.*theta_m.^0.5.*(theta_m-TauCrit).*Fr.^1.1;

% Solid discharge over banks
Rh_bank = h.*m./(2.*(1+sind(atand(1/m))));
theta_b = Rh_bank.*I./((s-1)*D);
Phi_bank = 3.1./sqrt(s-1).*(D90/D30)^0.2.*theta_b.^0.5.*(theta_b-TauCrit).*Fr.^1.1;


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
%% Uncomment for discharge-based approach (+ validity: 0.05<I<0.2!)
% qc = 0.065*(s-1)^1.6*sqrt(g)*D50^1.5*J^(-1.12);
% qs = 12.6/(s-1)^1.6*(D90/D30)^0.2*(q-qc)*J^2;
% Qs = qs*wM;



















