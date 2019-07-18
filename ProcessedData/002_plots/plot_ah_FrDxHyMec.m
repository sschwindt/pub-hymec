% October 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% syntax:
% C = contracted
% d = deposit
% f = free surface
% n = no
% p = pressurized
% s = spillways

% INFO: Steady data are provided by "transfer2data_Fr0.m"
disp('Running ...')
% Script creates plot according to X-/Y-/Regression-Data Definitions
%% PREAMBLE
clear all;
close all;

% sediment characteristics and constants
D90 = 0.01478;
D84 = 0.01368;
Dm  = 0.00938; 
D50 = 0.00965;
D30 = 0.00423;
D16 = 0.00727;
g = 9.81;
s = 2.68;
% channel characteristics
I0 = [0.020433, 0.034772, 0.055021];
w0 = [0.111, 0.5*(0.085066638+0.099039895), 0.5*(0.0823+0.106563)];
m0 = [1/tand(24.626), 1/tand(23.82), 1/tand(24.46)];

%% DATA HyMec
cd ..\..\..
cd('6perCent_Reservoir\Blockage')
ax = xlsread('20161208_summary_blockage_comb.xlsx',1, 'G4:G114');
FrDx = xlsread('20161208_summary_blockage_comb.xlsx',1, 'K4:K114');
h0 = xlsread('20161208_summary_blockage_comb.xlsx',1, 'F4:F114');
Q = xlsread('20161208_summary_blockage_comb.xlsx',1, 'D4:D114');

cd ..\..
cd('2-4-6-summary\Plots\Unsteady')
%% Separate Data (for ax)

nax_HyM = unique(ax);
nax_HyM = nax_HyM(1:3);
ax_HyMec = nan(56,numel(nax_HyM));
Fx_HyMec = nan(56,numel(nax_HyM));
ah_HyMec = nan(56,numel(nax_HyM));
err_Fx = nan(56,numel(nax_HyM));
err_ahx = nan(56,numel(nax_HyM));


for fa = 1:numel(nax_HyM)
    posf = find(ax==nax_HyM(fa));
    for pp = 1:numel(posf)
        if not(isnan(ax(posf(pp),1))) % exclude purely mechanical
            ax_HyMec(pp,fa) = ax(posf(pp));
            Fx_HyMec(pp,fa) = FrDx(posf(pp));
            ah_HyMec(pp,fa) = ax(posf(pp))./h0(posf(pp))*D84;
            err_Fx(pp,fa) = fGetErrFrC(h0(posf(pp)),Q(posf(pp)),w0(3),m0(3));
            err_ahx(pp,fa) = fGetErrahx(ax(posf(pp))*D84, h0(posf(pp)));
        end
    end
end
clear ax FrDx h0

%% SEND TO PLOTTING
fPlot_ah_FrDxHyMec(ah_HyMec, Fx_HyMec, nax_HyM, err_Fx, err_ahx, 1);

