% Octobre 2016, Sebastian Schwindt
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
zet_a = xlsread(sourceName, 1, 'W255:Y374'); % vertical
zet_b = xlsread(sourceName, 1, 'W130:Y249'); % lateral
zet_c = xlsread(sourceName, 1, 'W5:Y124');   % combined
y_a = zet_a;
y_b = zet_b;
y_c = zet_c;

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
ic_a = xlsread(regSource, 1, 'C46:E46');
ic_b = xlsread(regSource, 1, 'L46:N46');
cd ..
cd('Plots\hxcr')

% PREPARE DATA ------------------------------------------------------------
xInterp_a = 0.24:0.001:1.;
yInterp_a = ic_a(1).*xInterp_a.^ic_a(2)+ic_a(3);
xInterp_b = 1.08:0.001:1.925;
yInterp_b = ic_b(1).*xInterp_b.^ic_b(2)+ic_b(3);

fPlot_zetahx(x_a,x_b,x_c,the_a, the_b, the_c, xInterp_a, xInterp_b, ...
                y_a,y_b,y_c, yInterp_a, yInterp_b, 1)
disp('Data processed.');
