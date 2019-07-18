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
x_a = xlsread(sourceName, 1, 'T255:V374'); % vertical
x_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
x_c = xlsread(sourceName, 1, 'T5:V124');   % combined

% Y-DATA
mu_a = xlsread(sourceName, 1, 'AC255:AE374'); % vertical
mu_b = xlsread(sourceName, 1, 'AC130:AE249'); % lateral
mu_c = xlsread(sourceName, 1, 'AC5:AE124');   % combined
y_b1 = mu_a;
y_b2 = nan(size(x_b));
y_b2(1:numel(mu_b(:,1)),:) = mu_b;
y_b3 = mu_c;

% control what is bedload->> store bedload data in the_c
the_a = nan(size(x_a));
tempdata = xlsread(sourceName, 1, 'AL255:AN374');
the_a(1:numel(tempdata(:,1)),:) = tempdata;
the_b = nan(size(x_b));
tempdata = xlsread(sourceName, 1, 'AL130:AN249');
the_b(1:numel(tempdata(:,1)),:) = tempdata;
the_c = nan(size(x_c));
tempdata = xlsread(sourceName, 1, 'AL5:AN124');
the_c(1:numel(tempdata(:,1)),:) = tempdata;

for j = 1:3
    for i = 1:1:numel(x_a(:,1))
        if not(isnan(the_a(i,j)))
            the_a(i,j) = x_a(i,j);
            x_a(i,j) = nan;
        end
    end
    for i = 1:1:numel(x_b(:,1))
        if not(isnan(the_b(i,j)))
            the_b(i,j) = x_b(i,j);
            x_b(i,j) = nan;
        end
    end
    for i = 1:1:numel(x_c(:,1))
        if not(isnan(the_c(i,j)))
            the_c(i,j) = x_c(i,j);
            x_c(i,j) = nan;
        end
    end
end

cd ..

% Regression coefficients
cd('DataRegression')
regSource = '20160810_summary_regression.xlsx';
ic_a = xlsread(regSource, 1, 'C38:E38');

cd ..
cd('Plots\hxcr')

% PREPARE DATA ------------------------------------------------------------
xInterp_a = 0.3:0.001:1.05;

yInterp_a = ic_a(1).*xInterp_a.^ic_a(2)+ic_a(3);


fPlot_muphx(x_a,x_c,the_a, the_c, xInterp_a, ...
                y_b1,y_b3, yInterp_a, 1)
disp('Data processed.');
