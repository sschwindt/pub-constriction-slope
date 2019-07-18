% February 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script accomplishes data summary table for lateral constrictions
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160208_data_lateral.xlsx';


g = 9.81;       %[m/s²]
Dmax = 0.021;   %[m]
% READ DATA ---------------------------------------------------------------

% get linear interpolation data of non-constricted flow
ncDataQh =  xlsread(sourceName, 1, 'F4:J5');
ncDataQh_Qb =  xlsread(sourceName, 1, 'F7:J8');

% get measured flow depth of vert. const. experiments
h = xlsread(sourceName, 1, 'F13:J118');
% get discharges
Q = xlsread(sourceName, 1, 'D13:D118');
temp_Qb = xlsread(sourceName, 1, 'E13:E118');
Qb = nan(size(Q));
Qb(1:numel(temp_Qb)) = temp_Qb;
% get opening width
b = xlsread(sourceName, 1, 'K13:K118');


% COMPUTE -----------------------------------------------------------------

bRel = nan(size(Q));
mu = nan(size(Q));
qbxRel = nan(size(Q));
Fr = nan(size(Q));
HH = nan(size(Q));
taux = nan(size(Q));
tauNC = nan(size(Q));
eta = nan(size(Q));

for dq = 1:numel(Q)
    % cross-section data of undisturbed --> b / w Max, non-constricted
    if isnan(Qb(dq))
        hnc4 = ncDataQh(1,4)*Q(dq)+ncDataQh(2,4);
        hnc5 = ncDataQh(1,5)*Q(dq)+ncDataQh(2,5);
    else
        hnc4 = ncDataQh_Qb(1,4)*Q(dq)+ncDataQh_Qb(2,4);
        hnc5 = ncDataQh_Qb(1,5)*Q(dq)+ncDataQh_Qb(2,5);
    end
    [Hnc, hnc, wMaxNc, wc, alphac, tauNC(dq)] = fGetHnc(Q(dq), hnc4, hnc5);
    bRel(dq) = b(dq)/wMaxNc;
    
    % cross-section data of laterally constricted channel
    [h0, H0, mu(dq), tauxc] = fGetHmu(Q(dq), h(dq,4), b(dq));
    HH(dq) =  Hnc / H0;
    if not(isnan(Qb(dq)))
        eta(dq) = tauxc/tauNC(dq);
        taux(dq) = tauxc;
    end
    % evaluate relative bedload capacity
    QbMax = fGetQbmax(Q(dq));
    qbxMax = QbMax/(wc+hnc/tand(alphac))/sqrt(g*1.68)/Dmax^1.5/1000;
    qbx = Qb(dq)/(wc+hnc/tand(alphac))/sqrt(g*1.68)/Dmax^1.5/1000;
    qbxRel(dq) = qbx/qbxMax;
    Fr(dq) = Q(dq)/(h(dq,4)*(wc+ h(dq,4)/tand(alphac))*sqrt(h(dq,4)*g));
end
targetRange = 'L13:R118';

% write data
xlswrite(sourceName,[bRel,mu,qbxRel,Fr, HH, taux,eta,tauNC], 1, targetRange);
xlswrite(sourceName,tauNC, 1, 'T13:T118');

disp('Data processed.');
