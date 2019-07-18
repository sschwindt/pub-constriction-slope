% January 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script analyzes chezy coefficient of laboratory flume (sectionwise)
% requires fIE, fEvaldhk, fGetChezy
%--------------------------------------------------------------------------
clear all;
close all;

Qb = 0;                 %[0/1] bedload off=0 / on=1

% GET DATA (from Excel) ---------------------------------------------------
Q = (5.:0.1:10).*10^(-3);          %[m³/s] pump discharge
sourceName = '20160425_sectiondata.xlsx';
Nmin = -1000;    % lower interval boundary
Nmax = 1000;     % upper interval boundary

switch Qb
    case 0
        sourceRange = ['C5:F',num2str(4+numel(Q))];
        targetRange = ['M5:N',num2str(4+numel(Q))];
    case 1
        sourceRange = ['G5:J',num2str(4+numel(Q))];
        targetRange = ['O5:P',num2str(4+numel(Q))];
end


data = xlsread(sourceName, 2, sourceRange);


% COMPUTE ZETA OPT --------------------------------------------------------
Zqm = nan(Nmax-Nmin+1,numel(Q));
sigZ = nan(Nmax-Nmin+1,numel(Q));
Zopt = nan(numel(Q),1);
epsZ = nan(numel(Q),1);


for dq = 1:numel(Q)
    disp(['Q = ', num2str(Q(dq)*10^3), ' l/s.'])
    Zm = mean(data(dq,:));
    for i = Nmin:Nmax
        Zqm(i-Nmin+1,dq) = Zm + 0.001*i*Zm;
        sigZ(i-Nmin+1,dq) = sqrt(1/4*sum((data(dq,:)-Zqm(i-Nmin+1,dq)).^2));
    end
    % find optimum value
    optPos = find(sigZ(:,dq)==min(sigZ(:,dq)));
    Zopt(dq) = Zqm(optPos,dq);
    epsZ(dq) = min(sigZ(:,dq))/Zopt(dq);
end
% make plot of curve array (only without bedload data)
if not(Qb)
    cd('plotZetaOpt')
    fPlotZ(Zqm, sigZ, 14, Q)
    cd .. 
end
% write data

xlswrite(sourceName,[Zopt,epsZ], 2, targetRange);% Chezy C

disp(['Finished, data written to: ', sourceName,'.']);
