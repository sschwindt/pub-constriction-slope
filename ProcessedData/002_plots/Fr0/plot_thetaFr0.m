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
Fr0_a = xlsread(sourceName, 1, 'T255:V374'); % vertical
Fr0_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
Fr0_c = xlsread(sourceName, 1, 'T5:V124');   % combined
x_a = Fr0_a;
x_b = Fr0_b;
x_c = Fr0_c;

% Y-DATA
the_a = nan(size(x_a));
tempdata = xlsread(sourceName, 1, 'AL255:AN374');
the_a(1:numel(tempdata(:,1)),:) = tempdata;
the_b = nan(size(x_b));
tempdata = xlsread(sourceName, 1, 'AL130:AN249');
the_b(1:numel(tempdata(:,1)),:) = tempdata;
the_c = nan(size(x_c));
tempdata = xlsread(sourceName, 1, 'AL5:AN124');
the_c(1:numel(tempdata(:,1)),:) = tempdata;

y_a = the_a;
y_b = the_b;
y_c = the_c;
cd ..

% Regression coefficients
cd('DataRegression')
regSource = '20160810_summary_regression.xlsx';
ic_a = xlsread(regSource, 2, 'U14:V14');
cd ..
cd('Plots\Fr0')

% PREPARE DATA ------------------------------------------------------------
xInterp_a = 0.:0.001:2;
%yInterp_a = ic_a(1).*xInterp_a.^ic_a(2)+ic_a(3);
%yInterp_a = cdf('Normal',xInterp_a,ic_a(1),ic_a(2));

yInterp_a = nan(size(xInterp_a));
for i = 1:numel(xInterp_a)
    yInterp_a(i) =1/(1+exp(-ic_a(1)*xInterp_a(i))).^ic_a(2);
end
fPlot_thetaFr0(x_a,x_b,x_c, xInterp_a, ...
                y_a,y_b,y_c, yInterp_a, 1)
disp('Data processed.');
