function [ h01 ] = fFindH0(Jf, kst, wi, alphai, Q)
% This function finds flow depth h0 numerically for a trapezoidal bed 
%   profile solving manning equation by Newton Raphson method

% PARAMETERS:

% J = bed slope [-]
% Q = river discharge [m³/s]


n=1/kst;
h0 = 1;

err = 1;        % [-] break criterion for while loop
count = 1;

while err > 10^-3
    
    A = h0*(wi+h0/tand(alphai));
    P =  wi+2*h0/sind(alphai);
    dA_dh = wi+2/tand(alphai)*h0;
    dP_dh = 2*sqrt(tand(alphai)^(-2)+1);
    
    Qk = A^(5/3)*sqrt(Jf)/(n*P^(2/3));
    F = n*Q*P^(2/3)-A^(5/3)*sqrt(Jf);
    dF_dh = 2/3*n*Q*P^(-1/3)*dP_dh - 5/3*A^(2/3)*sqrt(Jf)*dA_dh;

    % compute new value for h0
    h0 = h0 - F/dF_dh;

    
    % compute relative discharge error
    %err = abs(h01-h0)/h01;
    err = abs(Qk-Q)/Q;
    count = count+1;
    if count > 999
        disp(['Break at iteration No. ', num2str(count), ...
            ' with flow depth ', num2str(h0),'.'])
        break;
    end
end
errQ = err;
h01=h0;
end

