% January 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script for the computation of the mean opening height amean
% requires fGeta
%--------------------------------------------------------------------------
clear all;
close all;

sourceName = '20160402_data_combined.xlsx';
sourceRange = 'K13:K110';
targetRange = 'L13:L110';

% linear fit values from opening_geometry.xlsx: a_mean = p1*a_mes + p2
p1 = 0.997545298887677;
p2 = 0.000122735040984234;

% load data to analyse
ames = xlsread(sourceName, 1, sourceRange);

% computation
amean = nan(size(ames));
for i = 1:numel(ames)
    amean(i) = p1*ames(i) + p2;
end

% write data
xlswrite(sourceName,amean, 1, targetRange);


disp('Data successfully processed.');
