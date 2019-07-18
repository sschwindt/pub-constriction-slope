% September 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script completes summary table for combined constrictions
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160919_data_monte_carlo.xlsx';


g = 9.81;       %[m/s²]
Dmax = 0.021;   %[m]
D84 = 0.0127;   %[m]
% READ DATA ---------------------------------------------------------------
tempdata = xlsread(sourceName, 1, 'C4:F2053');
% get discharges
Q = tempdata(:,1);
h4 = tempdata(:,4);

% get opening size
a = tempdata(:,2);
b = tempdata(:,3);



% COMPUTE -----------------------------------------------------------------

ahnc = nan(size(Q));
bRel = nan(size(Q));
mu = nan(size(Q));
Fr = nan(size(Q));
zeta = nan(size(Q));

for dq = 1:numel(Q)
    hnc4 = 2.423267087*Q(dq)+0.020051893;
    hnc5 = 2.470074683*Q(dq)+0.019398074;
    dz45 = 0.0187;
    dh45 =  h4(dq)- hnc5;
    w4=0.0822632278295273;
    w5=0.10656594817979;
    alpha4 = 23.1253549056903;
    alpha5 = 25.7942975891345;
    alpha=mean([alpha4, alpha5]);
    A4c = h4(dq)*(w4+h4(dq)/tand(alpha4));
    A5c = hnc5*(w5+hnc5/tand(alpha5));
    
    [hnc, Hnc,  Anc, wMaxNc, wc, alphac, tauNC, dE_r_Qb, u0] = ...
                                        fGetHnc(Q(dq), hnc4, hnc5, 0);
    ahnc(dq) = a(dq)/hnc;
    bRel(dq) = b(dq)/wMaxNc;

    % cross-section data of laterally constricted channel
    [H0, mu(dq), tauxc] = fGetHmu(Q(dq), h4(dq), a(dq), b(dq), 0);

      
    Fr(dq) = Q(dq)*sqrt(w4+2*h4(dq)/tand(alpha4))/...
                    (h4(dq)*(w4+ h4(dq)/tand(alpha4)))^(3/2)/sqrt(g);
    % energy losses  
    dE_abs = dz45+dh45+Q(dq)^2/(2*g)*(1/A4c^2-1/A5c^2);
    if (dE_abs>0)
        dEc = dE_abs;
    else
        dEc = nan;
    end
    zeta(dq) = dEc*2*g/u0^2;
end
targetRange = 'G4:K2053';

% write data
xlswrite(sourceName,[ ahnc,bRel,Fr,zeta,mu ], 1, targetRange);


disp('Data processed.');
