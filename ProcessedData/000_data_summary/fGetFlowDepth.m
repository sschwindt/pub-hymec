function [ h ] = fGetFlowDepth( expNo, fileNo, timeStamps)
% Function return fetches discharge measurements from corresponding folder
%% INPUT: expNo      [N] 4-digits experiment number
%         fileNo     [N] file Number(series)
%         timeStamps [s] vector with absolute times
%
%% OUTPUT: h         [m] vector of size(timeStamps)
% 
% SCRIPT ASSUMES TO BE IN FOLDER 'UnsteadyFlowAnalyses' !
%% READ DATA

h = nan(numel(timeStamps),1); 

cd ..\..
cd(['Analysis_No_', num2str(expNo,'%05i'),'\FlowDepth'])

csvData=csvread(['FlowDepth_', num2str(fileNo,'%03i'),'.csv']);

for i = 1:numel(timeStamps)
    t_ini = timeStamps(i)-timeStamps(1)+1;
    if not(i==numel(timeStamps))
        t_end = timeStamps(i+1)-timeStamps(1);
    else
        t_end = timeStamps(i)+5-timeStamps(1); 
    end
    if not(int64(t_end) > int64(max(csvData(:,1))))
        h(i,1) = nanmean(csvData(int64(t_ini):int64(t_end),5));
    else
        disp(['Error in Exp. 0',num2str(expNo),', file N. ', ...
            num2str(fileNo),': Measurement duration exceeds probe storage.']);
    end
end

cd ..\..
cd('2-4-6-summary\UnsteadyFlowAnalyses')
