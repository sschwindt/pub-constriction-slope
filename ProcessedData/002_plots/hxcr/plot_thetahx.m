% Feb 2018, Sebastian Schwindt
% EPF Lausanne, LCH

% Script creates plot according to X-/Y-/Regression-Data Definitions
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160913_2-4-6_data_hcr.xlsx';

% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')

% X-DATA
hx_a = xlsread(sourceName, 1, 'T255:V374'); % vertical
hx_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
hx_c = xlsread(sourceName, 1, 'T5:V124');   % combined
x_a = hx_a;
x_b = hx_b;
x_c = hx_c;

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
ic_a = xlsread(regSource, 1, 'U14:V14');
cd ..
cd('Plots\hxcr')

% PREPARE DATA ------------------------------------------------------------
xInterp_a = 0.:0.001:2;
%yInterp_a = ic_a(1).*xInterp_a.^ic_a(2)+ic_a(3);
%yInterp_a = cdf('Normal',xInterp_a,ic_a(1),ic_a(2));

yInterp_a = nan(size(xInterp_a));
for i = 1:numel(xInterp_a)
    yInterp_a(i) =1/(1+exp(-ic_a(1)*xInterp_a(i))).^ic_a(2);
end
fPlot_thetahx(x_a,x_b,x_c, xInterp_a, ...
                y_a,y_b,y_c, yInterp_a, 1)
disp('Data processed.');
