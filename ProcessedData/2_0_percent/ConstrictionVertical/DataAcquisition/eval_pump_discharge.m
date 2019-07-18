% January 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 412;       % Experiment No.
rowCount = 7;      % Number of useful experiments in file
startWriteRow = 4; % Row number where writing begins in targetName@xls


% DO NOT TOUCH ------------------------------------------------------------
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];
sourceDataRange = ['G4:H',num2str(4+rowCount-1)];
pumptargetRange = ['A4:A',num2str(4+rowCount-1)];
pumpsourceRange = 'B2:B37000'; % automatical fit


% load data to analyse
Qdata = xlsread(sourceName, 2, pumpsourceRange);
pData = xlsread(sourceName, 1, sourceDataRange);

Q = nan(rowCount,1);

for i = 1:rowCount
    Q(i) = 10^-3*mean(Qdata(int64(pData(i,1)):int64(pData(i,2))));
end
xlswrite(sourceName,Q, 1, pumptargetRange);



disp('Data successfully processed.');
