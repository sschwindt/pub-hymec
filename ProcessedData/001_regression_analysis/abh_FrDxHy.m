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
I0 = [0.020433, 0.034772, 0.055021];
w0 = [0.111, 0.5*(0.085066638+0.099039895), 0.5*(0.0823+0.106563)];
m0 = [1/tand(24.626), 1/tand(23.82), 1/tand(24.46)];
%% DATA - DEPOSIT - UNLIMITED IMPOUNDING
cd ..\..
cd('Plots\Unsteady')
load('UnsteadyData.mat'); % povided by 2-4-6-summary/UnsteadyF.../main.m
% INFO: UnsteadyData.mat = 'Q','a','b','Phi','Psi','Fr0','the','t',
%                      'the_max','Fr0_max','Fr0_fs','hnc','h0','hcr','I0_u'


Fr_udp55 = struc(Fr0(:,10:12));
Fr_udf55 = struc(Fr0_fs(:,10:12));

a10 = a(10).*ones(numel(Fr0(:,10)),1);
a11 = a(11).*ones(numel(Fr0(:,11)),1);
a12 = a(12).*ones(numel(Fr0(:,12)),1);
ah_ud55 = [a10;a11;a12]./struc(h0(:,10:12));
b10 = b(10).*ones(numel(Fr0_fs(:,10)),1);
b11 = b(11).*ones(numel(Fr0_fs(:,11)),1);
b12 = b(12).*ones(numel(Fr0_fs(:,12)),1);
bh_ud55 = [b10;b11;b12]./struc(h0(:,10:12));

Phi_ud55 = struc(Phi(:,10:12));
for i = 1:numel(Fr_udf55)
    if and(or(Fr_udf55(i)>1.15,Fr_udp55(i)>1.15), Phi_ud55(i)<10^-2)
        Fr_udf55(i) = nan;
        Fr_udp55(i) = nan;
    end
    if and(bh_ud55(i)<1.4, Fr_udf55(i)>0.51)
        Fr_udf55(i) = nan;
    end
    if Fr_udf55(i) >2
        Fr_udf55(i) = nan;
    end
end
clear a b Phi h0 hnc I0_u t the the_max Fr0_max Psi Q

%% DATA - NO DEPOSIT - UNLIMITED IMPOUNDING
load('SteadyData.mat'); % povided by 2-4-6-summary/Data/trans...data_FrDx.m
% INFO: SteadyData.mat = 'a_steady','b_steady','Fr_steady','theta_steady','hcr_steady', 
%                           'h0_steady','Q_steady'

% sort pressure / free surface flow conditions (prepare X VALUES)
Fr_ndp55 = [Fr_steady(1:120,3);Fr_steady(241:360,3)];
Fr_ndf55 = Fr_steady(121:240,3);
ah_nd55 = [a_steady(1:120,3)./h0_steady(1:120,3);a_steady(241:360,3)./h0_steady(241:360,3)];
bh_nd55 = b_steady(121:240,3)./h0_steady(121:240,3);
for i = 1:numel(Fr_ndf55)
    if Fr_ndf55(i) > 2
        Fr_ndf55(i) = nan;
    end
end
for i = 1:numel(Fr_ndp55)
    if Fr_ndp55(i) > 2
        Fr_ndp55(i) = nan;
    end
end
clear Qb_nc Qb_c wm Phi_S Fr_steady
cd ..\..
%% DATA UNSTEADY - LIMITED IMPOUNDING (SPILLWAYS)
cd('UnsteadyFlowAnalyses')

FrDx = xlsread('20161123_unsteady_spillway.xlsx',1, 'Q10:Q34');
ax = xlsread('20161123_unsteady_spillway.xlsx',1, 'M10:M34');
h0 = xlsread('20161123_unsteady_spillway.xlsx',1, 'I10:I34');
Q = xlsread('20161123_unsteady_spillway.xlsx',1, 'D10:D34');

cd ..
cd('DataRegression\UnsteadyDeposit')

nax_dsp = unique(ax);
ax_dsp55 = nan(25,numel(nax_dsp));
Fx_dsp55 = nan(25,numel(nax_dsp));
ah_dsp55 = nan(25,numel(nax_dsp));
err_Fx = nan(25,numel(nax_dsp));
err_ahx = nan(25,numel(nax_dsp));

for fa = 1:numel(nax_dsp)
    posf = find(ax==nax_dsp(fa));
    for pp = 1:numel(posf)
        ax_dsp55(pp,fa) = ax(posf(pp));
        Fx_dsp55(pp,fa) = FrDx(posf(pp));
        ah_dsp55(pp,fa) = ax(posf(pp))./h0(posf(pp)).*D84;
        err_Fx(pp,fa) = fGetErrFr(h0(posf(pp)),Q(posf(pp)),w0(3),m0(3));
        err_ahx(pp,fa) = fGetErrahx(ax(posf(pp))*D84, h0(posf(pp)));
    end
end
clear  Q_dsp55 h0_dsp55

%% CURVE FITTING
% ah_nd55, ah_ud55, ah_dsp55, nax_dsp,...
% bh_nd55, bh_ud55,...
% Fr_ndp55, Fr_ndf55, Fr_udp55, Fr_udf55, Fx_dsp55
X =ah_ud55;
Y = Fr_udp55;
cftool(X,Y)
