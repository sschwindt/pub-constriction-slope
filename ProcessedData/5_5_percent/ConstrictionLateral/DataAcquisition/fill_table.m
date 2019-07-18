% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script accomplishes data summary table for lateral constrictions
%--------------------------------------------------------------------------
clear variables;
close all;
sourceName = '20160707_data_lateral.xlsx';


g = 9.81;       %[m/s²]
Dmax = 0.021;   %[m]
D84 = 0.0127;   %[m]
% READ DATA ---------------------------------------------------------------

% get linear interpolation data of non-constricted flow
ncDataQh =  xlsread(sourceName, 1, 'F4:J5');
ncDataQh_Qb =  xlsread(sourceName, 1, 'F7:J8');

% get measured flow depth of vert. const. experiments
h = xlsread(sourceName, 1, 'F13:J132');
% get discharges
Q = xlsread(sourceName, 1, 'D13:D132');
temp_Qb = xlsread(sourceName, 1, 'E13:E132');
Qb = nan(size(Q));
Qb(1:numel(temp_Qb)) = temp_Qb;
% get opening width
b = xlsread(sourceName, 1, 'K13:K132');


% COMPUTE -----------------------------------------------------------------

bRel = nan(size(Q));
mu = nan(size(Q));
muh = nan(size(Q));
alphaQ = nan(size(Q));
qbxRel = nan(size(Q));
Fr = nan(size(Q));
HH = nan(size(Q));
hnc = nan(size(Q));
hh = nan(size(Q));
taux = nan(size(Q));
tauNC = nan(size(Q));
eta = nan(size(Q));
zeta = nan(size(Q));
dEc = nan(size(Q));
bh0 = nan(size(Q));

for dq = 1:numel(Q)
    % cross-section data of undisturbed --> b / w Max, non-constricted
    if isnan(Qb(dq))
        hnc4 = ncDataQh(1,4)*Q(dq)+ncDataQh(2,4);
        hnc5 = ncDataQh(1,5)*Q(dq)+ncDataQh(2,5);
    else
        hnc4 = ncDataQh_Qb(1,4)*Q(dq)+ncDataQh_Qb(2,4);
        hnc5 = ncDataQh_Qb(1,5)*Q(dq)+ncDataQh_Qb(2,5);
    end
    [Hnc, hnc(dq), wMaxNc, wc, alphac, tauNC(dq), dE_r_Qb, u0] = ...
                                        fGetHnc(Q(dq), hnc4, hnc5, Qb(dq));
    bRel(dq) = b(dq)/wMaxNc;
    
    % cross-section data of laterally constricted channel
    [h0, H0, mu(dq), alphaQ(dq), tauxc] = ...
                                    fGetHmu(Q(dq), h(dq,4), b(dq), Qb(dq));
    HH(dq) =  Hnc / H0;
    hh(dq) =   hnc(dq) / h0;
    bh0(dq) = h0/b(dq);
    if not(isnan(Qb(dq)))
        eta(dq) = tauxc/tauNC(dq);
        taux(dq) = tauxc;
    end
    % evaluate relative bedload capacity
    QbMax = fGetQbmax(Q(dq));
    qbxMax = QbMax/(wc+hnc(dq)/tand(alphac))/sqrt(g*1.68)/D84^1.5/1000;
    qbx = Qb(dq)/(wc+hnc(dq)/tand(alphac))/sqrt(g*1.68)/D84^1.5/1000;
    qbxRel(dq) = qbx/qbxMax;
    
    % energy losses
    dz45 = 0.0187;
    dh45 =  h(dq,4)- h(dq,5);
    w4=0.0822632278295273;
    w5=0.10656594817979;
    alpha4 = 23.1253549056903;
    alpha5 = 25.7942975891345;
    Fr(dq) = Q(dq)*sqrt(w4+2*h(dq,4)/tand(alpha4))/...
                    (h(dq,4)*(w4+ h(dq,4)/tand(alpha4)))^(3/2)/sqrt(g);
    alpha=mean([alpha4, alpha5]);
    
    A4c = h(dq,4)*(w4+h(dq,4)/tand(alpha));
    A5c = h(dq,5)*(w5+h(dq,5)/tand(alpha));
    dE_abs = dz45+dh45+Q(dq)^2/(2*g)*(1/A4c^2-1/A5c^2);
    if not(dE_abs<0);%dE_r_Qb)
        dEc(dq) = dE_abs;%-dE_r_Qb;
    end
    zeta(dq) = dEc(dq)*2*g/u0^2;
    
%     if Fr(dq) > 1;
%         alphaQ(dq) = nan;
%     end
end
targetRange = 'L13:R132';

% write data
xlswrite(sourceName,[bRel,alphaQ,qbxRel,Fr, hh, taux,eta], 1, targetRange);
xlswrite(sourceName,tauNC, 1, 'T13:T132');
xlswrite(sourceName,[ zeta, dEc, mu ], 1, 'U13:W132');
disp('Data processed.');
