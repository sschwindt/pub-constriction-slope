function [ h01, A, Rh ] = fFindH0(Jf, ck, h0, wij, alphaij, Q)
% This function finds flow depth h0 numerically for a trapezoidal bed 
%   profile solving manning equation by Newton Raphson method

% PARAMETERS:

% J = bed slope [-]
% Q = river discharge [m³/s]

err = 1;        % [-] break criterion for while loop
count = 1;
h01 = h0;
while err > 10^-3
    
    A = h0*(wij+h0/tand(alphaij));
    P =  wij+2*h0/sind(alphaij);
    dA_dh = wij+2/tand(alphaij)*h0;
    dP_dh = 2*sqrt(tand(alphaij)^(-2)+1);

    Qk = A^(3/2)*sqrt(Jf)*P^(-1/2)*ck;
    F = 1/ck*Q*P^(1/2)*A^(1/6)-A^(5/3)*sqrt(Jf);
    dF_dh = 2/3/ck*Q*A^(1/6)*P^(-1/2)*dP_dh - 5/3*A^(2/3)*sqrt(Jf)*dA_dh;

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
Rh = A/P;
h01=h0;
end

