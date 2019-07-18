% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script for the computation of the mean opening height amean
% requires fGeta
%--------------------------------------------------------------------------
clear all;
close all;

b = 0;  %[m] constriction width 0=off, else: 0.1 / 0.15 / 0.187 / 0.2
sourceName = '20160707_data_combined.xlsx';
sourceRange = 'K13:K108';
targetRange = 'L13:L108';

% linear fit values from opening_geometry.xlsx: a_mean = p1*a_mes + p2
p1 = 1.05;
p2 = 0.005999999999991008;

% load data to analyse
ames = xlsread(sourceName, 1, sourceRange);

alpha =25.74;   %[deg] channel bank slope at constriction
wc = 0.1293;   %[m] channel base width at constriction
% computation
amean = nan(size(ames));
for i = 1:numel(ames)
    amean(i) = p1*ames(i) + p2;
end

% write data
xlswrite(sourceName,amean, 1, targetRange);


disp('Data successfully processed.');
