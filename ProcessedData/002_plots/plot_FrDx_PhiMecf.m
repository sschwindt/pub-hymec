% December 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% INFO: data are provided by Blockage with reservoir

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
Phi1 = xlsread('20161211_summary_blockage_f.xlsx',1, 'H4:H63');
Data1 = [f1, FrDx1, Phi1];

FrDx2 = xlsread('20161211_summary_blockage_f.xlsx',1, 'J66:J91');
Phi2 = xlsread('20161211_summary_blockage_f.xlsx',1, 'H66:H91');
f2 = f1(30)*ones(size(Phi2)); % subscribe f-value for these measurements
Data2 = [f2, FrDx2, Phi2];

Data = [Data1; Data2];
cd ..\..
cd('2-4-6-summary\Plots\Unsteady')
%% Separate Data (for f)

nf = unique(Data(:,1));
fData = nan(50,numel(nf));
FxData = nan(50,numel(nf));
PhiData = nan(50,numel(nf));
for ff = 1:numel(nf)
    posf = find(Data(:,1)==nf(ff));
    for pp = 1:numel(posf)
        fData(pp,ff) = Data(posf(pp),1);
        FxData(pp,ff) = Data(posf(pp),2);
        PhiData(pp,ff) = Data(posf(pp),3);
    end
end




%% SEND TO PLOTTING
fPlot_FrDx_PhiMecf(FxData, PhiData, nf, 1); % nf serves for data labels


