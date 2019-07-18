% January 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script gets mean flow depth of single measurements and transfers it to
% excel file
%--------------------------------------------------------------------------
clear all;
close all;

sourceRange = 'B13:C80';
sourceName = '20160402_data_vertical.xlsx';
tarDir = '2perCent\ConstrictionVertical\DataAcquisition';

% CALC (no manipulation required unless excel template changed)
%--------------------------------------------------------------------------
expData = xlsread(sourceName, 1, sourceRange);
expNo = unique(expData(:,1));
rowIni = 12; % accodring to sourcName content! (row of h-header)
for iX = 1:numel(expNo)
    pos1 = find(expData(:,1)==expNo(iX),1,'first');
    posX = find(expData(:,1)==expNo(iX),1,'last');
    fileNo = expData(pos1:posX,2);

    % LOAD DATA -----------------------------------------------------------
    cd ..\..\..
    cd(['Analysis_No_', num2str(expNo(iX),'%05i'),'\FlowDepth'])
    result = nan(numel(fileNo),5);

    for j = 1:numel(fileNo)
        csvData=csvread(['FlowDepth_', num2str(fileNo(j),'%03i'),'.csv']);
        if numel(csvData(:,1))<31
            result(j,:)=nanmean(csvData(1:end,2:6));
        else
            result(j,:)=nanmean(csvData(1:30,2:6));
        end
    end

    % WRITE DATA ----------------------------------------------------------
    cd ..\..
    cd(tarDir)
    targetRange = ['F',num2str(rowIni+pos1),':J',num2str(rowIni+posX)];
    xlswrite(sourceName,result, 1, targetRange);

    disp(['Data successfully processed for Exp.No. ',num2str(expNo(iX),...
            '%05i'),'.']);
end

