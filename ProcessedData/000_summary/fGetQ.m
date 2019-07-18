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
    p1 = 2.375;
    p2 = 0.03237;
end
if and(0.03 < I, I < 0.05)
    % assign  p1 and p2 according to 4p. interpolations
    p1 = 2.4372593174459;
    p2 = 0.0231639367681246;
end
if 0.05 < I
    % assign p1 and p2 according to 6p. interpolations
    p1 = 2.42326708705156;
    p2 = 0.0200518926402256;
end
for qq = 1:numel(Q)
    Q(qq) = (h(qq)-p2)/p1;
    if Q(qq) < 0
        Q(qq) = nan;
    end
end
end




