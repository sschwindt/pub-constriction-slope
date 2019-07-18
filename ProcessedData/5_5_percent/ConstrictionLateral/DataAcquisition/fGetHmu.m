function [ h0, H0, mu, alphaQ, tau ] = fGetHmu( Q, h4, b, Qb )
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



h0 = h4;
A0 = h0*(wc+h0/tand(alphac));
P0 = wc+2*h0/sind(alphac);
Rh0 = A0/P0;
u0 = Q/A0;
H0 = h0+u0^2/(2*g)+dx*u0^2/c^2/Rh0;


if u0/sqrt(g*h0) < 1
    mu = 3/2 * Q / (b*sqrt(2*g)*H0^(3/2));
else
    mu = nan;
end


% alphaQ
m = 1/tand(alphac);
eps = 1;
count = 1;
if b <= 5*wc
    Q_prev = Q;
    while eps > 0.99
        Qcalc = (2/3)^1.5*b/g*(h0*g+Q_prev^2/(2*A0^2))^1.5;
        eps = abs(Qcalc-Q_prev)/abs(Q_prev);
        count = count+1;
        Q_prev =Qcalc;
        if count > 1000
            disp('No convergence (rectangular).')
            break;
        end
    end
else
    hcr_prev = 2/3*h0;  % initial value for hcr
    Q_prev = Q;
    w4=0.0822632278295273; % update for US flow conditions
    wc = w4;
    while eps > 0.001
        hcr = hcr_prev;
        Acr = b*hcr+(b-wc)^2/(4*m);
        Qcalc = sqrt(2*g*(hcr-h0)/(1/A0^2-1/Acr^2));
        hcr_prev = (Qcalc^2/(b^2*g))^(1/3)-(b-wc)^2/(4*b*m);
        %eps = abs(hcr-hcr_prev)/abs(hcr);
        eps = abs(Qcalc-Q_prev)/abs(Q_prev);
        Q_prev = Qcalc;
        count = count+1;
        if count > 1000
            disp('No convergence (trapez+rect.).')
            Qcalc = nan;
            break;
        end
    end
end
alphaQ = Q/Qcalc;

tau = Rh0*(u0^2/c^2/Rh0)/(1.68*D84);
end

