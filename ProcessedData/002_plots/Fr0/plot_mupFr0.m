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
I = [0.020433, 0.034772 , 0.055021];
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
    for i = 1:1:numel(x_b(:,1)) % lateral
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
ic_a = xlsread(regSource, 2, 'AD45:AF47');
ic_b = xlsread(regSource, 2, 'C37:E39');

cd ..
cd('Plots\Fr0')

% ADAPT LATERL ONLY (muf)
x_Muf = [x_b(:,1).*(20*I(1)-0.8);x_b(:,2).*(20*I(2)-0.8);x_b(:,3).*(20*I(3)-0.8)]; % lateral

% PREPARE DATA ------------------------------------------------------------
xInterp = 0.10:0.01:0.99;

lyInterp_a= ic_a(1,1).*xInterp.^ic_a(1,2)+ic_a(1,3);
yInterp_a = ic_a(2,1).*xInterp.^ic_a(2,2)+ic_a(2,3);
uyInterp_a= ic_a(3,1).*xInterp.^ic_a(3,2)+ic_a(3,3);

lyInterp_b= ic_b(1,1).*xInterp.^ic_b(1,2)+ic_b(1,3);
yInterp_b = ic_b(2,1).*xInterp.^ic_b(2,2)+ic_b(2,3);
uyInterp_b= ic_b(3,1).*xInterp.^ic_b(3,2)+ic_b(3,3);
for i = 1:numel(xInterp)
    if xInterp(i) > 0.50
        lyInterp_b(i)= nan;
        yInterp_b(i) = nan;
        uyInterp_b(i)=nan;
        if xInterp(i)>0.55
            lyInterp_b(i)= 0.6935 - 0.0564;
            yInterp_b(i) = 0.6935;
            uyInterp_b(i)= 0.6935 + 0.0564;
        end
    end
end

fPlot_mupFr0(x_a, x_b, x_c, the_a, the_b, the_c, ...
            y_b1, y_b2, y_b3, ...
            xInterp, lyInterp_a, yInterp_a, uyInterp_a, ...
            lyInterp_b, yInterp_b, uyInterp_b, 1)
disp('Data processed.');
