function [ TauxNC ] = fGetTaucNC( Q )
% Function returns the critical shear stress of the undisturbed channel:
% TauxNc = a*Q^b+c (Qb_extended.xls --> non-constricted folder)

% Q in [m³/s], VECTOR
% output TauxNc dimensionless VECTOR of size of Q

% ASSIGN VARIABLES --------------------------------------------------------
a = 0.1605;
b = 0.551;
c = 0.0006876;
% info: R² = 0.9816

TauxNC = a.*Q.^b+c; 

end

