% November 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script gets mean flow depth of single measurements and transfers it to
% excel file
%--------------------------------------------------------------------------
clear all;
close all;


ExpNo = 6301;       % Experiment No.
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];
sourceRange = 'A4:E100'; % dummy length (auto fit)


startRow = 4; % Row number where writing begins in targetName@xls
expData = xlsread(sourceName, 1, sourceRange);

% LOAD DATA ---------------------------------------------------------------
cd ..\..
result = nan(numel(expData(:,1)),5);
cd(['Analysis_No_', num2str(ExpNo,'%05i'),'\FlowDepth'])

for iX = 1:numel(expData(:,1))
    fileNo = expData(iX,5);
    csvData=csvread(['FlowDepth_', num2str(fileNo,'%03i'),'.csv']);
    if not(numel(csvData(:,1)<55))
        result(iX,:)=nanmean(csvData(1:55,2:6));
    else
        result(iX,:)=nanmean(csvData(:,2:6));
    end
%     if and(ExpNo == 6301, or(expData(iX,5) == 2,expData(iX,5) == 108))
%         result(iX,:)=nanmean(csvData(end-12:end,2:6));
%     end
end
cd ..\..
% WRITE DATA --------------------------------------------------------------
cd('2-4-6-summary\UnsteadyFlowAnalyses')
targetRange = ['F',num2str(startRow),':J',...
                                num2str(startRow+numel(expData(:,1))-1)];
xlswrite(sourceName,result, 1, targetRange);


disp(['Data successfully processed.']);

