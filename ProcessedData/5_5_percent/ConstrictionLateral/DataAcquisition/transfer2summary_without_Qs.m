% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies values from single Exp. filesto the summary file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = [3200,3201];    % Experiment No.
readLen = 200;          % Dummy value
targetName = '20160707_data_lateral.xlsx';
% find existing number of rows in target:
Qb = xlsread(targetName, 1, ['E13:E',num2str(readLen)]);
rowAdd = numel(Qb);

for eN = 1:numel(ExpNo)

    sourceName = ['Exp_', num2str(ExpNo(eN),'%05i'),'.xls'];
    switch ExpNo(eN)
        case 3200
            rowsHyd = [2, 8, 11, 14, 18, 21, 24, 27, 30, 33, 36, 39, ...
                       43, 46, 50, 53, 56, 59, 62, 65, 68, 71, 74, 77, ...
                       80, 83, 86, 89, 92, 95, 99, 102, 105, 108];
            rowCount = 109;      % Number of useful experiments in file
        case 3201
            rowsHyd = [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35, 37, ...
                       39, 41, 45, 48, 51, 54, 58, 61, 66, 70, 74, 79, ...
                       82, 86];
            rowCount = 87;      % Number of useful experiments in file
    end

    % a = xlsread(sourceName, 1, ['U4:U',num2str(4+rowCount-1)]);
    b = xlsread(sourceName, 1, ['V4:V',num2str(4+rowCount-1)]);
    fileNo = xlsread(sourceName, 1, ['Q4:Q',num2str(4+rowCount-1)]);
    Q = xlsread(sourceName, 1, ['T4:T',num2str(4+rowCount-1)]);
    
    % a_write = nan(numel(rowsQsMax),1);
    b_write = nan(numel(rowsHyd),1);
    f_write = nan(numel(rowsHyd),1);
    Q_write = nan(numel(rowsHyd),1);
    
    
    startWriteRow = 13+rowAdd;% Row number where writing begins in targetName@xls

    for i = 1:numel(rowsHyd)
        % a_write(i) = a(rowsHyd(i)-3);
        b_write(i) = b(rowsHyd(i)-1);
        f_write(i) = fileNo(rowsHyd(i)-1);
        Q_write(i) = Q(rowsHyd(i)-1).*10^-3;
    end    
    
    targetRange = ['B',num2str(startWriteRow),':D',...
                    num2str(startWriteRow+numel(rowsHyd))];
    targetRange_b = ['K',num2str(startWriteRow),':K',...
                    num2str(startWriteRow+numel(rowsHyd))];
    % WRITE DATA ----------------------------------------------------------
    xlswrite(targetName,[ExpNo(eN)*ones(numel(rowsHyd),1),f_write,Q_write],...
                         1, targetRange);
    xlswrite(targetName, b_write, 1, targetRange_b);
    rowAdd = rowAdd+numel(rowsHyd);
end
disp('Data successfully transferred.');
