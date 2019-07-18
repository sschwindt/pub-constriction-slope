function [ h0, H0, mu, tau ] = fGetHmu( Q, h4, b )
% Function returns flow cross-section values of the undisturbed channel 
% upstream of the constriction

% h0 := upstream flow depth
% H0 := upstream energy head

wc = 0.108007185405901;
alphac = 24.1823071481361;
w4 = 0.1387;
alpha4 = 23.7858;
g = 9.81;
Dmax = 0.021;   %[m]
% get discretization length of Jf computation
dx = 1.5*0.01/2.0;
njConst = 11;      % position of constriction (value from lateral const.)
DX = [0.5920, 0.5480, 0.4210, 0.2740]; % section length
NX = ceil(DX./dx);      %[-]

% get channel bottom slope 
[c, Jf] = fGetcJData(0.005,4,0); % dummy values, only J from interest
% c - coefficients
a_c = 122.062;
b_c=-48.2962;
c_c=-108.3;
d_c=-87.629;
c = a_c*exp(b_c*Q)+c_c*exp(d_c*Q);


h0 = h4;
A0 = h0*(wc+h0/tand(alphac));
P0 = wc+2*h0/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
H0 = h0+u0^2/(2*g)+dx*u0^2/c^2/Rh0;

if b < wc
    wcc = b;
else
    wcc = wc;
end

mu = Q/sqrt(4*g)*(wcc/3*(H0^(3/2)-(H0-(b-wcc)/2*tand(alphac))^(3/2))+...
       2/3*H0/tand(alphac) *(H0^(3/2)-(H0-(b-wcc)/2*tand(alphac))^(3/2))-...
         2/5/tand(alphac)*(H0^(5/2)-(H0-(b-wcc)/2*tand(alphac))^(5/2))+...
           b/3*(H0-(b-wcc)/2*tand(alphac))^(3/2))^-1;

tau = Rh0*(u0^2/c^2/Rh0)/(1.68*Dmax);
end

