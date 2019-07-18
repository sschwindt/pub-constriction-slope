% February 2017, Sebastian Schwindt
% EPF Lausanne, LCH

% Script creates plot according to X-/Y-/Regression-Data Definitions
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20161031_2-4-6_data_Fr0.xlsx';
% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')

% X-DATA
ax_a = xlsread(sourceName, 1, 'K255:M374'); % vertical
x_a = ax_a;

% control what is bedload->> store bedload data in the_c
the_a = nan(size(ax_a));
tempdata = xlsread(sourceName, 1, 'AL255:AN374');
the_a(1:numel(tempdata(:,1)),:) = tempdata;

for i = 1:numel(x_a(:,1))
    for j = 1:1:numel(x_a(1,:))
        if not(isnan(the_a(i,j)))
            the_a(i,j) = x_a(i,j);
            x_a(i,j) = nan;
        end
    end
end

% Y-DATA
Fr0_a = xlsread(sourceName, 1, 'T255:V374'); % vertical

y_a = Fr0_a;

cd ..

% Regression coefficients
cd('DataRegression')
regSource = '20160810_summary_regression.xlsx';
ic_a = xlsread(regSource, 2, 'C22:E22');

cd ..
cd('Plots\Fr0')

% PREPARE DATA ------------------------------------------------------------
xInterp_a = min(min(x_a))+0.0:0.001:max(max(x_a));

yInterp_a = ic_a(1).*xInterp_a.^ic_a(2)+ic_a(3);

fPlot_axFr0(x_a, the_a, xInterp_a, y_a, yInterp_a, 1)
disp('Data processed.');
