function [Hnc, hnc, wMaxNc, wc, alphac,tau ] = fGetHnc(Q, hnc4, hnc5 )
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.108007185405901;
alphac = 24.1823071481361;
g = 9.81;
Dmax = 0.021;   %[m]
a_c = 122.062;
b_c=-48.2962;
c_c=-108.3;
d_c=-87.629;
c = a_c*exp(b_c*Q)+c_c*exp(d_c*Q);
% get discretization length of Jf computation
dx = 1.5*0.01/2.0;
njConst = 11;      % position of constriction (value from lateral const.)
DX = [0.5920, 0.5480, 0.4210, 0.2740]; % section length
NX = ceil(DX./dx);      %[-]


dhnc = hnc4-hnc5;
hnc = hnc4;%-njConst/NX(4)*dhnc;
wMaxNc = wc + 2*hnc/tand(alphac);



A0 = hnc*(wc+hnc/tand(alphac));
P0 = wc+2*hnc/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
Hnc = hnc+u0^2/(2*g)+dx*u0^2/c^2/Rh0;
% tau = Rh0*(u0^2/c^2/Rh0)/(1.68*Dmax);
tau = fGetTaucNC(Q);
end

