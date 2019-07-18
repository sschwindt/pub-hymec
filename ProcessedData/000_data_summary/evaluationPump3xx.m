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
pumptargetRange = ['A4:A',num2str(4+rowCount-1)];
pumpsourceRange = 'B2:B36000'; % automatical fit


% load data to analyse
Qdata = xlsread(sourceName, 2, pumpsourceRange);
dt = xlsread(sourceName, 1, ['Q4:Q',num2str(4+rowCount-1)]);
fileNo = xlsread(sourceName, 1, ['L4:L',num2str(4+rowCount-1)]);

t_abs = xlsread(sourceName, 1, ['O4:O',num2str(4+rowCount-1)]);


Q_write = nan(rowCount,1);

for i = 1:rowCount
    pos1 = int64(t_abs(i))+1;
    posX = int64(t_abs(i)+dt(i));
    Q_write(i) = mean(Qdata(pos1:posX));   
end

targetRange = ['S4:S',num2str(4+rowCount-1)];
xlswrite(sourceName,Q_write,1, targetRange);

disp('Data successfully processed.');
