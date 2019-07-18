% April 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script analyzes chezy coefficient of laboratory flume (sectionwise)
% requires fIE, fEvaldhk, fGetChezy
%--------------------------------------------------------------------------
clear all;
close all;

Qb = 0;                 %[0/1] bedload off=0 / on=1

% GET DATA (from Excel) ---------------------------------------------------
Q = (5.:0.1:10).*10^(-3);          %[m³/s] pump discharge
sourceName = '20160421_chezy_sectionwise.xlsx';
sourceRange = 'D4:H9';% contains geometry data of each cross-section
switch Qb
    case 0
        hRange = 'L4:P6';       % contains p1 amnd p2 values for linear interpolation
        targetRangeC = ['D16:G',num2str(15+numel(Q))];
        targetRangeK = ['C6:F',num2str(5+numel(Q))];
    case 1
        hRange = 'L7:P9';       % contains p1 amnd p2 values for linear interpolation
        targetRangeC = ['H16:K',num2str(15+numel(Q))];
        targetRangeK = ['G6:J',num2str(5+numel(Q))];
end


Data = xlsread(sourceName, 1, sourceRange);
hData = xlsread(sourceName, 1, hRange);

% COMPUTE -----------------------------------------------------------------
Chezy = nan(numel(Q),4);            %[m¹'²/s] sectionwise chezy coefficient
Kst = nan(numel(Q),4);              %[m¹'³/s] sectionwise kst coefficient
% make grid and smooth slope
diff = 0.01;                        %[m²/s] diffusion coefficient (stability)
jf_num = fMakeGrid(Data(1,:),Data(2,:),diff);

for dq = 1:numel(Q)
    disp(' ')
    disp(['Simulation of Q = ', num2str(Q(dq)*10^3), ' l/s.'])
    for i = 1:4
        hi = hData(1,i)*Q(dq)+hData(2,i);
        hj = hData(1,i+1)*Q(dq)+hData(2,i+1);
        startPos = find(jf_num(:,1)==i,1,'first');
        endPos = find(jf_num(:,1)==i,1,'last');
        Jf = jf_num(startPos:endPos,2);
        [Chezy(dq,i), Kst(dq,i)] = fGetChezy(Data, hi, hj, Q(dq), Jf,...
                                        i, sourceName, dq, Qb, diff);
    end
end

% WRITE DATA --------------------------------------------------------------
if not(Qb)
    xlswrite(sourceName,Q', 1, ['C16:C',num2str(15+numel(Q))]);%for chezy
    xlswrite(sourceName,Q', 2, ['B6:B',num2str(5+numel(Q))]);%for kst
    xlswrite(sourceName,Q', 3, ['B5:B',num2str(4+numel(Q))]);%for accuracy rep. epsC
    xlswrite(sourceName,Q', 3, ['I5:I',num2str(4+numel(Q))]);%for accuracy rep. epsh
end
xlswrite(sourceName,Chezy,1, targetRangeC);
xlswrite(sourceName,Kst,2, targetRangeK);
disp(['Finished, check accuracy report (written to: ', sourceName,').']);
