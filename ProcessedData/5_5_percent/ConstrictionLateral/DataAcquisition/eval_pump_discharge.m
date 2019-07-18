% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 3201;       % Experiment No.

startWriteRow = 4; % Row number where writing begins in targetName@xls

% define rows with measurements of Qs,max
switch ExpNo
    case 3200
        rowsQsMax = [6, 9, 13, 17, 19, 22, 26, 28, 31, 34, 38, 40, 45, ...
                     49, 51, 55, 58, 60, 64, 67, 69, 72, 76, 78, 81, 84,...
                     88, 90, 93, 98, 100, 104, 107, 110];
        rowCount = 109;      % Number of useful experiments in file
    case 3201
        rowsQsMax = [3, 6, 9, 13, 16, 19, 22, 25, 27, 30, 33, 36, 38, ...
                     40, 44, 47, 50, 53, 64, 68, 73, 78, 81, 85, 88];
        rowCount = 87;      % Number of useful experiments in file
end
    

% DO NOT TOUCH ------------------------------------------------------------
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];
pumptargetRange = ['A4:A',num2str(4+rowCount-1)];
pumpsourceRange = 'B2:B33000'; % automatical fit


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
    pos1 = int64(t_abs(rowsQsMax(i)-1));
    posX = int64(t_abs(rowsQsMax(i)-1)+dt(rowsQsMax(i)-1));
    Q_write(i) = mean(Qdata(pos1:posX));    
    
    a_write(i) = a(rowsQsMax(i)-1);
    b_write(i) = b(rowsQsMax(i)-1);
    f_write(i) = fileNo(rowsQsMax(i)-1);
    Qs_write(i) = Qs(rowsQsMax(i)-1);
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
