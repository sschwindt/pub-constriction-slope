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
Jf = [0.020433,0.034772,0.055021];
% X-DATA
ax = xlsread(sourceName, 1, 'K5:M124'); % vertical
bx = xlsread(sourceName, 1, 'N5:P124'); % vertical
x_c = [ax(:,1).*bx(:,1)./Jf(1),...
            ax(:,2).*bx(:,2)./Jf(2),...
                ax(:,3).*bx(:,3)./Jf(3)];

% control what is bedload->> store bedload data in the_c
the_c = nan(size(x_c));
tempdata = xlsread(sourceName, 1, 'AL5:AN124');
the_c(1:numel(tempdata(:,1)),:) = tempdata;

for i = 1:numel(x_c(:,1))
    for j = 1:1:numel(x_c(1,:))
        if not(isnan(the_c(i,j)))
            the_c(i,j) = x_c(i,j);
            x_c(i,j) = nan;
        end
    end
end

% Y-DATA
hx_c = xlsread(sourceName, 1, 'T5:V124'); % vertical

y_c = hx_c;

cd ..

% Regression coefficients
cd('DataRegression')
regSource = '20160810_summary_regression.xlsx';
ic_c = xlsread(regSource, 1, 'U22:W22');

cd ..
cd('Plots\hxcr')

% PREPARE DATA ------------------------------------------------------------
xInterp_c = min(min(x_c))+0.0:0.001:max(max(x_c)-0.0);
yInterp_c = ic_c(1).*xInterp_c.^ic_c(2)+ic_c(3);

fPlot_cxhx(x_c, the_c, xInterp_c, y_c, yInterp_c, 1)
disp('Data processed.');
