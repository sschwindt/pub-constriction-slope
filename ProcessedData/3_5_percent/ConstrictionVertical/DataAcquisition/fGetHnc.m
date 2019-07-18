function [ hnc, Hnc, wc, alphac, tauNC, dE_r_Qb,u0 ] = ... 
                                        fGetHnc( Q, hnc4, hnc5, Qb )
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.09645;
alphac = 24.52;

% Chezy - coefficient (interp from chezy_sectionwise.xlsx)
if Qb > 0
    a_c = -2.43137613795516*10^-7;
    b_c = -3.126537644;
    c_c = 29.2556865;
else
    a_c = -0.003969228;
    b_c = -1.476214962;
    c_c = 36.10069794;
end
c = a_c*Q^b_c+c_c;

g = 9.81;

dx = 1.5*0.01/2.0; % discretization length (C-Jf computation)
DX = [0.5920, 0.5480, 0.357, 0.354]; % section length

hnc = hnc4;

A0 = hnc*(wc+hnc/tand(alphac));
P0 = wc+2*hnc/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
Hnc = hnc+u0^2/(2*g)+dx*u0^2/c^2/Rh0;
dE_r_Qb = DX(4)*u0^2/c^2/Rh0;
% tau = Rh0*(u0^2/c^2/Rh0)/(1.68*Dmax);
tauNC = fGetTaucNC(Q);

end

