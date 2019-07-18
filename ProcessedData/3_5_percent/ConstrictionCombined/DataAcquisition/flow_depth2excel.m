% April 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script gets mean flow depth of single measurements and transfers it to
% excel file
%--------------------------------------------------------------------------
clear all;
close all;

startRow = 13;
sourceRange = 'B13:E132';
sourceName = '20160425_data_combined.xlsx';
expData = xlsread(sourceName, 1, sourceRange);

% LOAD DATA ---------------------------------------------------------------
cd ..\..\..
result = nan(numel(expData(:,1)),5);
for iX = 1:numel(expData(:,1))
    cd(['Analysis_No_', num2str(expData(iX,1),'%05i'),'\FlowDepth'])

    fileNo = expData(iX,2);
    
    csvData=csvread(['FlowDepth_', num2str(fileNo,'%03i'),'.csv']);

    result(iX,:)=nanmean(csvData(2:15,2:6));

    cd ..\..

end

% WRITE DATA --------------------------------------------------------------
cd('4perCent\ConstrictionCombined\DataAcquisition')
targetRange = ['F',num2str(startRow),':J',...
                                num2str(startRow+numel(expData(:,1))-1)];
xlswrite(sourceName,result, 1, targetRange);


disp(['Data successfully processed.']);

