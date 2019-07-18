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

Fr_udp35 = struc(Fr0(:,1:9));
Fr_udp55 = struc(Fr0(:,10:12));
Fr_udf35 = struc(Fr0_fs(:,1:9));
Fr_udf55 = struc(Fr0_fs(:,10:12));
Phi_ud35 = struc(Phi(:,1:9));
Phi_ud55 = struc(Phi(:,10:12));

for i = 1:numel(Fr_udf35)
    if and(or(Fr_udf35(i)>1.35,Fr_udp35(i)>1.35), Phi_ud35(i)<4.5*10^-3)
        Phi_ud35(i) = nan;
    end
end
for i = 1:numel(Fr_udf55)
    if and(or(Fr_udf55(i)>1.15,Fr_udp55(i)>1.15), Phi_ud55(i)<10^-2)
        Phi_ud55(i) = nan;
    end
end
clear a b Phi h0 hnc I0_u t the the_max Fr0_max Psi Q
%% DATA - NO DEPOSIT - UNLIMITED IMPOUNDING
load('SteadyDataSave.mat'); % povided by 2-4-6-summary/Data/trans...data_FrDx.m
% INFO: SteadyData.mat = 'Fr_steady','theta_steady','hcr_steady', 
%                           'h0_steady','Q_steady'

% sort pressure / free surface flow conditions (prepare X VALUES)
Fr_ndp35 = [Fr_steady(1:120,2);Fr_steady(241:360,2)];
Fr_ndp55 = [Fr_steady(1:120,3);Fr_steady(241:360,3)];

Fr_ndf35 = Fr_steady(121:240,2);
Fr_ndf55 = Fr_steady(121:240,3);

% get dimless bedload (prepare Y VALUES)
Phi_s = nan(size(Fr_steady));
for i = 1:numel(Fr_steady(:,1))
    for j = 1:3
        Qb_nc = fGetQbmax(Q_steady(i,j),I0(j));
        Qb_c = theta_steady(i,j)*Qb_nc;
        wm = w0(j)+h0_steady(i,j).*m0(j);
        Phi_s(i,j) = Qb_c/(1000*wm*((s-1)*g*D84^3)^0.5);
    end
end

Phi_ndp35 = [Phi_s(1:120,2);Phi_s(241:360,2)];
Phi_ndp55 = [Phi_s(1:120,3);Phi_s(241:360,3)];

Phi_ndf35 = Phi_s(121:240,2);
Phi_ndf55 = Phi_s(121:240,3);
for i = 1:numel(Fr_ndf35)
    if and(Fr_ndf35(i)>0.6, Phi_ud35(i)<3*10^-4)
        Fr_ndf35(i) = nan;
    end
end
clear Qb_nc Qb_c wm Phi_S Fr_steady

%% DATA UNSTEADY - LIMITED IMPOUNDING (SPILLWAYS)
cd ..\..
cd('UnsteadyFlowAnalyses')

Fr_dsp55 = xlsread('20161123_unsteady_spillway.xlsx',1, 'Q10:Q34');
Phi_dsp55 = xlsread('20161123_unsteady_spillway.xlsx',1, 'O10:O34');

cd ..
cd('Plots\Unsteady')
clear data_nc t_rows h0_nc wm
% Fr_nc = [Fr_nc(:,1);Fr_nc(:,2);Fr_nc(:,3)];
% Phi_nc = [Phi_nc(:,1);Phi_nc(:,2);Phi_nc(:,3)];



%% SEND TO PLOTTING
fPlot_FrDx_PhiC(Fr_udp35, Fr_udp55, Fr_udf35, Fr_udf55, ...
                 Fr_ndp35, Fr_ndp55, Fr_ndf35, Fr_ndf55, ...
                  Fr_dsp55, ...
                   Phi_ud35, Phi_ud55, ...
                    Phi_ndp35, Phi_ndp55, Phi_ndf35, Phi_ndf55, ...
                     Phi_dsp55, 1);


