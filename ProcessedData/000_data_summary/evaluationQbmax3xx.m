% November 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 6301;       % Experiment No.

startWriteRow = 4; % Row number where writing begins in targetName@xls

% define rows with measurements of Qs,max
switch ExpNo
    case 6300
        rowCount = 141;      % Number of useful experiments in file
    case 6301
        rowCount = 218;      % Number of useful experiments in file
end
    

% DO NOT TOUCH ------------------------------------------------------------
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];


% load data to analyse
Q = xlsread(sourceName, 1, ['S4:S',num2str(4+rowCount-1)]);
Qb = xlsread(sourceName, 1, ['P4:P',num2str(4+rowCount-1)]);
NoQ = xlsread(sourceName, 1, ['V4:V',num2str(4+rowCount-1)]);
fileNo = xlsread(sourceName, 1, ['L4:L',num2str(4+rowCount-1)]);
a = xlsread(sourceName, 1, ['T4:T',num2str(4+rowCount-1)]);
b = xlsread(sourceName, 1, ['U4:U',num2str(4+rowCount-1)]);

nRel = max(NoQ);        %[No] effective number of discharges
a_rel = nan(nRel,1);
b_rel = nan(nRel,1);
fNo_rel = nan(nRel,1);
Q_rel = nan(nRel,1);
Qb_rel = nan(nRel,1);

for i = 1:nRel
    pos1 = int64(find(NoQ==i,1,'first'));
    posX = int64(find(NoQ==i,1,'last'));    
    
    Qb_rel(i) = max(Qb(pos1:posX));
    posQbmax = pos1+int64(find(Qb(pos1:posX)==Qb_rel(i),1,'first'))-1;
    a_rel(i) = a(posQbmax);
    b_rel(i) = b(posQbmax);
    fNo_rel(i) = fileNo(posQbmax);
    Q_rel(i) = mean(Q(pos1:posX));
end

writeData = [Q_rel,Qb_rel,a_rel,b_rel,fNo_rel];
targetRange = ['A4:E',num2str(4+nRel-1)];
xlswrite(sourceName,writeData,1, targetRange);

disp('Data successfully processed.');
