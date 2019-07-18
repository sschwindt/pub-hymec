% October 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% INFO: Steady data are provided by "transfer2data_Fr0.m"

% Script creates plot according to X-/Y-/Regression-Data Definitions
%% PREAMBLE
clear all;
close all;
%fCopyFunction('fGetErrFr.m');
%fCopyFunction('fGetErrPhi.m');

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
%% DATA UNSTEADY
load('UnsteadyDataSave.mat'); % povided by 2-4-6-summary/UnsteadyF.../main.m
% INFO: UnsteadyData.mat = 'Q','a','b','Phi','Psi','Fr0','the','t',
%                      'the_max','Fr0_max','Fr0_fs','hnc','h0','hcr','I0_u'
Fr_u = Fr0;
Phi_u = Phi;
Fr_u_fs =Fr0_fs;

Fr_u = [Fr_u(:,1);Fr_u(:,2);Fr_u(:,3)];
Fr_u_fs = [Fr_u_fs(:,1);Fr_u_fs(:,2);Fr_u_fs(:,3)];
Phi_u = [Phi_u(:,1);Phi_u(:,2);Phi_u(:,3)];
clear a b Phi h0 hnc I0_u t the the_max Fr0_max Psi Q
%% DATA STEADY
load('SteadyDataSave.mat'); % povided by 2-4-6-summary/Data/trans...data_FrDx.m
% INFO: SteadyData.mat = 'Fr_steady','theta_steady','hcr_steady', 
%                           'h0_steady','Q_steady'

% sort pressure / free surface flow conditions (prepare X VALUES)
Fr_s = nan(size(Fr_steady));
Fr_s(1:120,:) = Fr_steady(1:120,:);
Fr_s(241:360,:) = Fr_steady(241:360,:);
Fr_s_fs = nan(size(Fr_steady));
Fr_s_fs(121:240,:) = Fr_steady(121:240,:);

% get dimless bedload (prepare Y VALUES)
Phi_s = nan(size(Q_steady));
for i = 1:numel(Q_steady(:,1))
    for j = 1:3
        Qb_nc = fGetQbmax(Q_steady(i,j),I0(j));
        Qb_c = theta_steady(i,j)*Qb_nc;
        wm = w0(j)+h0_steady(i,j).*m0(j);
        Phi_s(i,j) = Qb_c/(1000*wm*((s-1)*g*D84^3)^0.5);
    end
end
clear Qb_nc Qb_c wm
Fr_s = [Fr_s(:,1);Fr_s(:,2);Fr_s(:,3)];
Fr_s_fs = [Fr_s_fs(:,1);Fr_s_fs(:,2);Fr_s_fs(:,3)];
Phi_s = [Phi_s(:,1);Phi_s(:,2);Phi_s(:,3)];

%% DATA NON CONSTRICTED
cd ..\..
cd('Data')
rows_nc = 97;
Fr_nc = nan(rows_nc,3);
Phi_nc = nan(rows_nc,3);
data_nc = xlsread('20160815_2-4-6_bedload_nc.xlsx',1, 'H5:P101');
cd ..
cd('Plots\Unsteady')
h0_nc = data_nc(:,1:3);
Q_nc = data_nc(:,4:6);
Qb_nc = data_nc(:,7:9);
errFr_nc = nan(size(Q_nc));
errPhi_nc = nan(size(Q_nc));
Phi_stat_SJ = nan(size(Q_nc));
Phi_stat_RI = nan(size(Q_nc));
for slope = 1:3    
    wm = w0(slope)+h0_nc(:,slope).*m0(slope);
    A_nc = h0_nc(:,slope).*wm;
    Fr_nc(:,slope) = Q_nc(:,slope)./(A_nc.*sqrt(g*D84));
    qb = Qb_nc(:,slope)./wm; % [m²/s]
    Phi_nc(:,slope) = qb./sqrt(g*1.68)/D84^1.5/1000;
    Phi_stat_SJ(:,slope) = fSmartJaeggiQ(Dm,D30,D90,...
                          h0_nc(:,slope),I0(slope),m0(slope),w0(slope),Q_nc(:,slope));
    Phi_stat_RI(:,slope) = fRickenmannQ(D50,D30,D90,...
                          h0_nc(:,slope),I0(slope),m0(slope),w0(slope),Q_nc(:,slope));
    errFr_nc(:,slope) = fGetErrFr(h0_nc(:,slope),Q_nc(:,slope),w0(slope),m0(slope));
    errPhi_nc(:,slope) = fGetErrPhi(h0_nc(:,slope),Qb_nc(:,slope),w0(slope),m0(slope));
    %Qb_nc(:,slope)./(1000.*wm.*((s-1)*g*D84^3)^0.5);
