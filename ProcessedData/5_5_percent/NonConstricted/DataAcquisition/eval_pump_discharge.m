% June 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 3000;       % Experiment No.

rowCount = 50;     % Number of useful experiments in file
startWriteRow = 13;% Row number where writing begins in targetName@xls
sourceRange = ['C4:D',num2str(3+rowCount)];


targetName = '20160622_Qb_h_nonconstricted.xlsx';

% DO NOT TOUCH ------------------------------------------------------------
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];
pumptargetRange = ['F4:F',num2str(3+rowCount)];
pumpsourceRange = 'B2:B34000'; % automatical fit


targetRange = ['B',num2str(startWriteRow),':E',...
                num2str(startWriteRow+rowCount-1)];

% load data to analyse
Qdata = xlsread(sourceName, 2, pumpsourceRange);

% time(1) # FileNo(2) 
sourceData = xlsread(sourceName, 1, sourceRange);

dt = xlsread(sourceName, 1, ['H4:H',num2str(3+rowCount)]);
Qb = xlsread(sourceName, 1, ['G4:G',num2str(3+rowCount)]);

Q = nan(rowCount,1);

for i = 1:rowCount
    posIni = int64(sourceData(i,1));
    posEnd = int64(sourceData(i,1))+int64(dt(i));
    Q(i) = mean(Qdata(posIni:posEnd))*10^-3;
end


% WRITE DATA --------------------------------------------------------------
writeMatrix = [ones(rowCount,1)*ExpNo, sourceData(:,2), Q, Qb];
xlswrite(targetName,writeMatrix, 1, targetRange);
xlswrite(sourceName,Q*1000, 1, pumptargetRange);

disp('Data successfully processed.');
