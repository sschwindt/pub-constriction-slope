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
Jf = [0.020433,0.034772,0.055021];
% X-DATA
hx_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
bx_b = xlsread(sourceName, 1, 'N130:P249'); % lateral
x_a = [bx_b(:,1)./Jf(1), bx_b(:,2)./Jf(2), bx_b(:,3)./Jf(3)];
x_b = bx_b;


% Y-DATA
zet_b = xlsread(sourceName, 1, 'W130:Y249'); % lateral
y_b = zet_b;

% control what is bedload->> store bedload data in the_c

the_b = nan(size(x_b));
tempdata = xlsread(sourceName, 1, 'AL130:AN249');
the_b(1:numel(tempdata(:,1)),:) = tempdata;
the_a = the_b;


for i = 1:numel(x_b(:,1))
    for j = 1:1:numel(x_b(1,:))
        if hx_b(i,j)<= 1
            x_a(i,j) = nan;
            x_b(i,j) = nan;
        end
        if not(isnan(the_b(i,j)))
            the_a(i,j) = x_a(i,j);
            the_b(i,j) = x_b(i,j);
            x_a(i,j) = nan;
            x_b(i,j) = nan;
        end
    end
end

cd ..

% Regression coefficients
cd('DataRegression')
regSource = '20160810_summary_regression.xlsx';
ic_a = xlsread(regSource, 1, 'U46:W46');
cd ..
cd('Plots\hxcr')

% PREPARE DATA ------------------------------------------------------------
xInterp_bIx = 0.0:0.01:0.25;
yInterp_bIx = ic_a(1).*xInterp_bIx.^ic_a(2)+ic_a(3);

xInterp_b1 = nan;
xInterp_b2 = nan;
xInterp_b3 = nan;
yInterp_b1 = nan;
yInterp_b2 = nan;
yInterp_b3 = nan;

%fPlot_zetahxSuper(x_b, the_b, xInterp_a, y_b, yInterp_a, 1)
fPlot_zetahxSuper(x_a, x_b, the_a, the_b, xInterp_bIx, xInterp_b1, xInterp_b2, ...
            xInterp_b3, yInterp_b1, yInterp_b2, yInterp_b3, y_b, yInterp_bIx, 1)
disp('Data processed.');
