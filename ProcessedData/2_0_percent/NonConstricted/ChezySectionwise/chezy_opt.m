% January 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script analyzes chezy coefficient of laboratory flume (sectionwise)
% requires fIE, fEvaldhk, fGetChezy
%--------------------------------------------------------------------------
clear all;
close all;

Qb = 1;                 %[0/1] bedload off=0 / on=1

% GET DATA (from Excel) ---------------------------------------------------
Q = (5.:0.1:10).*10^(-3);          %[m³/s] pump discharge
sourceName = '20160126_chezy_sectionwise.xlsx';
Nmin = -1000;    % lower interval boundary
Nmax = 1000;     % upper interval boundary

switch Qb
    case 0
        sourceRangeC = ['D16:G',num2str(15+numel(Q))];
        sourceRangeK = ['C6:F',num2str(5+numel(Q))];
        targetRangeC = ['C8:C',num2str(7+numel(Q))];
        targetRangeEPS = ['E8:E',num2str(7+numel(Q))];
        targetRangeK = ['G8:G',num2str(7+numel(Q))];
    case 1
        sourceRangeC = ['H16:K',num2str(15+numel(Q))];
        sourceRangeK = ['G6:J',num2str(5+numel(Q))];
        targetRangeC = ['D8:D',num2str(7+numel(Q))];
        targetRangeK = ['H8:H',num2str(7+numel(Q))];
end


DataC = xlsread(sourceName, 1, sourceRangeC);
DataK = xlsread(sourceName, 2, sourceRangeK);

% COMPUTE CHEZY -----------------------------------------------------------
cqm = nan(Nmax-Nmin+1,numel(Q));
sigC = nan(Nmax-Nmin+1,numel(Q));
copt = nan(numel(Q),1);
epsC = nan(numel(Q),1);

kqm = nan(Nmax-Nmin+1,numel(Q));
sigK = nan(Nmax-Nmin+1,numel(Q));
kopt = nan(numel(Q),1);

for dq = 1:numel(Q)
    disp(['Simulation of Q = ', num2str(Q(dq)*10^3), ' l/s.'])
    cm = mean(DataC(dq,:));
    km = mean(DataK(dq,:));
    for i = Nmin:Nmax
        cqm(i-Nmin+1,dq) = cm + 0.001*i*cm;
        sigC(i-Nmin+1,dq) = sqrt(1/4*sum((DataC(dq,:)-cqm(i-Nmin+1,dq)).^2));
        
        kqm(i-Nmin+1,dq) = km + 0.001*i*km;
        sigK(i-Nmin+1,dq) = sqrt(1/4*sum((DataK(dq,:)-kqm(i-Nmin+1,dq)).^2));
    end
    % find optimum value
    optPos = find(sigC(:,dq)==min(sigC(:,dq)));
    copt(dq) = cqm(optPos,dq);
    epsC(dq) = min(sigC(:,dq))/copt(dq);
    optPos = find(sigK(:,dq)==min(sigK(:,dq)));
    kopt(dq) = kqm(optPos,dq);
end
% make plot of curve array (only without bedload data)
if not(Qb)
    cd('plotChezy')
    fPlotC(cqm, sigC, 14, Q)
    cd .. 
    cd('plotKst')
    fPlotK(kqm, sigK, 14, Q)
    cd .. 
end
% write data
xlswrite(sourceName,Q', 4, ['B8:B',num2str(7+numel(Q))]);% Q
xlswrite(sourceName,copt, 4, targetRangeC);% Chezy C
if not(Qb)
    xlswrite(sourceName,epsC, 4, targetRangeEPS);% Eps C
end
xlswrite(sourceName,kopt, 4, targetRangeK);% Strickler Kst

disp(['Finished, data written to: ', sourceName,'.']);
