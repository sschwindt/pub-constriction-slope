% September 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20161031_2-4-6_data_Fr0.xlsx';
alsoLateral = 0; % if 1: consideration of lateral data, too

% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')

% X-DATA
Fr0_a = xlsread(sourceName, 1, 'T255:V374'); % vertical
Fr0_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
Fr0_c = xlsread(sourceName, 1, 'T5:V124');   % combined
x_a = struc(Fr0_a);
x_b = struc(Fr0_b);
x_c = struc(Fr0_c);

% Y-DATA
mu_a = xlsread(sourceName, 1, 'AC255:AE374'); % vertical

mu_b = nan(size(mu_a));
if alsoLateral
    mu_b_temp = xlsread(sourceName, 1, 'AC130:AE249'); % lateral
    mu_b(1:numel(mu_b_temp(:,1)),:) = mu_b_temp;
end
mu_c = xlsread(sourceName, 1, 'AC5:AE124');   % combined
y_a = struc(mu_a);
y_b = struc(mu_b);
y_c = struc(mu_c);

cd ..
cd('DataRegression\Fr0')


% LAUNCH CFTOOL -----------------------------------------------------------
X = [x_a;x_c];
Y = [y_a;y_c];

for i = 1:numel(X)
    if or(X(i)< 0.6, X(i)> 1.0)
        disp('deleting.')
        X(i) = nan;
        Y(i) = nan;
    end
end

min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
