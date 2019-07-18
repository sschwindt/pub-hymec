% February 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script looks up end time of lvm files
%--------------------------------------------------------------------------
clear all;
close all;

start = 2;
fileNo = 32;
DT = nan(fileNo-start,1);

for i = start:fileNo 
    fileName = ['FlowDepth_',num2str(i,'%03i'),'.csv'];
    data = csvread(fileName);
    DT(i-start+1)=max(data(:,1));        
    
end



