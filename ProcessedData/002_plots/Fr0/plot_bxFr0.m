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
Jf = [0.020433,0.034772,0.055021];
% X-DATA
bx = xlsread(sourceName, 1, 'N130:P249'); % lateral
x_a = [bx(:,1)./Jf(1), bx(:,2)./Jf(2), bx(:,3)./Jf(3)];
x_b = bx;


% control what is bedload->> store bedload data in the_c

the_b = nan(size(x_b));
tempdata = xlsread(sourceName, 1, 'AL130:AN249');
the_b(1:numel(tempdata(:,1)),:) = tempdata;
the_a = the_b;


for i = 1:numel(x_b(:,1))
    for j = 1:1:numel(x_b(1,:))
        if not(isnan(the_b(i,j)))
            the_a(i,j) = x_a(i,j);
            the_b(i,j) = x_b(i,j);
            x_a(i,j) = nan;
            x_b(i,j) = nan;
        end
    end
end

% Y-DATA
Fr0_b = xlsread(sourceName, 1, 'T130:V249'); % lateral

y_b = Fr0_b;

cd ..

% Regression coefficients
cd('DataRegression')
regSource = '20160810_summary_regression.xlsx';

ic_b = xlsread(regSource, 2, 'AD21:AF23');
ic_bIx = xlsread(regSource, 2, 'L22:N22');

cd ..
cd('Plots\Fr0')

% PREPARE DATA ------------------------------------------------------------
xInterp_b1 = min(x_a(:,1))+0.00:0.01:max(x_a(:,1))-0.25;
xInterp_b2 = min(x_a(:,2))+0.00:0.01:max(x_a(:,2))-0.3;
xInterp_b3 = min(x_a(:,3))+0.00:0.01:max(x_a(:,3));
xInterp_bIx = min(min(x_b))+0.003:0.001:max(max(x_b)+0.1);

yInterp_b1 = ic_b(1,1).*xInterp_b1.^ic_b(1,2)+ic_b(1,3);
yInterp_b2 = ic_b(2,1).*xInterp_b2.^ic_b(2,2)+ic_b(2,3);
yInterp_b3 = ic_b(3,1).*xInterp_b3.^ic_b(3,2)+ic_b(3,3);
yInterp_bIx = ic_bIx(1).*xInterp_bIx.^ic_bIx(2)+ic_bIx(3);

fPlot_bxhx(x_a, x_b, the_a, the_b, xInterp_bIx, xInterp_b1, xInterp_b2, ...
            xInterp_b3, yInterp_b1, yInterp_b2, yInterp_b3, y_b, yInterp_bIx, 1)
disp('Data processed.');
