% February 2017, Sebastian Schwindt
% EPF Lausanne, LCH
%% THIS DOES NOT WORK VERY GOOD ...
% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20161031_2-4-6_data_Fr0.xlsx';
alsoLateral = 1; % if 1: consideration of lateral data, too

% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')

% X-DATA

Fr0_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
bx_b = xlsread(sourceName, 1, 'N130:P249'); % lateral

x_b = Fr0_b;
mu_b = nan(size(Fr0_b));
if alsoLateral
    mu_b_temp = xlsread(sourceName, 1, 'AC130:AE249'); % lateral
    mu_b(1:numel(mu_b_temp(:,1)),:) = mu_b_temp;
end

y_b = mu_b;

cd ..
cd('DataRegression\Fr0')


% LAUNCH CFTOOL -----------------------------------------------------------
f = [0.020433, 0.034772 , 0.055021]; % corresponds to channel slope
%X = [x_b(:,1).*f(1);x_b(:,2).*f(2);x_b(:,3).*f(3)]; % for bx
%uncomment the following line to apply a slope correction
%X = [x_b(:,1).*(0.04-f(1));x_b(:,2).*(0.04-f(2));x_b(:,3).*(0.04-f(3))]; % for Fr0
X = [x_b(:,1);x_b(:,2);x_b(:,3)]; % for Fr0
Y = [y_b(:,1);y_b(:,2);y_b(:,3)];

for i = 1:numel(X)
    if X(i)>=1
        disp('deleting.')
        X(i) = nan;
        Y(i) = nan;
    end
end

min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
