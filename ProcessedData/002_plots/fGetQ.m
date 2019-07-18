function [ Q ] = fGetQ( h, I )
% Function evaluatees discharge for lab. experiments by means of 
% slope related stage-discharge (Q-h) relationships

% INPUT: 
% I = channel slope [-]
% h uniform flow depth (vector of size n x 1)

% OUTPUT:
% Q [m³/s] discharge (vector of size n x 1);


Q = nan(size(h));
if 0.03 > I
    % assign p1 and p2 according to 2p. interpolations
    p1 = 2.48579619222229;
    p2 = 0.0321024089663519;
end
if and(0.03 < I, I < 0.05)
    % assign  p1 and p2 according to 4p. interpolations
    p1 = 2.66230598445963;
    p2 = 0.0238379501572616;
end
if 0.05 < I
    % assign p1 and p2 according to 6p. interpolations
    p1 = 2.36778008867252;
    p2 = 0.0235276512003156;
end
for qq = 1:numel(Q)
    Q(qq) = (h(qq)-p2)/p1;
    if Q(qq) < 0
        Q(qq) = nan;
    end
end
end




