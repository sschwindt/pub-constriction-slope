% June 2017, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160913_2-4-6_data_hcr.xlsx';
alsoLateral = 1; % if 1: consideration of lateral data, too
Jf = [0.020433, 0.034772 , 0.055021];

% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')

% X-DATA

hx_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
bx_b = xlsread(sourceName, 1, 'N130:P249'); % lateral

x_b = bx_b;
mu_b = nan(size(hx_b));
if alsoLateral
    mu_b_temp = xlsread(sourceName, 1, 'AC130:AE249'); % lateral
    mu_b(1:numel(mu_b_temp(:,1)),:) = mu_b_temp;
end

y_b = mu_b;

cd ..
cd('DataRegression\hxcr')


% LAUNCH CFTOOL -----------------------------------------------------------
% f = [0.020433, 0.034772 , 0.055021]; % corresponds to channel slope
% X = [x_b(:,1).*f(1);x_b(:,2).*f(2);x_b(:,3).*f(3)];
% X = [x_b(:,1);x_b(:,2);x_b(:,3)];
X = [x_b(:,1)./Jf(1), x_b(:,2)./Jf(2), x_b(:,3)./Jf(3)];
Y = [y_b(:,1);y_b(:,2);y_b(:,3)];

delCrit = 2.2;
for i = 1:numel(X)
    if X(i)<=delCrit
        disp('deleting.')
        X(i) = nan;
        Y(i) = nan;
    end
end

min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
