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
load('UnsteadyDataSave.mat'); % povided by 2-4-6-summary/UnsteadyF.../main.m
% INFO: UnsteadyData.mat = 'Q','a','b','Phi','Psi','Fr0','the','t',
%                      'the_max','Fr0_max','Fr0_fs','hnc','h0','hcr','I0_u'
h0 = struc(h0(:,10:12));
Q = struc(Q(:,10:12));

Fr_udp = struc(Fr0(:,10:12));
Fr_udf = struc(Fr0_fs(:,10:12));

a10 = a(10).*ones(numel(Fr0(:,10)),1);
a11 = a(11).*ones(numel(Fr0(:,11)),1);
a12 = a(12).*ones(numel(Fr0(:,12)),1);
ah_ud = [a10;a11;a12]./h0;
b10 = b(10).*ones(numel(Fr0_fs(:,10)),1);
b11 = b(11).*ones(numel(Fr0_fs(:,11)),1);
b12 = b(12).*ones(numel(Fr0_fs(:,12)),1);
bh_ud = [b10;b11;b12]./h0;

Phi_ud = struc(Phi(:,10:12));
for i = 1:numel(Fr_udf)
    if and(or(Fr_udf(i)>1.15,Fr_udp(i)>1.15), Phi_ud(i)<10^-2)
        Fr_udf(i) = nan;
        Fr_udp(i) = nan;
    end
    if and(bh_ud(i)<1.4, Fr_udf(i)>0.51)
        Fr_udf(i) = nan;
    end
end
for i = 1:numel(Fr_udp)
    if Fr_udp(i)>2
        Fr_udp(i) =nan;
    end
end
err_Fx_udp = fGetErrFrC(h0,Q,w0(3),m0(3));
err_ahx_ud = fGetErrahx([a10;a11;a12], h0);
clear a b Phi h0 hnc I0_u t the the_max Fr0_max Psi Q

%% DATA - NO DEPOSIT - UNLIMITED IMPOUNDING
load('SteadyDataSave.mat'); % povided by 2-4-6-summary/Data/trans...data_FrDx.m
% INFO: SteadyData.mat = 'a_steady','b_steady','Fr_steady','theta_steady','hcr_steady', 
%                           'h0_steady','Q_steady'

% sort pressure / free surface flow conditions (prepare X VALUES)
Fr_ndp = [Fr_steady(1:120,3);Fr_steady(241:360,3)];
Q_ndp = [Q_steady(1:120,3);Q_steady(241:360,3)];
h_ndp = [h0_steady(1:120,3);h0_steady(241:360,3)];
Fr_ndf = Fr_steady(121:240,3);
ah_nd = [a_steady(1:120,3)./h0_steady(1:120,3);a_steady(241:360,3)./h0_steady(241:360,3)];
bh_nd = b_steady(121:240,3)./h0_steady(121:240,3);
err_Fx_ndp = fGetErrFrC(h_ndp,Q_ndp,w0(3),m0(3));
err_ahx_nd = fGetErrahx(ah_nd.*h_ndp, h_ndp);
clear Qb_nc Qb_c wm Phi_S Fr_steady

%% DATA UNSTEADY - LIMITED IMPOUNDING (SPILLWAYS)
cd ..\..
cd('UnsteadyFlowAnalyses')

FrDx = xlsread('20161123_unsteady_spillway.xlsx',1, 'Q10:Q34');
ax = xlsread('20161123_unsteady_spillway.xlsx',1, 'M10:M34');
h0 = xlsread('20161123_unsteady_spillway.xlsx',1, 'I10:I34');
Q = xlsread('20161123_unsteady_spillway.xlsx',1, 'D10:D34');

cd ..
cd('Plots\Unsteady')

nax_dsp = unique(ax);
ax_dsp = nan(25,numel(nax_dsp));
Fx_dsp = nan(25,numel(nax_dsp));
ah_dsp = nan(25,numel(nax_dsp));
err_Fx_dsp = nan(25,numel(nax_dsp));
err_ahx_dsp = nan(25,numel(nax_dsp));

for fa = 1:numel(nax_dsp)
    posf = find(ax==nax_dsp(fa));
    for pp = 1:numel(posf)
        ax_dsp(pp,fa) = ax(posf(pp));
        Fx_dsp(pp,fa) = FrDx(posf(pp));
        ah_dsp(pp,fa) = ax(posf(pp))./h0(posf(pp)).*D84;
        err_Fx_dsp(pp,fa) = fGetErrFrC(h0(posf(pp)),Q(posf(pp)),w0(3),m0(3));
        err_ahx_dsp(pp,fa) = fGetErrahx(ax(posf(pp))*D84, h0(posf(pp)));
    end
end
clear  Q h0

%% SEND TO PLOTTING
fPlot_abh_FrDxHy(ah_nd, ah_ud, ah_dsp, nax_dsp,...
    bh_nd, bh_ud,...
    err_ahx_dsp, err_ahx_nd, err_ahx_ud, ...
    err_Fx_ndp, err_Fx_udp, err_Fx_dsp,...
    Fr_ndp, Fr_ndf, Fr_udp, Fr_udf, Fx_dsp, 1);

