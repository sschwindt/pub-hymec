% November 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies values from single Exp. filesto the summary file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = [6300,6301];    % Experiment No.
readLen = 20;          % Dummy value
targetName = '20161123_unsteady_spillway.xlsx';
rowAdd = 0;

D84 = 0.01368;
g = 9.81;
m = 1/tand(0.5*(23.125+25.7943));
s = 2.68;
w = 0.0944;

for eN = 1:numel(ExpNo)
    %% READ
    sourceName = ['Exp_', num2str(ExpNo(eN),'%05i'),'.xls'];
    Q = xlsread(sourceName, 1, ['A4:A',num2str(readLen)]);
    Qb = xlsread(sourceName, 1, ['B4:B',num2str(readLen)]);
    a = xlsread(sourceName, 1, ['C4:C',num2str(readLen)]);
    b = xlsread(sourceName, 1, ['D4:D',num2str(readLen)]);
    fNo = xlsread(sourceName, 1, ['E4:E',num2str(readLen)]);
    h = xlsread(sourceName, 1, ['F4:J',num2str(readLen)]);
    
    startWriteRow = 10+rowAdd;% Row number where writing begins in targetName@xls
    rowAdd = numel(Q);
    
    %% COMPUTE dimless variables
    Q = Q.*10^-3;
    FrDx = Q./(h(:,4).*(w+h(:,4).*m))./(g*D84).^0.5;
    wm = w+h(:,4).*m;
    Phi = Qb./(1000.*wm.*((s-1)*g*D84.^3).^0.5);
    Qbmax = fGetQbmax(Q,0.055);
    the = Qb./Qbmax;
    
    targetRange = ['B',num2str(startWriteRow),':E',...
                    num2str(startWriteRow+rowAdd-1)];
    targetRange_a = ['K',num2str(startWriteRow),':K',...
                    num2str(startWriteRow+rowAdd-1)];
    targetRange_b = ['L',num2str(startWriteRow),':L',...
                    num2str(startWriteRow+rowAdd-1)];
    targetRange_Fr= ['Q',num2str(startWriteRow),':Q',...
                    num2str(startWriteRow+rowAdd-1)];
    targetRange_h = ['F',num2str(startWriteRow),':J',...
                    num2str(startWriteRow+rowAdd-1)];
    targetRange_Ph= ['O',num2str(startWriteRow),':O',...
                    num2str(startWriteRow+rowAdd-1)];
    targetRange_th= ['P',num2str(startWriteRow),':P',...
                    num2str(startWriteRow+rowAdd-1)];
    %% WRITE 
    xlswrite(targetName,[ExpNo(eN)*ones(numel(Q),1),fNo,Q,Qb],...
                         1, targetRange);
    xlswrite(targetName, a, 1, targetRange_a);
	xlswrite(targetName, b, 1, targetRange_b);
    xlswrite(targetName, FrDx, 1, targetRange_Fr);
    xlswrite(targetName, h, 1, targetRange_h);
    xlswrite(targetName, Phi, 1, targetRange_Ph);
    xlswrite(targetName, the, 1, targetRange_th);
end
disp('Data successfully processed.');
