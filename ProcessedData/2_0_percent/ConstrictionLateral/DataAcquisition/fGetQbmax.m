function [ Qb ] = fGetQbmax( Q )
% Function returns the bedload capacity of the undisturbed channel:
% Qb = a*Q^b+c (Qb_extended.xls --> non-constricted folder)

% Q in [m³/s], VECTOR
% output Qb in [kg/s], VECTOR of size of Q

% ASSIGN VARIABLES --------------------------------------------------------
a = 753638.076436847;
b = 3.60744250842873;
c = -0.00127443548346945;
% info: R² = 0.9154

Qb = a.*Q.^b+c; 

end

