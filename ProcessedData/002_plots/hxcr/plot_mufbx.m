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
Jf = [0.020433, 0.034772 , 0.055021];
% X-DATA
bx = xlsread(sourceName, 1, 'N130:P249'); % lateral
x_a = [bx(:,1)./Jf(1), bx(:,2)./Jf(2), bx(:,3)./Jf(3)];
x_b = [bx(:,1), bx(:,2), bx(:,3)];
%x_c = [bx(:,1)-(Jf(1)-0.02), bx(:,2)-(Jf(2)-0.02), bx(:,3)-(Jf(3)-0.02)];

% Y-DATA
mu_b = xlsread(sourceName, 1, 'AC130:AE249'); % lateral
y_b2 = nan(size(x_b));
y_b2(1:numel(mu_b(:,1)),:) = mu_b;

% control what is bedload->> store bedload data in the_c
the_a = nan(size(x_a));
tempdata = xlsread(sourceName, 1, 'AL130:AN249');
the_a(1:numel(tempdata(:,1)),:) = tempdata;
the_b = the_a;


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

end

cd ..

% Regression coefficients
cd('DataRegression')
regSource = '20160810_summary_regression.xlsx';
ic_a = xlsread(regSource, 1, 'U38:W38');

cd ..
cd('Plots\hxcr')

% PREPARE DATA ------------------------------------------------------------
xInterp_a = 2.5:0.1:4.5;
yInterp_a = ic_a(1).*xInterp_a.^ic_a(2)+ic_a(3);

fPlot_mufbx(x_a, the_a, xInterp_a, ...
                y_b2, yInterp_a, 1)
% fPlot_mufbxS0(x_a, x_b, the_a, the_b, xInterp_a, ...
%                 y_b2, yInterp_a, 1)
disp('Data processed.');
