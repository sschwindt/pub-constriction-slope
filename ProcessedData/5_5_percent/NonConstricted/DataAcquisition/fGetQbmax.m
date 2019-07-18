function [ Qb ] = fGetQbmax( Q )
% Function returns the bedload capacity of the undisturbed channel:
% Qb = a*Q^b+c (non-constricted folder)

% Q in [m³/s], VECTOR
% output Qb in [kg/s], VECTOR of size of Q

% ASSIGN VARIABLES --------------------------------------------------------
a = -2.087572882;
b = -0.134988544118676;
c = 4.448563558;
% info: R² = 0.
Qb = a.*Q.^b+c; 
end

