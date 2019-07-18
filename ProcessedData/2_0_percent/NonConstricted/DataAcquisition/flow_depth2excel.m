% January 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script gets mean flow depth of single measurements and transfers it to
% excel file
%--------------------------------------------------------------------------
clear all;
close all;

ExpNo = 213;       % Experiment No.
switch ExpNo
    case 212
        fileCount = 54;    % Number of files in folder 
        startWriteRow = 33;% Row number where writing begins in targetName@xls
    case 213
        fileCount = 25;    % Number of files in folder 
        startWriteRow = 86;% Row number where writing begins in targetName@xls
end
targetName = '20160128_Qh_undisturbed.xlsx';
targetRange = ['F',num2str(startWriteRow),':J',...
                num2str(startWriteRow+fileCount-2)];

% LOAD DATA ---------------------------------------------------------------
cd ..\..\..\..
cd(['Analysis_No_', num2str(ExpNo,'%05i'),'\FlowDepth'])
result = nan(fileCount-1,5);

for i = 2:fileCount
    csvData=load(['FlowDepth_', num2str(i,'%03i'),'.csv']);
    result(i-1,:)=mean(csvData(:,2:6));
end

% WRITE DATA --------------------------------------------------------------
cd ..\..
cd('Topics\ChannelHydraulics\2perCent\DataAquisition')
xlswrite(targetName,result, 1, targetRange);

disp('Data successfully processed.');
