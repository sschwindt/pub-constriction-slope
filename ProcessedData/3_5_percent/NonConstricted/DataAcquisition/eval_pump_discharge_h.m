% March 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 2001;       % Experiment No.
switch ExpNo
    case 2000
        rowCount = 15;     % Number of useful experiments in file
        rowCountFull = 15; % Number of ALL experiments in file
        startWriteRow = 40;% Row number where writing begins in targetName@xls
        sourceRange = ['B2:D',num2str(2+rowCount-1)];
    case 2001
        rowCount = 13;     % Number of useful experiments in file
        rowCountFull = 13; % Number of ALL experiments in file
        startWriteRow = 55;% Row number where writing begins in targetName@xls
        sourceRange = ['B19:D',num2str(19+rowCount-1)];
end

targetName = '20160322_Qb_h_nonconstricted.xlsx';

% DO NOT TOUCH ------------------------------------------------------------
pumpSourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];
pumptargetRange = ['F4:F',num2str(4+rowCountFull-1)];
pumpsourceRange = 'B2:B30000'; % automatical fit


targetRange = ['D',num2str(startWriteRow),':D',...
                num2str(startWriteRow+rowCount-1)];

% load data to analyse
Qdata = xlsread(pumpSourceName, 2, pumpsourceRange);

% time(1) # FileNo(2) # dt(3)
tData = xlsread(targetName, 2, sourceRange);

Q = nan(rowCountFull,1);

for i = 1:rowCountFull
    posIni = int64(tData(i,1));
    posEnd = int64(tData(i,1))+int64(tData(i,3));
    Q(i) = mean(Qdata(posIni:posEnd))*10^-3;
end


% WRITE DATA --------------------------------------------------------------
xlswrite(targetName,Q, 1, targetRange);

disp('Data successfully processed.');
