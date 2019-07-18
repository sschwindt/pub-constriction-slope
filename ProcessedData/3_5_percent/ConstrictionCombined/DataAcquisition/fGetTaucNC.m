function [ TauxNC ] = fGetTaucNC( Q )
% Function returns the critical shear stress of the undisturbed channel:
% TauxNc = linear reg. (non-constricted folder)

% Q in [m³/s], VECTOR
% output TauxNc dimensionless VECTOR of size of Q

% ASSIGN VARIABLES --------------------------------------------------------
p1 = 2.165;
p2 = 0.0318;

% info: R² = 0.813

TauxNC = p1.*Q+p2; 

end

