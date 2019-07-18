function [ hcr ] = fGethcr(alpha, Q, w)
% Function computes critical flow depth of trapezoidal channels

% definition of analysis consideration
% alpha = bank slope [deg]
% Q = dischare vector [m³/s]
% w = base width [m]



%% DATA AND VARIABLE PREPARATION ------------------------------------------

m = 1/tand(alpha);
g = 9.81;  
hcr = nan(size(Q));
%% COMPUTATION ------------------------------------------------------------


for i = 1:numel(Q)
   count = 0;
   eps = 1;
   ycr = 0.00;%Q(i)^2/g;
   while eps > 10^-3
       ycr = ycr+0.000001;
       %ycr_it = (g*(w*ycr+ycr^2/m)^3-Q(i)^2*w)/(2*m*Q(i));
       Q_it = sqrt(g*(w*ycr+m*ycr^2)^3/(w+2*m*ycr));
       %eps = abs(abs(ycr_it-ycr)/ycr);
       eps = abs(Q_it-Q(i))/Q(i);
       count = count+1;
       if count > 10^7
           disp('Warning: Iteration break for critical flow depth.')
           ycr = nan;
           break;
       end
   end
   if not(isnan(Q(i)))
       hcr(i) = ycr;
   end
end



