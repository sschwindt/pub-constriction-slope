% April 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 2200;       % Experiment No.

startWriteRow = 4; % Row number where writing begins in targetName@xls

% define rows with measurements of Qs,max
switch ExpNo
    case 2200
        rowsQsMax = [6, 8, 11, 13, 16, 18, 21, 23, 26, 28, 30, 32, 35, 37, 39, ...
            41, 45, 47, 49, 51, 53, 55, 57, 59, 61, 63, 65, 67, 69, 71, ...
            73, 75, 77, 79, 81, 83, 85, 87, 89, 91];
        rowCount = 88;      % Number of useful experiments in file
    case 2201
        rowsQsMax = [5, 8, 11, 13, 15, 17, 19, 21, 23, 26, 28, 30, 32, ...
                    34, 36, 38, 40, 42];
        rowCount = 39;      % Number of useful experiments in file
end
    

% DO NOT TOUCH ------------------------------------------------------------
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];
pumptargetRange = ['A4:A',num2str(4+rowCount-1)];
pumpsourceRange = 'B2:B30000'; % automatical fit


% load data to analyse
Qdata = xlsread(sourceName, 2, pumpsourceRange);
a = xlsread(sourceName, 1, ['U4:U',num2str(4+rowCount-1)]);
b = xlsread(sourceName, 1, ['V4:V',num2str(4+rowCount-1)]);
dt = xlsread(sourceName, 1, ['R4:R',num2str(4+rowCount-1)]);
fileNo = xlsread(sourceName, 1, ['Q4:Q',num2str(4+rowCount-1)]);
Qs = xlsread(sourceName, 1, ['O4:O',num2str(4+rowCount-1)]);
t_abs = xlsread(sourceName, 1, ['N4:N',num2str(4+rowCount-1)]);

if isempty(a)
    a = nan(size(fileNo));
end
if isempty(b)
    b = nan(size(fileNo));
end

a_write = nan(numel(rowsQsMax),1);
b_write = nan(numel(rowsQsMax),1);
f_write = nan(numel(rowsQsMax),1);
Q_write = nan(numel(rowsQsMax),1);
Qs_write = nan(numel(rowsQsMax),1);

for i = 1:numel(rowsQsMax)
    pos1 = int64(t_abs(rowsQsMax(i)-3));
    posX = int64(t_abs(rowsQsMax(i)-3)+dt(rowsQsMax(i)-3));
    Q_write(i) = mean(Qdata(pos1:posX));    
    
    a_write(i) = a(rowsQsMax(i)-3);
    b_write(i) = b(rowsQsMax(i)-3);
    f_write(i) = fileNo(rowsQsMax(i)-3);
    Qs_write(i) = Qs(rowsQsMax(i)-3);
end

Q_write_all = nan(rowCount,1);
for i = 1:rowCount
    pos1 = int64(t_abs(i));
    posX = int64(t_abs(i)+dt(i));
    Q_write_all(i) = mean(Qdata(pos1:posX));   
end

targetRange = ['A4:E',num2str(4+numel(rowsQsMax)-1)];
xlswrite(sourceName,[Q_write,Qs_write,a_write,b_write,f_write],...
            1, targetRange);
xlswrite(sourceName,Q_write_all,1, ['T4:T',num2str(4+rowCount-1)]);

disp('Data successfully processed.');
