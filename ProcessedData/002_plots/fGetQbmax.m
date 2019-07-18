function [ Qb ] = fGetQbmax( Q, I0 )
% Function returns the bedload capacity of the undisturbed channel 
% according to channel slope:
% Qb = a*Q^b+c (--> non-constricted folder)

% Q in [m³/s], VECTOR
% output Qb in [kg/s], VECTOR of size of Q

%% ASSIGN VARIABLES
if 0.03 > I0
    % assign a-b-c according to 2p. interpolations
    a = 753638.076436847;
    b = 3.60744250842873;
    c = -0.00127443548346945;
    % info: R² = 0.9154
end
if and(0.03 < I0, I0 < 0.05)
    % assign a-b-c according to 4p. interpolations
    a = 51790.00;
    b = 2.64;
    c = 0.;
    % info: R² = 0.9834
end
if 0.05 < I0
    % assign a-b-c according to 6p. interpolations
    a = 301.1;%73.63;%-2.087572882;
    b = 1.357;%1;%-0.134988544118676;
    c = 0;%-0.1569;%4.448563558;
    % info: R² = 0.97
end
Qb = a.*Q.^b+c; 

end

