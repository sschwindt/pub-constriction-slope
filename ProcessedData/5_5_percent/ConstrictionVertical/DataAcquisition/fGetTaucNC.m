function [ TauxNC ] = fGetTaucNC( Q )
% Function returns the critical shear stress of the undisturbed channel:
% from interpolation in 20160622_Qb_h_nonconstricted.xlsx

% Q in [m³/s], VECTOR
% output TauxNc dimensionless VECTOR of size of Q

% ASSIGN VARIABLES --------------------------------------------------------
p1 = 2.39;
p2 = 0.03975;
% info: R² = 0.7406

TauxNC = p1.*Q+p2; 

end

