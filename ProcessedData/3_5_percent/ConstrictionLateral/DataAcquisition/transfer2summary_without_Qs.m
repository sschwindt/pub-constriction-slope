% April 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies values from single Exp. filesto the summary file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = [2200,2201];    % Experiment No.
readLen = 200;          % Dummy value
targetName = '20160421_data_lateral.xlsx';
% find existing number of rows in target:
Qb = xlsread(targetName, 1, ['E13:E',num2str(readLen)]);
rowAdd = numel(Qb);

for eN = 1:numel(ExpNo)

    sourceName = ['Exp_', num2str(ExpNo(eN),'%05i'),'.xls'];
    switch ExpNo(eN)
        case 2200
            rowsHyd = [4, 7, 10, 12, 15, 17, 19, 22, 25, 27, 29, 31, ...
                      33, 36, 38, 40, 43, 46, 48, 50, 52, 54, 56, 58, ...
                      60, 62, 64, 66, 68, 70, 72, 74, 76, 78, 80, 82, ...
                      84, 86, 88, 90];
            rowCount = 88;      % Number of useful experiments in file
        case 2201
            rowsHyd = [4, 6, 9, 12, 14, 16, 18, 20, 22, 24, 27, 29, 31, ...
                      33, 35, 37, 39, 41];
            rowCount = 39;      % Number of useful experiments in file
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
        b_write(i) = b(rowsHyd(i)-3);
        f_write(i) = fileNo(rowsHyd(i)-3);
        Q_write(i) = Q(rowsHyd(i)-3).*10^-3;
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