end

clear data_nc t_rows wm



%% BEDLOAD FORMULAE
% hx_theo = (1:10^-2:100)'; %[-] h0 / D84
% h0_theo =  hx_theo.* D84;  %[m] h0
% hx_theo = h0_theo(:,1)./D84;
Q_theo = .003:10^-4:0.11;
% Q_theo = Q_nc(:,3);
Fr_theo = nan(numel(Q_theo),3);
Phi_SM = nan(numel(Q_theo),3); %[-] Phi according to Smart-Jaeggi, 3 I0s
Phi_RIC = nan(numel(Q_theo),3); %[-] Phi according to Rickenmann, 3 I0s
Phi_REC = nan(numel(Q_theo),3); %[-] Phi according to Recking, 3 I0s
for slope = 3
    %Q_theo = fGetQ(h0_theo, I0(slope));
    h0_theo = fGeth(Q_theo,I0(slope));
    % h0_theo = h0_nc(:,slope);
    A_theo = h0_theo.*(w0(slope)+h0_theo.*m0(slope));
    Fr_theo(:,slope) = Q_theo./(A_theo.*sqrt(g*D84));
    Phi_SM(:,slope) = fSmartJaeggiQ(Dm,D30,D90,...
                          h0_theo,I0(slope),m0(slope),w0(slope),Q_theo);
    Phi_RIC(:,slope) = fRickenmannQ(D50,D30,D90,...
                          h0_theo,I0(slope),m0(slope),w0(slope),Q_theo);
    Phi_REC(:,slope) = fRecking(D84,D50,Dm,...
                          h0_theo,I0(slope),m0(slope),w0(slope));
    % eliminate FrDx values out of measurement range
    for i = 1:numel(Fr_theo(:,1))
        switch slope
            case 1
                if or(Fr_theo(i,slope)< 1.4, Fr_theo(i,slope) > 2.1)
                    Fr_theo(i,slope) = nan;
                end
                if i>1
                    if Fr_theo(i,slope)< Fr_theo(i-1,slope)
                        Fr_theo(i,slope) = nan;
                    end
                end
            case 2
                if or(Fr_theo(i,slope)< 2.1, Fr_theo(i,slope) > 2.7)
                    Fr_theo(i,slope) = nan;
                end
                if i>1
                    if Fr_theo(i,slope)< Fr_theo(i-1,slope)
                        Fr_theo(i,slope) = nan;
                    end
                end
            case 3
                if or(Fr_theo(i,slope)< 2.25, Fr_theo(i,slope) > 3.02)
                    Fr_theo(i,slope) = nan;
                end
                if i>1
                    if Fr_theo(i,slope)< Fr_theo(i-1,slope)
                        Fr_theo(i,slope) = nan;
                    end
                end
        end
    end
end
%% STATISTICS
dims = sqrt(g*(s-1))*D84^1.5*1000;

mdlSJ6 = fitlm(Phi_nc(:,3),Phi_stat_SJ(:,3));
mdlRIC6 = fitlm(Phi_nc(:,3),Phi_stat_RI(:,3));

% Coefficient of dtermination R2 - use ordinary!
R2RicAdj = mdlRIC6.Rsquared.Adjusted;
R2RicOrd =  mdlRIC6.Rsquared.Ordinary;
            
R2SjAdj = mdlSJ6.Rsquared.Adjusted;
R2SjOrd = mdlSJ6.Rsquared.Ordinary;

%% SEND TO PLOTTING
fPlot_FrDx_PhiNC(Fr_nc, Fr_theo, errFr_nc, ...
         Phi_nc, Phi_SM, Phi_RIC, Phi_REC, errPhi_nc, 1)

