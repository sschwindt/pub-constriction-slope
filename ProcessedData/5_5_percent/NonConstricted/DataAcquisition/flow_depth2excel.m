% June 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script gets mean flow depth of single measurements and transfers it to
% excel file
%--------------------------------------------------------------------------
clear all;
close all;

targetName = '20160622_Qb_h_nonconstricted.xlsx';
range = 'B13:C62';
targetRange = 'F13:J62';
xlsData = xlsread(targetName, 1, range);
expNo = unique(xlsData(:,1));

temp_Qb = xlsread(targetName, 1, 'E13:E62');
Qb = nan(size(xlsData(:,1)));
Qb(1:numel(temp_Qb))=temp_Qb;
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
        csvData=csvread(['FlowDepth_', num2str(fileNo,'%03i'),'.csv']);
        if isnan(Qb(expPos(p)))
            result(expPos(p),:) = mean(csvData(:,2:6));
        else
            % not active!
            result(expPos(p),:) = mean(csvData(:,2:6));
        end
    end
    cd ..\..
end


% WRITE DATA --------------------------------------------------------------
cd('6perCent\NonConstricted\DataAcquisition')
xlswrite(targetName,result, 1, targetRange);

disp('Data successfully processed.');
