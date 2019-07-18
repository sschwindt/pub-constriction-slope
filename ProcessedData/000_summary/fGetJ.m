function [ Je, u ] = fGetJ( Q, h, i )
% Function loads c coefficients for distinct discharges and channel
% sections based on non-constricted chezy scriptum

% REQUIREMENT: 
% i = channel slope:
%   i = 1 - 2p
%   i = 2 - 4p
%   i = 3 - 6p
% Q discharge (vector of size n x 1);
% h uniform flow depth (vector of size n x 1)

% OUTPUT:
% returns energy slope Je (size n x 1)



Je = nan(size(Q));
u = nan(size(Q));
for qq = 1:numel(Q)
    % get Chezy coefficient & geometry details
    switch i
        case 1 %
            a_c = 122.062;
            b_c =-48.2962;
            c_c =-108.3;
            d_c =-87.629;
            c = a_c*exp(b_c*Q(qq))+c_c*exp(d_c*Q(qq));
            w0 = 0.111;
            alpha0 = 24.6;
        case 2
            a_c = -2.43137613*10^-7;
            b_c = -3.12654;
            c_c = 29.25569;
            w0 = 0.085066638;
            alpha0 = 22.64513793;
            c = a_c*Q(qq)^b_c+c_c;
        case 3
            a_c = -0.000550803013919;
            b_c = -1.7776;
            c_c = 32.06858;
            w0 = 0.0822632278295273;
            alpha0 = 23.1253549056903;
            c = a_c*Q(qq)^b_c+c_c;
    end
    A = h(qq)*(w0+h(qq)/tand(alpha0));
    Rh = A/ (w0+2*h(qq)/sind(alpha0));
    Je(qq) = Q(qq)^2/(A^2*c^2*Rh);
    u(qq) = sqrt(9.81*Rh*Je(qq));
end
end




