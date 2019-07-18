% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies values from single Exp. filesto the summary file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = [3300,3301];    % Experiment No.
readLen = 200;          % Dummy value
targetName = '20160707_data_combined.xlsx';
% find existing number of rows in target:
Qb = xlsread(targetName, 1, ['E13:E',num2str(readLen)]);
rowAdd = numel(Qb);

for eN = 1:numel(ExpNo)

    sourceName = ['Exp_', num2str(ExpNo(eN),'%05i'),'.xls'];
    switch ExpNo(eN)
        case 3300
            rowsHyd = 2:2:86;
            rowCount = 86;      % Number of useful experiments in file
        case 3301
            rowsHyd = 2:2:10;
            rowCount = 10;      % Number of useful experiments in file
    end

    a = xlsread(sourceName, 1, ['U4:U',num2str(4+rowCount-1)]);
    b = xlsread(sourceName, 1, ['V4:V',num2str(4+rowCount-1)]);
    fileNo = xlsread(sourceName, 1, ['Q4:Q',num2str(4+rowCount-1)]);
    Q = xlsread(sourceName, 1, ['T4:T',num2str(4+rowCount-1)]);
    
    a_write = nan(numel(rowsHyd),1);
    b_write = nan(numel(rowsHyd),1);
    f_write = nan(numel(rowsHyd),1);
    Q_write = nan(numel(rowsHyd),1);
    
    
    startWriteRow = 13+rowAdd;% Row number where writing begins in targetName@xls

    for i = 1:numel(rowsHyd)
        a_write(i) = a(rowsHyd(i)-1);
        b_write(i) = b(rowsHyd(i)-1);
        f_write(i) = fileNo(rowsHyd(i)-1);
        Q_write(i) = Q(rowsHyd(i)-1).*10^-3;
    end    
    
    targetRange = ['B',num2str(startWriteRow),':D',...
                    num2str(startWriteRow+numel(rowsHyd))];
    targetRange_a = ['K',num2str(startWriteRow),':K',...
                    num2str(startWriteRow+numel(rowsHyd))];
    targetRange_b = ['M',num2str(startWriteRow),':M',...
                    num2str(startWriteRow+numel(rowsHyd))];
    % WRITE DATA ----------------------------------------------------------
    xlswrite(targetName,[ExpNo(eN)*ones(numel(rowsHyd),1),f_write,Q_write],...
                         1, targetRange);
    xlswrite(targetName, a_write, 1, targetRange_a);
    xlswrite(targetName, b_write, 1, targetRange_b);
    rowAdd = rowAdd+numel(rowsHyd);
end
disp('Data successfully transferred.');
