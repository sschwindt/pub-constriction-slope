% June 2017, Sebastian Schwindt
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
bx = xlsread(sourceName, 1, 'N130:P249'); % lateral
x_a = [bx(:,1)./Jf(1), bx(:,2)./Jf(2), bx(:,3)./Jf(3)];
x_b = [bx(:,1)-(Jf(1)-0.02), bx(:,2)-(Jf(2)-0.02), bx(:,3)-(Jf(3)-0.02)];
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
alp_b = nan(size(x_b));
tempdata = xlsread(sourceName, 1, 'Z130:AB249'); % lateral
alp_b(1:numel(tempdata(:,1)),:) = tempdata;
y_246 = alp_b;
bestf = 0.25;
f1 = -8;
f2 = 0.8;
y_b = [(alp_b(:,1)-bestf*Jf(1))./(f1*Jf(1)+f2),...
        (alp_b(:,2)-bestf*Jf(2))./(f1*Jf(2)+f2),...
            (alp_b(:,3)-bestf*Jf(3))./(f1*Jf(3)+f2)];




for j = 1:3
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
ic_2 = xlsread(regSource, 1, 'L6:N6');
ic_4 = xlsread(regSource, 1, 'U6:W6');
ic_6 = xlsread(regSource, 1, 'AD6:AF6');
ic_b = xlsread(regSource, 1, 'C6:E6');


cd ..
cd('Plots\hxcr')

% PREPARE DATA ------------------------------------------------------------
xInterp_2 = 0.48:0.01:1.05;
xInterp_4 = 0.53:0.01:1.05;
xInterp_6 = 0.6:0.01:1.05;
xInterp_b = 0.47:0.01:1.05;

yInterp_2 = ic_2(1).*xInterp_2.^ic_2(2)+ic_2(3);
yInterp_4 = ic_4(1).*xInterp_4.^ic_4(2)+ic_4(3);
yInterp_6 = ic_6(1).*xInterp_6.^ic_6(2)+ic_6(3);
yInterp_b = ic_b(1).*xInterp_b.^ic_b(2)+ic_b(3);

fPlot_cKQbx(x_a, x_b, the_a, the_b, xInterp_2, ...
                xInterp_4, xInterp_6, xInterp_b, ...
                y_246,y_b, yInterp_2, yInterp_4, yInterp_6, yInterp_b,  1)
disp('Data processed.');
