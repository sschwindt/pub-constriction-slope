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
Fr0_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
bx_b = xlsread(sourceName, 1, 'N130:P249'); % lateral
x_b = bx_b;


% Y-DATA
zet_b = xlsread(sourceName, 1, 'W130:Y249'); % lateral
y_b = zet_b;

% control what is bedload->> store bedload data in the_c
the_b = nan(size(x_b));
tempdata = xlsread(sourceName, 1, 'AL130:AN249');
the_b(1:numel(tempdata(:,1)),:) = tempdata;


for j = 1:3
    for i = 1:1:numel(x_b(:,1))
        if Fr0_b(i,j)<= 1
            x_b(i,j) = nan;
        end
        if not(isnan(the_b(i,j)))
            the_b(i,j) = x_b(i,j);
            x_b(i,j) = nan;
        end
    end
end

cd ..

% Regression coefficients
cd('DataRegression')
regSource = '20160810_summary_regression.xlsx';
ic_a = xlsread(regSource, 2, 'U46:W46');
cd ..
cd('Plots\Fr0')

% PREPARE DATA ------------------------------------------------------------
xInterp_a = 0.05:0.01:0.5;
yInterp_a = ic_a(1).*xInterp_a.^ic_a(2)+ic_a(3);

fPlot_zetaFr0super(x_b, the_b, xInterp_a, y_b, yInterp_a, 1)
disp('Data processed.');
