function [ err ] = fGetErrQvert(a,b,g,H0,mu,type)
% Error propagation analysis for vertical flow contraction

% INPUT: 
% --> in this folder not required due to GLOBAL VARIABLE DEFINITIONS !!!
% I = channel slope [-]
% h uniform flow depth (vector of size n x 1)
% Qc [m³/s] computed value of Q (vector of size n x 1);

% OUTPUT:
% err [m³/s] discharge error (vector of size n x 1);

%% DEFINE SINGULAR ERRORS (uncertainties)
err_a  = 0.001;     %[m] contraction width
err_b  = 0.001;     %[m] contraction width
err_hv = 0.002;     %[m] flow depth at lateral contractions
err_mu = 0.03179;   %[-] discharge coefficient

%% COMPUTE
err = nan(size(H0));

for i = 1:numel(H0)
    if type(i) == 1
        err(i) = 2/3*sqrt(2*g)*((H0(i)^1.5-(H0(i)-a)^1.5)*...
                    (err_mu*b+err_b*mu(i))+...
                  mu(i)*b*1.5*((H0(i)^0.5-(H0(i)-a)^0.5*(1-a))*err_hv + ...
                    (H0(i)^0.5-(H0(i)-a)^0.5*(H0(i)-1))*err_a));
    else
        err(i) = 0;
    end
end
end




