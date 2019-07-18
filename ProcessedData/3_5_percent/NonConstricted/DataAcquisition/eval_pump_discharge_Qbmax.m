% March 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 2001;       % Experiment No.
rowCount = 13;      % Number of useful experiments in file
rowCountFull = 13;  % Number of ALL experiments in file
startWriteRow = 28; % Row number where writing begins in targetName@xls
targetName = '20160322_Qb_h_nonconstricted.xlsx';

% DO NOT TOUCH ------------------------------------------------------------
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];

pumptargetRange = ['F4:F',num2str(4+rowCountFull-1)];
pumpsourceRange = 'B2:B20000'; % automatical fit

% time(1) # FileNo(2) # Qobs(3) # Qexct(4) # Qs(5) # dt(6) 
sourceRange = ['C4:H',num2str(4+rowCount-1)];
targetRange = ['B',num2str(startWriteRow),':E',...
                num2str(startWriteRow+rowCount-1)];

% load data to analyse
Qdata = xlsread(sourceName, 2, pumpsourceRange);
pData = xlsread(sourceName, 1, sourceRange);

Q = nan(rowCountFull,1);

for i = 1:rowCountFull
    posIni = int64(pData(i,1));
    posEnd = int64(pData(i,1))+int64(pData(i,6));
    Q(i) = mean(Qdata(posIni:posEnd));
end
xlswrite(sourceName,Q, 1, pumptargetRange);


% complete data set
data = xlsread(sourceName, 1, sourceRange);


% WRITE DATA --------------------------------------------------------------
unity = ones(numel(data(:,1)),1);

%      Exp. No    # FileNo  #Q              # Qs      
WRITE=[unity*ExpNo,data(:,2),data(:,4)*10^-3,data(:,5)];
xlswrite(targetName,WRITE, 1, targetRange);

disp('Data successfully processed.');
