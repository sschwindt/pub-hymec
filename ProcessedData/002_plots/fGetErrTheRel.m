function [ err_the ] = fGetErrTheRel(the)
% Error propagation analysis for lateral flow contraction

% INPUT: 
% Matrix with Fx values (size n x m)

% OUTPUT:
% err [-] discharge error/uncertainties (size n x m)
% relative to maximum value

%% READ UNCERTAINTIES
cd ..\..\..
cd('0_uncertainties')
u_theMax = xlsread('uncertainties.xlsx',1, 'E22');
theMax = 1.03;
cd ..
cd ('2-4-6-summary\Plots\Unsteady')
%% COMPUTE
err_the = the./theMax.*u_theMax;

end




