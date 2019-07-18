% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script gets mean flow depth of single measurements and transfers it to
% excel file
%--------------------------------------------------------------------------
clear variables;
close all;

startRow = 13;
sourceRange = 'B13:E132';
sourceName = '20160707_data_lateral.xlsx';
expData = xlsread(sourceName, 1, sourceRange);

% LOAD DATA ---------------------------------------------------------------
cd ..\..\..
result = nan(numel(expData(:,1)),5);
for iX = 1:numel(expData(:,1))
    cd(['Analysis_No_', num2str(expData(iX,1),'%05i'),'\FlowDepth'])

    fileNo = expData(iX,2);
    
% 
%     check = 0;
%     if and(not(isnan(expData(iX,4))),check)
%         csvData=csvread(['FlowDepth_', num2str(fileNo-1,'%03i'),'.csv']);
%     else
%         aa=1;
%     end
    csvData=csvread(['FlowDepth_', num2str(fileNo,'%03i'),'.csv']);
    result(iX,:)=nanmean(csvData(1:3,2:6));

    cd ..\..

end

% WRITE DATA --------------------------------------------------------------
cd('6perCent\ConstrictionLateral\DataAcquisition')
targetRange = ['F',num2str(startRow),':J',...
                                num2str(startRow+numel(expData(:,1))-1)];
xlswrite(sourceName,result, 1, targetRange);


disp(['Data successfully processed.']);

