function [ TauxNC ] = fGetTaucNC( Q )
% Function returns the critical shear stress of the undisturbed channel:
% TauxNc = p1*Q+p2 (--> non-constricted folder)

% Q in [m³/s], VECTOR
% output TauxNc dimensionless VECTOR of size of Q

% ASSIGN VARIABLES --------------------------------------------------------
p1 = 1.605;
p2 = 0.01396;
% info: R² = 0.8977
TauxNC = p1.*Q+p2; 

end

