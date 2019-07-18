% March 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script gets mean flow depth of single measurements and transfers it to
% excel file
%--------------------------------------------------------------------------
clear all;
close all;

targetName = '20160322_Qb_h_nonconstricted.xlsx';
range = 'B13:C67';
targetRange = 'F13:J67';
xlsData = xlsread(targetName, 1, range);
expNo = unique(xlsData(:,1));

result = nan(numel(xlsData(:,1)),5);

% DATA TREATMENT ----------------------------------------------------------
cd ..\..\..


for f = 1:numel(expNo)
    cd(['Analysis_No_', num2str(expNo(f),'%05i'),'\FlowDepth'])
    D = dir([pwd, '\*.csv']);
    fileCount = length(D(not([D.isdir])));
    expPos = find(xlsData(:,1)==expNo(f));

    for p = 1:numel(expPos)
        fileNo = xlsData(expPos(p),2);
        csvData=load(['FlowDepth_', num2str(fileNo,'%03i'),'.csv']);
        result(expPos(p),:) = mean(csvData(:,2:6));
    end
    cd ..\..
end


% WRITE DATA --------------------------------------------------------------
cd('4perCent\NonConstricted\DataAcquisition')
xlswrite(targetName,result, 1, targetRange);

disp('Data successfully processed.');
