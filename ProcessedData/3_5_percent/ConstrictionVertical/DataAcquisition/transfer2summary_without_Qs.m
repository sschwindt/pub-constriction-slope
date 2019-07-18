% April 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies values from single Exp. filesto the summary file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = [2100,2101];    % Experiment No.
readLen = 200;          % Dummy value
targetName = '20160422_data_vertical.xlsx';
% find existing number of rows in target:
Qb = xlsread(targetName, 1, ['E13:E',num2str(readLen)]);
rowAdd = numel(Qb);

for eN = 1:numel(ExpNo)

    sourceName = ['Exp_', num2str(ExpNo(eN),'%05i'),'.xls'];
    switch ExpNo(eN)
        case 2100
            rowsHyd = [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, ...
                      30, 32, 34, 36, 38, 41, 44, 46, 48, 50, 52, 54, ...
                      56, 58, 60, 62, 64];
            rowCount = 62;      % Number of useful experiments in file
        case 2101
            rowsHyd = [4, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, ...
                      34, 36, 38, 40, 42, 44, 46, 48, 51, 53, 55, 57, ...
                      59, 61, 63, 65, 67, 69];
            rowCount = 67;      % Number of useful experiments in file
    end

    a = xlsread(sourceName, 1, ['U4:U',num2str(4+rowCount-1)]);
    % b = xlsread(sourceName, 1, ['V4:V',num2str(4+rowCount-1)]);
    fileNo = xlsread(sourceName, 1, ['Q4:Q',num2str(4+rowCount-1)]);
    Q = xlsread(sourceName, 1, ['T4:T',num2str(4+rowCount-1)]);
    
    a_write = nan(numel(rowsHyd),1);
    % b_write = nan(numel(rowsHyd),1);
    f_write = nan(numel(rowsHyd),1);
    Q_write = nan(numel(rowsHyd),1);
    
    
    startWriteRow = 13+rowAdd;% Row number where writing begins in targetName@xls

    for i = 1:numel(rowsHyd)
        a_write(i) = a(rowsHyd(i)-3);
        % b_write(i) = b(rowsHyd(i)-3);
        f_write(i) = fileNo(rowsHyd(i)-3);
        Q_write(i) = Q(rowsHyd(i)-3).*10^-3;
    end    
    
    targetRange = ['B',num2str(startWriteRow),':D',...
                    num2str(startWriteRow+numel(rowsHyd))];
    targetRange_a = ['K',num2str(startWriteRow),':K',...
                    num2str(startWriteRow+numel(rowsHyd))];
    % WRITE DATA ----------------------------------------------------------
    xlswrite(targetName,[ExpNo(eN)*ones(numel(rowsHyd),1),f_write,Q_write],...
                         1, targetRange);
    xlswrite(targetName, a_write, 1, targetRange_a);
    rowAdd = rowAdd+numel(rowsHyd);
end
disp('Data successfully transferred.');
