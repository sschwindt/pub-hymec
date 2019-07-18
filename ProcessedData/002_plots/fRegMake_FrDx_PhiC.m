function[X_nd35, X_nd55, X_ud35, X_ud55, X_dsp55, ...
         Y_nd35, Y_nd55, Y_ud35, Y_ud55, Y_dsp55, ...
         u_nd35, u_nd55, u_ud35, u_ud55, u_dsp55, ...
         u_nd35x,u_nd55x,u_ud35x,u_ud55x,u_dsp55x] = fRegMake_FrDx_PhiC()
% produces regression curves with values from 
% \DataRegression\UnsteadyDeposit\[...]_regression_data.xlsx
% hydraulic obstruction measurements are on Tab. 1
%
%% READ COEFFICIENTS
sourceN = '20161220_phi.xlsx';
cd ..\..
cd('DataRegression\UnsteadyDeposit')
% no deposit 3.5%
c_nd35 = xlsread(sourceN,1, 'C8:E8');
xlim_nd35 = xlsread(sourceN,1, 'H8:I8');

% no deposit 5.5%
c_nd55 = xlsread(sourceN,1, 'C16:E16');
xlim_nd55 = xlsread(sourceN,1, 'H16:I16');

% small deposit 3.5 %
c_ud35 = xlsread(sourceN,1, 'M8:O8');
xlim_ud35 = xlsread(sourceN,1, 'R8:S8');

% small deposit 5.5 %
c_ud55 = xlsread(sourceN,1, 'M16:O16');
xlim_ud55 = xlsread(sourceN,1, 'R16:S16');

% max deposit 5.5 %
c_dsp55 = xlsread(sourceN,1, 'W16:Y16');
xlim_dsp55 = xlsread(sourceN,1, 'AB16:AC16');

cd ..\..
cd('Plots\Unsteady')

%% MAKE REGRESSION CURVES
X_nd35 = xlim_nd35(1):10^-4:xlim_nd35(2);
X_nd55 = xlim_nd55(1):10^-4:xlim_nd55(2);
X_ud35 = xlim_ud35(1):10^-4:xlim_ud35(2);
X_ud55 = xlim_ud55(1):10^-4:xlim_ud55(2);
X_dsp55= xlim_dsp55(1):10^-4:xlim_dsp55(2);

Y_nd35 = c_nd35(1).*X_nd35.^c_nd35(2)+c_nd35(3);
Y_nd55 = c_nd55(1).*X_nd55.^c_nd55(2)+c_nd55(3);
Y_ud35 = c_ud35(1).*X_ud35.^c_ud35(2)+c_ud35(3);
Y_ud55 = c_ud55(1).*X_ud55.^c_ud55(2)+c_ud55(3);
Y_dsp55= c_dsp55(1).*X_dsp55.^c_dsp55(2)+c_dsp55(3);

%% UNCERTAINTIES
cd ..\..\..
cd('0_uncertainties')
u_PhiMax = xlsread('uncertainties.xlsx',1, 'E21');
u_FrDx = xlsread('uncertainties.xlsx',1, 'E23');
PhiMax = 0.1404;
FrDxMax = 2.74;
cd ..
cd ('2-4-6-summary\Plots\Unsteady')
u_nd35 = (Y_nd35./PhiMax.*u_PhiMax).*2;
u_nd55 = (Y_nd55./PhiMax.*u_PhiMax).*2;
u_ud35 = (Y_ud35./PhiMax.*u_PhiMax).*2;
u_ud55 = (Y_ud55./PhiMax.*u_PhiMax).*2;
u_dsp55= (Y_dsp55./PhiMax.*u_PhiMax).*2;

u_nd35x = X_nd35./FrDxMax.*u_FrDx.*2;
u_nd55x = X_nd55./FrDxMax.*u_FrDx.*2;
u_ud35x = X_ud35./FrDxMax.*u_FrDx.*2;
u_ud55x = X_ud55./FrDxMax.*u_FrDx.*2;
u_dsp55x= X_dsp55./FrDxMax.*u_FrDx.*2;