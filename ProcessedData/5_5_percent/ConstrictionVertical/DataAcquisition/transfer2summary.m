% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies values from single Exp. filesto the summary file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = [3100,3101];    % Experiment No.
readLen = 100;          % Dummy value
targetName = '20160706_data_vertical.xlsx';
rowAdd = 0;

for eN = 1:numel(ExpNo)

    sourceName = ['Exp_', num2str(ExpNo(eN),'%05i'),'.xls'];
    Q = xlsread(sourceName, 1, ['A4:A',num2str(readLen)]);
    Qs = xlsread(sourceName, 1, ['B4:B',num2str(readLen)]);
    a = xlsread(sourceName, 1, ['C4:C',num2str(readLen)]);
    fNo = xlsread(sourceName, 1, ['E4:E',num2str(readLen)]);
    
    startWriteRow = 13+rowAdd;% Row number where writing begins in targetName@xls
    rowAdd = numel(Q);
    
    
    targetRange = ['B',num2str(startWriteRow),':E',...
                    num2str(startWriteRow+rowAdd-1)];
    targetRange_a = ['K',num2str(startWriteRow),':K',...
                    num2str(startWriteRow+rowAdd-1)];
    % WRITE DATA ----------------------------------------------------------
    xlswrite(targetName,[ExpNo(eN)*ones(numel(Q),1),fNo,Q.*10^-3,Qs],...
                         1, targetRange);
    xlswrite(targetName, a, 1, targetRange_a);
end
disp('Data successfully processed.');
