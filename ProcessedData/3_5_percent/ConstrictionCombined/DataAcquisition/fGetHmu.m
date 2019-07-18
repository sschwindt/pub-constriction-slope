function [ h0, H0, mu, tau ] = fGetHmu( Q, h4,a , b, Qb )
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.10;
alphac = 24.52;

g = 9.81;
D84 = 0.0127; %[m]
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

% mu
h0 = h4;
A0 = h0*(wc+h0/tand(alphac));
P0 = wc+2*h0/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
H0 = h0+u0^2/(2*g);

mu = 3/2 * Q / (b*sqrt(2*g)*(H0^(3/2)-(H0-a)^(3/2)));

tau = Rh0*(u0^2/c^2/Rh0)/(1.68*D84);

end

