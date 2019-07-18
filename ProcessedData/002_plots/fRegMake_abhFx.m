function[X_nd, X_ud, Y_nd, Y_ud] = fRegMake_abhFx()
% produces regression curves with values from 
% \DataRegression\UnsteadyDeposit\[...]_regression_data.xlsx
% hydraulic obstruction measurements are on Tab. 1
%
%% READ COEFFICIENTS
cd ..\..
cd('DataRegression\UnsteadyDeposit')
sourceN = '20170113_abhFx.xlsx';


% no deposit 5.5%
p1_nd = xlsread(sourceN,2, 'C8');
p2_nd = xlsread(sourceN,2, 'E8');
X_nd = 0.3:0.01:1.9;
Y_nd = p1_nd*X_nd+p2_nd;

% small deposit 5.5%
p1_ud = xlsread(sourceN,2, 'M8');
p2_ud = xlsread(sourceN,2, 'O8');
X_ud = 0.55:0.01:2;
Y_ud = p1_ud*X_ud+p2_ud;

cd ..\..
cd('Plots\Unsteady')