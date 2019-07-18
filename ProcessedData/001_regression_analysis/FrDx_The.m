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
s = 2.68;
% channel characteristics
I = [0.020433, 0.034772, 0.055021];
w = [0.111, 0.5*(0.085066638+0.099039895), 0.5*(0.0823+0.106563)];
m = [1/tand(24.626), 1/tand(23.82), 1/tand(24.46)];


%% DATA UNSTEADY - LIMITED IMPOUNDING (SPILLWAYS)
cd ..\..
cd('UnsteadyFlowAnalyses')

FrDx = xlsread('20161123_unsteady_spillway.xlsx',1, 'Q10:Q34');
Qb = xlsread('20161123_unsteady_spillway.xlsx',1, 'E10:E34');
ax = xlsread('20161123_unsteady_spillway.xlsx',1, 'M10:M34');
h0 = xlsread('20161123_unsteady_spillway.xlsx',1, 'I10:I34');
Q = xlsread('20161123_unsteady_spillway.xlsx',1, 'D10:D34');
cd ..
cd('DataRegression\UnsteadyDeposit')
% QbMax = fGetQbMax(Q_dsp55,I(3));
% hMax = fGeth(Q_dsp55,I(3));
% qbMax = QbMax./(w(3)+hMax*m(3));
% qb_dsp55 = Qb_dsp55./(w(3)+h0_dsp55.*m(3));
% the_dsp55 = qb_dsp55./qbMax; 
nax_dsp = unique(ax);
ax_dsp55 = nan(25,numel(nax_dsp));
Fx_dsp55 = nan(25,numel(nax_dsp));
h0_dsp55 = nan(25,numel(nax_dsp));
Qb_dsp55 = nan(25,numel(nax_dsp));
Q_dsp55 = nan(25,numel(nax_dsp));
the_dsp55 = nan(25,numel(nax_dsp));
clear fGetQbmax
for fa = 1:numel(nax_dsp)
    posf = find(ax==nax_dsp(fa));
    for pp = 1:numel(posf)
        ax_dsp55(pp,fa) = ax(posf(pp));
        Fx_dsp55(pp,fa) = FrDx(posf(pp));
        Qb_dsp55(pp,fa) = Qb(posf(pp));
        Q_dsp55(pp,fa) = Q(posf(pp));
        h0_dsp55(pp,fa) = h0(posf(pp));
    end
    QbMax = fGetQbmax(Q_dsp55(:,fa),I(3));
    hMax = fGeth(Q_dsp55(:,fa),I(3));
    qbMax = QbMax./(w(3)+hMax*m(3));
    qb_dsp55 = Qb_dsp55(:,fa)./(w(3)+h0_dsp55(:,fa).*m(3));
    the_dsp55(:,fa) = qb_dsp55./qbMax;
end

clear QbMax qbMax Q_dsp55 h0_dsp55 hMax



%% DATA MEC. f=1.75
cd ..\..\..
cd('6perCent_Reservoir\Blockage')
% selection of data f = 1.75
f1 = xlsread('20161211_summary_blockage_f.xlsx',1, 'G25:G48');
FrDx1 = xlsread('20161211_summary_blockage_f.xlsx',1, 'J25:J48');
Qb1 = xlsread('20161211_summary_blockage_f.xlsx',1, 'E25:E48');
Q1 = xlsread('20161211_summary_blockage_f.xlsx',1, 'D25:D48');
h01 = xlsread('20161211_summary_blockage_f.xlsx',1, 'F25:F48');

f2 = xlsread('20161211_summary_blockage_f.xlsx',1, 'G66:G91');
FrDx2 = xlsread('20161211_summary_blockage_f.xlsx',1,'J66:J91');
Qb2 = xlsread('20161211_summary_blockage_f.xlsx',1, 'E66:E91');
Q2 = xlsread('20161211_summary_blockage_f.xlsx',1, 'D66:D91');
h02 = xlsread('20161211_summary_blockage_f.xlsx',1, 'F66:F91');
cd ..\..
cd('2-4-6-summary\Plots\Unsteady')

f_mec = [f1;f2];
Fx_mec = [FrDx1; FrDx2];
Qb_mec = [Qb1; Qb2];
h0_mec = [h01; h02];
Q = [Q1; Q2];

QbMax = fGetQbmax(Q,I(3));
hMax = fGeth(Q,I(3));
qbMax = QbMax./(w(3)+hMax*m(3));
qb_mec = Qb_mec./(w(3)+h0_mec.*m(3));
the_mec = qb_mec./qbMax;
clear FrDx1 FrDx2 f1 f2 Qb1 Qb2 Q1 Q2 Q QbMax h01 h02 h0_mec qbMax hMax


%% DATA HyMec
cd ..\..\..
cd('6perCent_Reservoir\Blockage')
ax = xlsread('20161208_summary_blockage_comb.xlsx',1, 'G4:G114');
FrDx = xlsread('20161208_summary_blockage_comb.xlsx',1, 'K4:K114');
h0 = xlsread('20161208_summary_blockage_comb.xlsx',1, 'F4:F114');
Qb = xlsread('20161208_summary_blockage_comb.xlsx',1, 'E4:E114');
Q = xlsread('20161208_summary_blockage_comb.xlsx',1, 'D4:D114');
cd ..\..
cd('2-4-6-summary\Plots\Unsteady')
%% Separate Data (for ax)

nax_HyM = unique(ax);
nax_HyM = nax_HyM(1:3);
ax_HyMec = nan(56,numel(nax_HyM));
Fx_HyMec = nan(56,numel(nax_HyM));
h0_HyMec = nan(56,numel(nax_HyM));
Qb_HyMec = nan(56,numel(nax_HyM));
Q_HyMec = nan(56,numel(nax_HyM));
the_HyMec = nan(56,numel(nax_HyM));

for fa = 1:numel(nax_HyM)
    posf = find(ax==nax_HyM(fa));
    for pp = 1:numel(posf)
        if not(isnan(ax(posf(pp),1))) % exclude purely mechanical
            ax_HyMec(pp,fa) = ax(posf(pp));
            Fx_HyMec(pp,fa) = FrDx(posf(pp));
            Qb_HyMec(pp,fa) = Qb(posf(pp));
            Q_HyMec(pp,fa) = Q(posf(pp));
            h0_HyMec(pp,fa) = h0(posf(pp));
        end
    end
    QbMax = fGetQbmax(Q_HyMec(:,fa),I(3));
    hMax = fGeth(Q_HyMec(:,fa),I(3));
    qbMax = QbMax./(w(3)+hMax*m(3));
    qb_HyMec = Qb_HyMec(:,fa)./(w(3)+h0_HyMec(:,fa).*m(3));
    the_HyMec(:,fa) = qb_HyMec./qbMax;
end
clear ax FrDx Q Qb Q_HyMec QbMax h0 h0_HyMec qbMax hMax qb_HyMec

%% launch regression tool
X = [struc(Fx_dsp55); Fx_mec; struc(Fx_HyMec)];
Y = [struc(the_dsp55); the_mec; struc(the_HyMec)];
min(X)
max(X)
cftool(X,Y)
