% October 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies data from respective files, fetches discharges and flow 
% depths, computes Dim.less variables and writes them to unsteady_data.xlsx
%% VARIABLE DECLARATION

clear all;
close all;

targetName = '20161029_unsteady.xlsx';

% sediment characteristics and constants
D90 = 0.01478;
D84 = 0.01368;
Dm  = 0.00938; 
D50 = 0.00965;
D30 = 0.00423;
D16 = 0.00727;
g = 9.81;
s = 2.68;

%% MATRICES OF EXPERIMENT CHARACTERISTICS
maxRows = 120;
expNo = [4100, 4200, 4201, 4300, 5000];
seriesN = [4, 2, 2, 1, 3];      %[No] number of series per experiment
nn = sum(seriesN);

a = nan(nn,1);
b = nan(nn,1);
% slopes
I0 = ones(nn,1);
I0(1:9) = I0(1:9).*0.034772;
I0(10:12) = I0(10:12).*0.055021;
% channel geometry (US)
w0 = ones(nn,1);
w0(1:9) = w0(1:9).*0.5*(0.085066638+0.099039895); % 4p
w0(10:12) = w0(10:12).*0.5*(0.0822632278295273+0.10656594817979); % 6p
m0 = ones(nn,1);
m0(1:9) = m0(1:9).*1/tand(0.5*(22.64513793+24.99056711)); % 4p
m0(10:12) = m0(10:12).*1/tand(0.5*(23.1253549056903+25.7942975891345)); %6p
% non-constricted channel flow characteristics
p1 = ones(nn,1);
p1(1:9) = p1(1:9).*2.4372593174459;
p1(10:12) = p1(10:12).*2.42326708705156;
p2 = ones(nn,1);
p2(1:9) = p2(1:9).*0.0231639367681246;
p2(10:12) = p2(10:12).*0.0200518926402256;
% chezy interpolation coefficients
Chezy = ones(nn,3);
Chezy(1:9,:) = [ones(9,1)*(-0.00396922789729619), ...
                ones(9,1)*(-1.47621496194006),ones(9,1)*36.1006979386107];
Chezy(10:12,:) = [ones(3,1)*(-1.24019995440512*10^-9), ...
                ones(3,1)*(-4.11609949701863),ones(3,1)*35.0398976030953];

% time stamps for absolute time in experiment
timeStamp = zeros(nn,1); % 04XXX experiments are already absolute
timeStamp(10) = 48*60+30;
timeStamp(11) = 4863;%1*3600+39*60;
timeStamp(12) = 4863+32*60+24;%2*3600+11*60+40-825;

diffT = [-18, -51, -10, -9, -10];

%% OUTPUT MATRICES
Fr0 = nan(maxRows,nn);  %[-]
Fr0_fs = nan(maxRows,nn);%[-]
h0  = nan(maxRows,nn);  %[m]
hcr  = nan(maxRows,nn); %[m]
hnc = nan(maxRows,nn);  %[m]
Phi = nan(maxRows,nn);  %[-] dim. less bedload (Einstein, 1950)
Psi = nan(maxRows,nn);  %[-] flow intensity (Einstein, 1950)
Q   = nan(maxRows,nn);  %[m³/s]
Qb  = nan(maxRows,nn);  %[kg/s]
t   = nan(maxRows,nn);  %[s] time
the = nan(maxRows,nn);  %[-] rel. bedload

the_max = nan(nn,1); % maximum bedload observed during each run
Fr0_max = nan(nn,1); % related Froude number (to the_ma)

%% COMPUTE / PROCESS DATA

