function [ Qb ] = fGetQbmax( Q )
% Function returns the bedload capacity of the undisturbed channel:
% Qb = a*Q^b+c (--> non-constricted folder)

% Q in [m³/s], VECTOR
% output Qb in [kg/s], VECTOR of size of Q

% ASSIGN VARIABLES --------------------------------------------------------
a = 51790.00;
b = 2.64;
c = 0.;
% info: R² = 0.9834

Qb = a.*Q.^b+c; 






end

