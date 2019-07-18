function[Phi] = fRecking(D84,D50,Dm,h,I,m,w0)
% October 2016
% function computes solid discharges using Recking (2013) formula
% Computes bed load for trapezoidal bed shapes

% INPUT:    D [m] SCALAR Representative grain size
%           h [m] VECTOR flow depth
%           I [-] SCALAR channel slope
%           m [-] SCALAR bank slope (1/tand(alpha))
%           w0[m] SCALAR channel base width
%
% OUTPUT: Phi [-] Dimensionless bedload (as defined by Einstein, 1950)
%
%% CONSTANTS
rhos = 2680;            %[kg/m³] densite sediment
rhof = 1000;            %[kg/m³] densite fluide
s = rhos/rhof;          %[-] densite relative

%% COMPUTE PHI (Qbx)
if Dm > 2*10^-3
    tauXm = 12.53.*(1.32*I+0.037).^1.6*(D84/D50).^(4.4*sqrt(I)-0.93*1.6);
    tauXm = 0.047;
else
    tauXm = 0.045;
end

% computation of tauX84 is flow depth-related here! (ignore roughness
% approach explained by Recking (2013))

% Solid discharge over main channel
Rh_main = h.*w0./(2.*h+w0);
taux84_m = Rh_main.*I./((s-1)*D84);
Phi_main = 14*taux84_m.^2.5./(1+(tauXm./taux84_m).^4);

% Solid discharge over banks
Rh_bank = h.*m./(2.*(1+sind(atand(1/m))));
taux84_b = Rh_bank.*I./((s-1)*D84);
Phi_bank = 14*taux84_b.^2.5./(1+(tauXm./taux84_b).^4);


Phi = Phi_main+2*Phi_bank;
for i = 1:numel(Phi) % eliminate non-sense values
    if Phi(i) < 0
        Phi(i) = nan;
    end
end

