for eN = 1:numel(expNo)
    for sN = 1:seriesN(eN)
        %% READ UnsteadyFlow Excel files
        fileN = ['Exp_0',num2str(expNo(eN)),'_planning.xlsx'];
        data = xlsread(fileN,sN+1, ['D15:G',num2str(maxRows+15)]);
        colN = sum(seriesN(1:eN))-seriesN(eN)+sN;  % column number 
        rowN = find(isnan(data(:,1)),1,'first')-1; % number of measurements
        if isempty(rowN)
            rowN = numel(data(:,1));
        end
        t(1:rowN,colN) = data(1:rowN,1)+timeStamp(colN); % absolute time
        Qb(1:rowN,colN) = data(1:rowN,4);
        
        if not(isempty(xlsread(fileN,sN+1,'E6')))
            a(colN) = xlsread(fileN,sN+1,'E6');
        end
        if not(isempty(xlsread(fileN,sN+1,'E7')))
            b(colN) = xlsread(fileN,sN+1,'E7');
        end
        
        %% READ Q AND h MEASUREMENTS
        Q(1:rowN,colN) = fGetDischarge(expNo(eN),t(1:rowN,colN),diffT(eN));
        h0(1:rowN,colN)= fGetFlowDepth(expNo(eN),sN+1,t(1:rowN,colN));
        hcr(1:rowN,colN)= fGethcr(atand(1/m0(colN)),Q(1:rowN,colN),w0(colN));
        % convert t to relative time
        t(1:rowN,colN) = t(1:rowN,colN)-t(1,colN);
        
        %% COMPUTE REMAINING PARAMETERS
        hnc(1:rowN,colN) = p1(colN).*Q(1:rowN,colN)+p2(colN);
        Anc = hnc(1:rowN,colN).*(w0(colN)+hnc(1:rowN,colN).*m0(colN));
        Pnc = w0(colN)+2.*hnc(1:rowN,colN).*sind(atand(1/m0(colN)));
        Rhnc = Anc./Pnc;
        Psi(1:rowN,colN) = (s-1)*D84./Rhnc./I0(colN);
        
%         Fr0(1:rowN,colN) = Q(1:rowN,colN).*((w0(colN)+2.*...
%                             h0(1:rowN,colN).*sind(atand(1/m0(colN))))./...
%                             (h0(1:rowN,colN).*(w0(colN)+h0(1:rowN,colN).*...
%                             m0(colN))).^3./g).^0.5;
        Fr0(1:rowN,colN) = Q(1:rowN,colN)./...
                            (h0(1:rowN,colN).*(w0(colN)+h0(1:rowN,colN).*...
                            m0(colN)))./(g*D84).^0.5;
        wm = w0(colN)+h0(1:rowN,colN).*m0(colN);
        Phi(1:rowN,colN) = Qb(1:rowN,colN)./(1000.*wm.*((s-1)*g*D84.^3).^0.5);
        
        Qbmax = fGetQbmax(Q(1:rowN,colN),I0(colN));
        the(1:rowN,colN) = Qb(1:rowN,colN)./Qbmax;
        for i = 1:rowN
            if or(isnan(a(colN)), nanmean(h0(i,colN))>a(colN))
                Fr0_fs(i,colN) = Fr0(i,colN);
                Fr0(i,colN) = nan;
            end
        end
        the_max(colN) = max(the(1:rowN,colN));
        p_max = find(the(1:rowN,colN)==max(the(1:rowN,colN)),1,'first');
        Fr0_max(colN) = Fr0(p_max,colN);
        
        %% WRITE DATA
        xlswrite(targetName,[t(1:rowN,colN),Q(1:rowN,colN),...
                 Qb(1:rowN,colN),h0(1:rowN,colN),hnc(1:rowN,colN),...
                 Psi(1:rowN,colN),Fr0(1:rowN,colN),Phi(1:rowN,colN),...
                 the(1:rowN,colN)],colN,['B7:J',num2str(7+rowN-1)]);
        xlswrite(targetName,[expNo(eN),sN+1,a(colN),b(colN),I0(colN)],...
                 colN,'B3:F3');
        disp(['Data of EXP 0', num2str(expNo(eN)), ', File N. ', ...
            num2str(sN+1), ' written to ',targetName, ', Tab. ', ...
            num2str(colN),'.']);
    end
end
% save relevant variables for plotting in according folder
cd ..
cd('Plots\Unsteady')
I0_u = I0;
save('UnsteadyData.mat','Q','a','b','Phi','Psi','Fr0','the','t',...
    'the_max','Fr0_max','Fr0_fs','hnc','h0','hcr','I0_u')
cd ..\..
cd('UnsteadyFlowAnalyses')
load handel
sound(y(2000:5000),Fs)