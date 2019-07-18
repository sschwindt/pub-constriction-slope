% January 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 1303;       % Experiment No.
rowCount = 30;      % Number of useful experiments in file
startWriteRow = 4; % Row number where writing begins in targetName@xls


% DO NOT TOUCH ------------------------------------------------------------
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'_pure_Q.xls'];
sourceDataRange = ['M4:N',num2str(4+rowCount-1)];



% load data to analyse
pData = xlsread(sourceName, 1, sourceDataRange);
rowCount = numel(pData(:,1));
pumptargetRange = ['A4:A',num2str(4+rowCount-1)];
pumpsourceRange = 'B2:B35000'; % automatical fit
Qdata = xlsread(sourceName, 2, pumpsourceRange);
Q = nan(rowCount,1);

for i = 1:rowCount
    Q(i) = mean(Qdata(int64(pData(i,1)):int64(pData(i,2))));
end
xlswrite(sourceName,Q, 1, pumptargetRange);



disp('Data successfully processed.');
