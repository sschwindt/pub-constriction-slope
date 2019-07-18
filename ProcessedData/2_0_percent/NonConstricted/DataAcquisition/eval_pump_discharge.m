% January 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script computes mean pump discharges and copies values to the summary
% file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 213;       % Experiment No.
rowCount = 24;      % Number of useful experiments in file
rowCountFull = 24;  % Number of ALL experiments in file
startWriteRow = 86; % Row number where writing begins in targetName@xls
targetName = '20160128_Qh_undisturbed.xlsx';

% DO NOT TOUCH ------------------------------------------------------------
sourceName = ['Exp_', num2str(ExpNo,'%05i'),'.xls'];
sourceDataRange = ['F4:G',num2str(4+rowCountFull-1)];
pumptargetRange = ['A4:A',num2str(4+rowCountFull-1)];
pumpsourceRange = 'B2:B20000'; % automatical fit

%Q(1) # Qobs(2) # Qs(3) # dt(4) # time(5) # tStart(6) # tEnd(7) # FileNo(8)
sourceRange = ['A4:H',num2str(4+rowCount-1)];

targetRange = ['B',num2str(startWriteRow),':E',...
                num2str(startWriteRow+rowCount-1)];

% load data to analyse
Qdata = xlsread(sourceName, 2, pumpsourceRange);
pData = xlsread(sourceName, 1, sourceDataRange);

Q = nan(rowCountFull,1);

for i = 1:rowCountFull
    Q(i) = mean(Qdata(int64(pData(i,1)):int64(pData(i,2))));
end
xlswrite(sourceName,Q, 1, pumptargetRange);


% get manipulated data
data = xlsread(sourceName, 1, sourceRange);


% WRITE DATA --------------------------------------------------------------
unity = ones(numel(data(:,1)),1);

%      Exp. No    # FileNo  #Q              # Qs      
WRITE=[unity*ExpNo,data(:,8),data(:,1)*10^-3,data(:,3)];
xlswrite(targetName,WRITE, 1, targetRange);

disp('Data successfully processed.');
