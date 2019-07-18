function [ h01, errQ ] = fFindH0(Jf, ck, h0, wi, alphai, Q)
% This function finds flow depth h0 numerically for a trapezoidal bed 
%   profile solving manning equation by Newton Raphson method

% PARAMETERS:

% J = bed slope [-]
% Q = river discharge [m³/s]
roughnessModell = 0;  % 0 = apply direct chezy // 1 = convert to mannings n

if roughnessModell % convert ck to mannings n for stability reasons
    n=(h0*(wi+h0/tand(alphai))/(wi+2*h0/tand(alphai)))^(1/6)/ck;
end
err = 1;        % [-] break criterion for while loop
count = 1;

while err > 10^-3
    
    A = h0*(wi+h0/tand(alphai));
    P =  wi+2*h0/sind(alphai);
    dA_dh = wi+2/tand(alphai)*h0;
    dP_dh = 2*sqrt(tand(alphai)^(-2)+1);
    switch roughnessModell
        case 0
            Qk = A^(3/2)*sqrt(Jf)*P^(-1/2)*ck;
            F = 1/ck*Q*P^(1/2)*A^(1/6)-A^(5/3)*sqrt(Jf);
            dF_dh = 2/3/ck*Q*A^(1/6)*P^(-1/2)*dP_dh - 5/3*A^(2/3)*sqrt(Jf)*dA_dh;
        case 1
            Qk = A^(5/3)*sqrt(Jf)/(n*P^(2/3));    
            F = n*Q*P^(2/3)-A^(5/3)*sqrt(Jf);
            dF_dh = 2/3*n*Q*P^(-1/3)*dP_dh - 5/3*A^(2/3)*sqrt(Jf)*dA_dh;
    end
    % compute new value for h0
    h0 = h0 - F/dF_dh;

    
    % compute relative discharge error
    %err = abs(h01-h0)/h01;
    err = abs(Qk-Q)/Q;
    count = count+1;
    if count > 999
        %         disp(['Break at iteration No. ', num2str(count), ...
        %             ' with flow depth ', num2str(h0),'.'])
        break;
    end
end
errQ = err;
h01=h0;
end

