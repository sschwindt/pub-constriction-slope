function [ err ] = fGetErrQlat(Cc,fcr,g,h0,hcr_s,I,L,m,Q,w,wm,type)
% Error propagation analysis for lateral flow contraction

% INPUT: 
% I = channel slope [-]
% h uniform flow depth (vector of size n x 1)
% Qc [m³/s] computed value of Q (vector of size n x 1);

% OUTPUT:
% err [m³/s] discharge error (vector of size n x 1);

%% DEFINE SINGULAR ERRORS (uncertainties)
err_Cc = 0.02773;   %[-] slope corrected discharge coefficient
err_hLat=0.0035;    %[m] flow depth at lateral contractions
err_I  = 0.000001;     %[-] channel bottom slope
err_m  = 0.1486;    %[-] bank slope
err_Q  = 0.02;      %[-] percentage value --> use as multiple of Q!
err_w  = 0.0188;    %[m] channel bottom width

%% COMPUTE
err = nan(size(Q));
for i = 1:numel(Q)
    if type(i) == 0
        err(i) = Cc(i)*h0(i)*sqrt(2*g*(1.5*hcr_s(i)-h0(i)-fcr*I*L))*(...
            wm(i)/Cc(i)*err_Cc + err_w + h0(i)*err_m + ...
            1/(2*h0(i)^2*wm(i)*(1.5*hcr_s(i)-h0(i)-fcr*I*L)) * (...
                (6*h0(i)^3*hcr_s(i)*m^2+9*h0(i)^2*hcr_s(i)*m*w+...
                3*h0(i)*hcr_s(i)*w^2-5*h0(i)^4*m^2-8*h0(i)^3*w*m-...
                3*h0(i)^2*w^2-fcr*I*L*(3*h0(i)^3*m^2+6*h0(i)^2*w*m+...
                h0(i)^2*w^2))*err_hLat + 1.5*h0(i)*wm(i)*err_Q*Q(i) - ...
                h0(i)*wm(i)*fcr*L*err_I));
    else
        err(i) = 0;
    end
end
end




