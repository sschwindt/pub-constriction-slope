% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script completes summary table for VERTICAL constrictions
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160706_data_vertical.xlsx';


g = 9.81;       %[m/s²]
Dmax = 0.021;   %[m]
D65 = 0.0081;
% READ DATA ---------------------------------------------------------------

% get linear interpolation data of non-constricted flow
ncDataQh =  xlsread(sourceName, 1, 'F4:J5');
ncDataQh_Qb =  xlsread(sourceName, 1, 'F7:J8');

% get measured flow depth of vert. const. experiments
h = xlsread(sourceName, 1, 'F13:J94');
% get discharges
Q = xlsread(sourceName, 1, 'D13:D94');
temp_Qb = xlsread(sourceName, 1, 'E13:E94');
Qb = nan(size(Q));
Qb(1:numel(temp_Qb)) = temp_Qb;
% get opening size
a = xlsread(sourceName, 1, 'L13:L94');



% COMPUTE -----------------------------------------------------------------
aH0 = nan(size(Q));
ah0 = nan(size(Q));
aHnc = nan(size(aH0));
ahnc = nan(size(ah0));
HH = nan(size(aH0));
hh = nan(size(ah0));
mu = nan(size(Q));
muh = nan(size(Q));
qbxRel = nan(size(Q));
Fr = nan(size(Q));
taux = nan(size(Q));
eta  = nan(size(Q));
zeta = nan(size(Q));
dEc = nan(size(Q));

for dq = 1:numel(Q)
    % cross-section data of undisturbed --> b / w Max, non-constricted
    if isnan(Qb(dq))
        hnc4 = ncDataQh(1,4)*Q(dq)+ncDataQh(2,4);
        hnc5 = ncDataQh(1,5)*Q(dq)+ncDataQh(2,5);
    else
        hnc4 = ncDataQh_Qb(1,4)*Q(dq)+ncDataQh_Qb(2,4);
        hnc5 = ncDataQh_Qb(1,5)*Q(dq)+ncDataQh_Qb(2,5);
    end
    [hnc, Hnc, wc, alphac, tauNC, dE_r_Qb, u0] = ...
                                        fGetHnc(hnc4, hnc5, Q(dq), Qb(dq));
    aHnc(dq) = a(dq)/Hnc;
    ahnc(dq) = a(dq)/hnc;
    
    % cross-section data of vertically constricted channel
    [H0, mu(dq), tauxc] = fGetHmu(Q(dq), h(dq,4), a(dq), Qb(dq));
    aH0(dq) = a(dq)/H0;
    ah0(dq) = a(dq)/h(dq,4);
    HH (dq) = Hnc/H0;
    hh (dq) = hnc4/h(dq,4);
    if not(isnan(Qb(dq)))
        eta(dq) = tauxc/tauNC;
        taux(dq) = tauxc;
    end
   % evaluate relative bedload capacity
    QbMax = fGetQbmax(Q(dq));
    qbxMax = QbMax/(wc+hnc/tand(alphac))/sqrt(g*1.68)/D65^1.5/1000;
    qbx = Qb(dq)/(wc+hnc/tand(alphac))/sqrt(g*1.68)/D65^1.5/1000;
    qbxRel(dq) = qbx/qbxMax;
    
    % energy losses
    dz45 = 0.0187;
    dh45 =  h(dq,4)- h(dq,5);
    w4=0.0822632278295273;
    w5=0.10656594817979;
    alpha4 = 23.1253549056903;
    alpha5 = 25.7942975891345;
    alpha = 0.5*(alpha4+alpha5);
    A4c = h(dq,4)*(w4+h(dq,4)/tand(alpha));
    A5c = h(dq,5)*(w5+h(dq,5)/tand(alpha));
    dE_abs = dz45+dh45+Q(dq)^2/(2*g)*(1/A4c^2-1/A5c^2);
    if not(dE_abs<0)
        dEc(dq) = dE_abs;
    end
    zeta(dq) = dEc(dq)*2*g/u0^2;
    
    % Froude
    Fr(dq) = Q(dq)*sqrt(w4+2*h(dq,4)/tand(alpha4))/...
                    (h(dq,4)*(w4+ h(dq,4)/tand(alpha4)))^(3/2)/sqrt(g);
end

targetRange = 'M13:T94';
height_c = 1/max(ahnc);
tau_c = 1/max(eta);
ahnc = ahnc.*height_c;
pos1 = find(ahnc == 1);
ahnc(pos1)=nan;
% ah0 = ah0.*height_c;
%eta = eta.*tau_c;
pos1 = find(eta == 1);
eta(pos1)=nan;
% write data
xlswrite(sourceName,[ ah0,ahnc,eta,qbxRel,Fr,hh,taux,mu ], 1, targetRange);
xlswrite(sourceName,[ muh, zeta, dEc ], 1, 'U13:W94');

disp('Data processed.');
