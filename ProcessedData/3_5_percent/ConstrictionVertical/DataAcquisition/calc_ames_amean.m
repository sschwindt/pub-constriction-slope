% April 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script for the computation of the mean opening height amean
% requires fGeta
%--------------------------------------------------------------------------
clear all;
close all;

b = 0;  %[m] constriction width 0=off, else: 0.1 / 0.15 / 0.187 / 0.2
sourceName = '20160422_data_vertical.xlsx';
sourceRange = 'K13:K132';
targetRange = 'L13:L132';

% linear fit values from opening_geometry.xlsx: a_mean = p1*a_mes + p2
p1 = 0.99948717943335;
p2 = 0.00014358974724793;

% load data to analyse
ames = xlsread(sourceName, 1, sourceRange);

alpha =24.52;   %[deg] channel bank slope at constriction
wc = 0.09645;   %[m] channel base width at constriction
% computation
amean = nan(size(ames));
for i = 1:numel(ames)
    %amean(i) = fGeta(ames(i),b);
    %amean(i) = 0.25*(-wc*tand(alpha)+sqrt(wc^2*tand(alpha)^2+8*...
    %    (ames(i)*wc*tand(alpha)+ames(i)^2)));
    amean(i) = p1*ames(i) + p2;
end

% write data
xlswrite(sourceName,amean, 1, targetRange);


disp('Data successfully processed.');
