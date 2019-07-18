function [Hnc, hnc, wMaxNc, wc, alphac,tau, dE_r_Qb,u0 ] = fGetHnc(Q, hnc4, hnc5, Qb)
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.0823;
alphac = 25.7943;

% Chezy - coefficient (interp from chezy_sectionwise.xlsx)
if Qb > 0
    a_c = -0.000550803013919247;
    b_c = -1.77759631374814;
    c_c = 32.068577866466;
else
    a_c = -1.24019995440512*10^-9;
    b_c = -4.11609949701863;
    c_c = 35.0398976030953;
end
c = a_c*Q^b_c+c_c;

g = 9.81;


dx = 1.5*0.01/2.0; % discretization length (C-Jf computation)
DX = [0.5920, 0.5480, 0.357, 0.354]; % section length

hnc = hnc4;
wMaxNc = wc + 2*hnc/tand(alphac);



A0 = hnc*(wc+hnc/tand(alphac));
P0 = wc+2*hnc/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
Hnc = hnc+u0^2/(2*g)+dx*u0^2/c^2/Rh0;
dE_r_Qb = DX(4)*u0^2/c^2/Rh0;
% tau = Rh0*(u0^2/c^2/Rh0)/(1.68*Dmax);
tau = fGetTaucNC(Q);
end

