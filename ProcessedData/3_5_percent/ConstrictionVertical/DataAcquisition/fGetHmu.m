function [ H0, mu, tau ] = fGetHmu( Q, h4, a, Qb )
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.10;
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
D84 = 0.0127; %[m]

dx = 1.5*0.01/2.0; % discretization length (C-Jf computation)

% check if backwater occures
h0 = h4;
A0 = h0*(wc+h0/tand(alphac));
P0 = wc+2*h0/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
H0 = h0+u0^2/(2*g)+dx*u0^2/c^2/Rh0;

b = wc + a/tand(alphac);
mu = 3/2 * Q / (b*sqrt(2*g)*(H0^(3/2)-(H0-a)^(3/2)));

tau = Rh0*(u0^2/c^2/Rh0)/(1.68*D84);
end

