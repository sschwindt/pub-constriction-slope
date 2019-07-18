% September 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160913_2-4-6_data_hcr.xlsx';

% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..
cd('Data')

% X-DATA
hx_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
bx_b = xlsread(sourceName, 1, 'n130:p249'); % lateral

% Y-DATA
zet_b = xlsread(sourceName, 1, 'W130:Y249'); % lateral

cd ..
cd('DataRegression')


% LAUNCH CFTOOL -----------------------------------------------------------
X = bx_b;
Y = zet_b;

for i = 1:numel(X(:,1))
    for j = 1:numel(X(1,:))
        if hx_b(i,j)<=1
            X(i,j) = nan;
            Y(i,j) = nan;
        end
        if X(i,j)<0.061
            disp([num2str(i), ' ' ,num2str(j)])
            X(i,j) = nan;
            Y(i,j) = nan;
        end
    end
end
X = [X(:,1);X(:,2);X(:,3)];
Y = [Y(:,1);Y(:,2);Y(:,3)];

min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
