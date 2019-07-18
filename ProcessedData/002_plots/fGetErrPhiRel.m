function [ err_Phi ] = fGetErrPhiRel(Phi)
% Error propagation analysis for lateral flow contraction

% INPUT: 
% Matrix with Fx values (size n x m)

% OUTPUT:
% err [-] discharge error/uncertainties (size n x m)
% relative to maximum value

%% READ UNCERTAINTIES
cd ..\..\..
cd('0_uncertainties')
u_PhiMax = xlsread('uncertainties.xlsx',1, 'E21');
%u_FrDx = xlsread('uncertainties.xlsx',1, 'E23');
PhiMax = 0.388;
%FrDxMax = 2.74;
cd ..
cd ('2-4-6-summary\Plots\Unsteady')
%% COMPUTE
err_Phi = Phi./PhiMax.*u_PhiMax;

end




