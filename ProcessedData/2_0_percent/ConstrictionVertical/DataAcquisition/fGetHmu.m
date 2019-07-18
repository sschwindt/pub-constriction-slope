function [ H0, mu, tau ] = fGetHmu( Q, h4,a )
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.11;
alphac = 24.18;

g = 9.81;
D84 = 0.013;

% c - coefficients
a_c = 122.062;
b_c=-48.2962;
c_c=-108.3;
d_c=-87.629;
c = a_c*exp(b_c*Q)+c_c*exp(d_c*Q);

% check if backwater occures
h0 = h4;
A0 = h0*(wc+h0/tand(alphac));
P0 = wc+2*h0/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
H0 = h0+u0^2/(2*g);

b = wc + a/tand(alphac);

mu = 3/2 * Q / (b*sqrt(2*g)*(H0^(3/2)-(H0-a)^(3/2)));

% ORIGINAL
% mu = Q/sqrt(8*g)*...
%         (wc/3*H0^(3/2)*(1-(1-a/H0)^(3/2))+...
%           2/3*H0^(5/2)/tand(alphac)*(1-(1-a/H0)^(3/2))-...
%             2/5*H0^(5/2)/tand(alphac)*(1-(1-a/H0)^(5/2)))^-1;

tau = Rh0*(u0^2/c^2/Rh0)/(1.68*D84);
end

