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


%% DATA f EXPERIMENTS
cd ..\..\..
cd('6perCent_Reservoir\Blockage')
f1 = xlsread('20161211_summary_blockage_f.xlsx',1, 'G4:G63');
FrDx1 = xlsread('20161211_summary_blockage_f.xlsx',1, 'J4:J63');
h01 = xlsread('20161211_summary_blockage_f.xlsx',1, 'F4:F63');
Q01 = xlsread('20161211_summary_blockage_f.xlsx',1, 'D4:D63');
Data1 = [f1, FrDx1, h01, Q01];

FrDx2 = xlsread('20161211_summary_blockage_f.xlsx',1, 'J66:J91');
h02 = xlsread('20161211_summary_blockage_f.xlsx',1, 'F66:F91');
Q02 = xlsread('20161211_summary_blockage_f.xlsx',1, 'D66:D91');
f2 = f1(30)*ones(size(FrDx2)); % subscribe f-value for these measurements
Data2 = [f2, FrDx2, h02, Q02];

Data = [Data1; Data2];
cd ..\..
cd('2-4-6-summary\Plots\Unsteady')
%% Separate Data (for f)

nf = unique(Data(:,1));
fData = nan(50,numel(nf));
FxData = nan(50,numel(nf));
hData = nan(50,numel(nf));
QData = nan(50,numel(nf));
err_Fx = nan(size(FxData));
err_fhx = nan(size(fData));
for ff = 1:numel(nf)
    posf = find(Data(:,1)==nf(ff));
    for pp = 1:numel(posf)
        fData(pp,ff) = Data(posf(pp),1);
        FxData(pp,ff) = Data(posf(pp),2);
        hData(pp,ff) = Data(posf(pp),3);
        QData(pp,ff) = Data(posf(pp),4);
        err_Fx(pp,ff) = fGetErrFrC(hData(pp,ff), QData(pp,ff), w0(3), m0(3));
        err_fhx(pp,ff)= fGetErrfhx(fData(pp,ff), QData(pp,ff));
    end
end
fhxData = fData./hData.*D84;
clear FrDx1 FrDx2 f1 f2 h01 h02


%% SEND TO PLOTTING
fPlot_fh_FrDxMec(fhxData, FxData, err_Fx, err_fhx, nf, 1);

