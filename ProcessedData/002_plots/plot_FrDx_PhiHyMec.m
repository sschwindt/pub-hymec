% December 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% INFO: data are provided by Blockage with reservoir

% Script creates plot according to X-/Y-/Regression-Data Definitions
%% PREAMBLE
clear all;
close all;
sourceN = '20161208_summary_blockage_comb.xlsx';

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
ax = xlsread(sourceN,1, 'G4:G114');
FrDx = xlsread(sourceN,1, 'K4:K114');
Phi = xlsread(sourceN,1, 'I4:I114');
Data = [ax, FrDx, Phi];

cd ..\..
cd('2-4-6-summary\Plots\Unsteady')
%% Separate Data (for ax)

nax = unique(Data(:,1));
nax = nax(1:3);
axData = nan(56,numel(nax));
FxData = nan(56,numel(nax));
PhiData = nan(56,numel(nax));
for fa = 1:numel(nax)
    posf = find(Data(:,1)==nax(fa));
    for pp = 1:numel(posf)
        if not(isnan(Data(posf(pp),1))) % exclude purely mechanical
            axData(pp,fa) = Data(posf(pp),1);
            FxData(pp,fa) = Data(posf(pp),2);
            PhiData(pp,fa) = Data(posf(pp),3);
        end
    end
end


%% SEND TO PLOTTING
fPlot_FrDx_PhiHyMec(FxData, PhiData, nax, 1); % nf serves for data labels


