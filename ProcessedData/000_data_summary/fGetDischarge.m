function [ Q ] = fGetDischarge( expNo, timeStamps, diffT)
% Function return fetches discharge measurements from corresponding folder
%% INPUT: timeStamps [s] vector with absolute times for start discharge
%         diffT      [s] delay between stop watch and pump file
%         expNo      [N] 4-digits experiment number
%
%% OUTPUT: Q         [m3/s] vector of size(timeStamps)
% 
% SCRIPT ASSUMES TO BE IN FOLDER 'UnsteadyFlowAnalyses' !
%% READ DATA

Q = nan(numel(timeStamps,1),1); 

cd ..\..
cd(['Analysis_No_', num2str(expNo,'%05i'),'\Pump'])

csvData=csvread('Discharges_001.csv');  % discharge in [l/s]

for i = 1:numel(timeStamps)
    t_ini = timeStamps(i)+diffT;
    if not(i==numel(timeStamps))
        t_end = timeStamps(i+1)+diffT-1;
    else
        t_end = timeStamps(i)+diffT+60; % last dt is always 60 sec.
    end
    Q(i,1) = nanmean(csvData(int64(t_ini):int64(t_end),2))*10^-3;
end

cd ..\..
cd('2-4-6-summary\UnsteadyFlowAnalyses')


