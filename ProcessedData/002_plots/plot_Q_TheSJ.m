% January 2017, Sebastian Schwindt
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
rho = 1000;
s = 2.68;
% channel characteristics
I = [0.020433, 0.034772, 0.055021];
w = [0.111, 0.5*(0.085066638+0.099039895), 0.5*(0.0823+0.106563)];
m = [1/tand(24.626), 1/tand(23.82), 1/tand(24.46)];

%% HYD ONLY - LIMITED IMPOUNDING (SPILLWAYS)
cd ..\..
cd('UnsteadyFlowAnalyses')
hFile = '20161123_unsteady_spillway.xlsx';
FrDx = xlsread(hFile,1, 'Q10:Q34');
Qb = xlsread(hFile,1, 'E10:E34');
ax = xlsread(hFile,1, 'M10:M34');
h0 = xlsread(hFile,1, 'I10:I34');
Q = xlsread(hFile,1, 'D10:D34');
Phi = xlsread(hFile,1, 'D10:D34');
cd ..
cd('Plots\Unsteady')
% QbMax = fGetQbMax(Q_dsp55,I(3));
% hMax = fGeth(Q_dsp55,I(3));
% qbMax = QbMax./(w(3)+hMax*m(3));
% qb_dsp55 = Qb_dsp55./(w(3)+h0_dsp55.*m(3));
% the_dsp55 = qb_dsp55./qbMax; 
nax_dsp = unique(ax);
ax_dsp55 = nan(25,numel(nax_dsp));
Fx_dsp55 = nan(25,numel(nax_dsp));
h0_dsp55 = nan(25,numel(nax_dsp));
Phi_dsp55 = nan(25,numel(nax_dsp));
Qb_dsp55 = nan(25,numel(nax_dsp));
Q_dsp55 = nan(25,numel(nax_dsp));
the_dsp55 = nan(25,numel(nax_dsp));
clear fGetQbmax
for fa = 1:numel(nax_dsp)
    posf = find(ax==nax_dsp(fa));
    for pp = 1:numel(posf)
        ax_dsp55(pp,fa) = ax(posf(pp));
        Fx_dsp55(pp,fa) = FrDx(posf(pp));
        h0_dsp55(pp,fa) = h0(posf(pp));
        Phi_dsp55(pp,fa) = Phi(posf(pp));
        Qb_dsp55(pp,fa) = Qb(posf(pp));
        Q_dsp55(pp,fa) = Q(posf(pp));
    end
    hMax = fGeth(Q_dsp55(:,fa),I(3));
    PhiMax = fSmartJaeggiQ(Dm,D30,D90,...
                          hMax,I(3),m(3),w(3),Q_dsp55(:,fa));
    QbMax = PhiMax.*(w(3)+hMax.*m(3)).*sqrt(g*(s-1)*Dm^3)*rho;
    % qb_dsp55 = Qb_dsp55(:,fa)./(w(3)+h0_dsp55(:,fa).*m(3));
    the_dsp55(:,fa) = Qb_dsp55(:,fa)./QbMax;
end

clear QbMax qbMax h0_dsp55 hMax PhiMax Phi



%% DATA MEC. f=1.75
cd ..\..\..
cd('6perCent_Reservoir\Blockage')
% selection of data f = 1.75
fFile = '20161211_summary_blockage_f_max.xlsx';
data1 =  xlsread(fFile,1, 'D25:J48');
f1 = data1(:,4);
FrDx1 = data1(:,7);
Qb1 = data1(:,2);
Q1 = data1(:,1);
h01 = data1(:,3);
Phi1 = data1(:,5);

data2 =  xlsread(fFile,1, 'D66:J91');
f2 = data2(:,4);
FrDx2 = data2(:,7);
Qb2 = data2(:,2);
Q2 = data2(:,1);
h02 = data2(:,3);
Phi2 = data2(:,5);
cd ..\..
cd('2-4-6-summary\Plots\Unsteady')

f_mec = [f1;f2];
Fx_mec = [FrDx1; FrDx2];
Qb_mec = [Qb1; Qb2].*0.5./0.6;% time corrector of raw data
% h0_mec = [h01; h02];
Phi_mec = [Phi1; Phi2];
Q_mec = [Q1; Q2];

hMax = fGeth(Q_mec,I(3));
PhiMax = fSmartJaeggiQ(Dm,D30,D90,...
                          hMax,I(3),m(3),w(3),Q_mec);
QbMax = PhiMax.*(w(3)+hMax.*m(3)).*sqrt(g*(s-1)*Dm^3)*rho;
% qb_mec = Qb_mec./(w(3)+h0_mec.*m(3));
the_mec = Qb_mec./QbMax;
clear FrDx1 FrDx2 f1 f2 Qb1 Qb2 Q1 Q2 QbMax h01 h02 h0_mec qbMax hMax Phi1 Phi2 PhiMax


%% DATA HyMec
cd ..\..\..
cd('6perCent_Reservoir\Blockage')
hmFile = '20161208_summary_blockage_comb_max.xlsx';
dataHyM = xlsread(hmFile,1, 'D4:K114');
ax = dataHyM(:,4);
FrDx = dataHyM(:,8);
h0 = dataHyM(:,3);
Phi = dataHyM(:,6);
Qb = dataHyM(:,2);
Q = dataHyM(:,1);
cd ..\..
cd('2-4-6-summary\Plots\Unsteady')
%% Separate Data (for ax)

nax_HyM = unique(ax);
nax_HyM = nax_HyM(1:3);
ax_HyMec = nan(56,numel(nax_HyM));
Fx_HyMec = nan(56,numel(nax_HyM));
h0_HyMec = nan(56,numel(nax_HyM));
Phi_HyMec = nan(56,numel(nax_HyM));
Qb_HyMec = nan(56,numel(nax_HyM));
Q_HyMec = nan(56,numel(nax_HyM));
the_HyMec = nan(56,numel(nax_HyM));

for fa = 1:numel(nax_HyM)
    posf = find(ax==nax_HyM(fa));
    for pp = 1:numel(posf)
        if not(isnan(ax(posf(pp),1))) % exclude purely mechanical
            ax_HyMec(pp,fa) = ax(posf(pp));
            Fx_HyMec(pp,fa) = FrDx(posf(pp));
            Phi_HyMec(pp,fa) = Q(posf(pp));
            Qb_HyMec(pp,fa) = Qb(posf(pp)).*0.5./0.6;% time corrector of raw data
            Q_HyMec(pp,fa) = Q(posf(pp));
            h0_HyMec(pp,fa) = h0(posf(pp));
        end
    end
    
    hMax = fGeth(Q_HyMec(:,fa),I(3));
    PhiMax = fSmartJaeggiQ(Dm,D30,D90,...
                         hMax,I(3),m(3),w(3),Q_HyMec(:,fa));
    QbMax = PhiMax.*(w(3)+hMax.*m(3)).*sqrt(g*(s-1)*Dm^3)*rho;
    % qb_HyMec = Qb_HyMec(:,fa)./(w(3)+h0_HyMec(:,fa).*m(3));
    the_HyMec(:,fa) = Qb_HyMec(:,fa)./QbMax;
end
clear ax FrDx Q Qb QbMax h0 h0_HyMec qbMax hMax qb_HyMec


%% SEND TO PLOTTING
fPlot_Q_TheSJ(Q_dsp55, Q_mec, Q_HyMec, ...
                the_dsp55, the_mec, the_HyMec,...
                 nax_dsp, nax_HyM, 1);


