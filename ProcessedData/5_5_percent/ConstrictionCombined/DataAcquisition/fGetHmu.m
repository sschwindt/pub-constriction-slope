function [ H0, mu, tau ] = fGetHmu( Q, h4,a , b, Qb )
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.12;
alphac = 25.7;

g = 9.81;
D84 = 0.0127; %[m]

% get discretization length of Jf computation
dx = 1.5*0.01/2.0;

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

% mu
h0 = h4;
A0 = h0*(wc+h0/tand(alphac));
P0 = wc+2*h0/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
H0 = h0+u0^2/(2*g)+dx*u0^2/c^2/Rh0;

mu = 3/2 * Q / (b*sqrt(2*g)*(H0^(3/2)-(H0-a)^(3/2)));

tau = Rh0*(u0^2/c^2/Rh0)/(1.68*D84);

end

