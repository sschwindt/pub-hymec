function [ err_Fx ] = fGetErrFrRel(Fx)
% Error propagation analysis for lateral flow contraction

% INPUT: 
% Matrix with Fx values (size n x m)

% OUTPUT:
% err [-] discharge error/uncertainties (size n x m)
% relative to maximum value

%% READ UNCERTAINTIES
cd ..\..\..
cd('0_uncertainties')
%u_PhiMax = xlsread('uncertainties.xlsx',1, 'E21');
u_FrDx = xlsread('uncertainties.xlsx',1, 'E23');
%PhiMax = 0.1404;
FrDxMax = 1.38;
cd ..
cd ('2-4-6-summary\Plots\Unsteady')
%% COMPUTE
err_Fx = Fx./FrDxMax.*u_FrDx;

end




