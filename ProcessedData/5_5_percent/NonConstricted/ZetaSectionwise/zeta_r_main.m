% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script analyzes chezy coefficient of laboratory flume (sectionwise)
% requires fIE, fEvaldhk, fGetChezy
%--------------------------------------------------------------------------
clear all;
close all;

Qb = 1;                 %[0/1] bedload off=0 / on=1

% GET DATA (from Excel) ---------------------------------------------------
Q = (5.:0.1:10).*10^(-3);          %[m³/s] pump discharge
sourceName = '20160706_sectiondata.xlsx';
sourceRange = 'D4:H9';% contains geometry data of each cross-section
switch Qb
    case 0
        hRange = 'L4:P6';       % contains p1 amnd p2 values for linear interpolation
        cRange = 'D5:G55';     % contains fitting values from chezy scrpit
        targetRange = ['C5:F',num2str(4+numel(Q))];
        % write discharges to file (only without Qb)
        xlswrite(sourceName,Q',2, ['B5:B',num2str(4+numel(Q))]);
    case 1
        hRange = 'L7:P9';       % contains p1 amnd p2 values for linear interpolation
        cRange = 'H5:K55';     % contains fitting values from chezy scrpit
        targetRange = ['G5:J',num2str(4+numel(Q))];
end

Data = xlsread(sourceName, 1, sourceRange);
hData = xlsread(sourceName, 1, hRange);



% COMPUTE -----------------------------------------------------------------
zeta = nan(numel(Q),4);             %[-] roughness losses


for dq = 1:numel(Q)
    disp(['Q = ', num2str(Q(dq)*10^3), ' l/s.'])
    for i = 1:4 % four sections
        hi = hData(1,i)*Q(dq)+hData(2,i);
        hj = hData(1,i+1)*Q(dq)+hData(2,i+1);
        if not(Qb)
            cd ..
            cd('ChezySectionwise/cData')
            data = load(['c_Q',num2str(Q(dq),'%0.4f'),'sec',num2str(i),num2str(i+1),'.csv']);
            c = data(:,1);
            Jf = data(:,2);
            cd ..\..
            cd('ZetaSectionwise')
        else
            cd ..
            cd('ChezySectionwise/cDataQb')
            data = load(['c_Q',num2str(Q(dq),'%0.4f'),'sec',num2str(i),num2str(i+1),'.csv']);
            c = data(:,1);
            Jf = data(:,2);
            cd ..\..
            cd('ZetaSectionwise')
        end
        [zeta(dq,i)] = fGetZeta(Data, hi, hj, c, Jf, i);
    end
end

% WRITE DATA --------------------------------------------------------------

xlswrite(sourceName,zeta,2, targetRange);

disp(['Finished, check accuracy report (written to: ', sourceName,').']);
