function [ Hnc,hnc, A0, wMaxNc, wc, alphac, tauNC, dE_r_Qb,u0 ]...
                                             = fGetHnc(Q, hnc4, hnc5,  Qb )
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.09645;
alphac = 24.52;
g = 9.81;

% Chezy c
if Qb > 0
    a_c = -2.43138*10^-7;
    b_c = -3.126537644;
    c_c = 29.2556865;
else
    a_c = -0.00396922789729619;
    b_c = -1.47621496194006;
    c_c = 36.1006979386107;
end
c = a_c*Q^b_c+c_c;

% get discretization length of Jf computation
dx = 1.5*0.01/2.0;

DX = [0.5920, 0.5480, 0.357, 0.3410]; % section length


hnc = hnc4;
wMaxNc = wc + 2*hnc/tand(alphac);
A0 = hnc*(wc+hnc/tand(alphac));
P0 = wc+2*hnc/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
Hnc = hnc+u0^2/(2*g)+dx*u0^2/c^2/Rh0;
dE_r_Qb = DX(4)*u0^2/(c^2*Rh0);
% tau = Rh0*(u0^2/c^2/Rh0)/(1.68*Dmax);
tauNC = fGetTaucNC(Q);
end

