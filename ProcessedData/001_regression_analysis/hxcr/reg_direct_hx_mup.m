% September 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160913_2-4-6_data_hcr.xlsx';
alsoLateral = 0; % if 1: consideration of lateral data, too

% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')

% X-DATA
hx_a = xlsread(sourceName, 1, 'T255:V374'); % vertical
hx_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
hx_c = xlsread(sourceName, 1, 'T5:V124');   % combined
x_a = struc(hx_a);
x_b = struc(hx_b);
x_c = struc(hx_c);

% Y-DATA
mu_a = xlsread(sourceName, 1, 'AC255:AE374'); % vertical

mu_b = nan(size(mu_a));
if alsoLateral
    mu_b_temp = xlsread(sourceName, 1, 'AC130:AE249'); % lateral
    mu_b(1:numel(mu_b_temp(:,1)),:) = mu_b_temp;
end
mu_c = xlsread(sourceName, 1, 'AC5:AE124');   % combined
y_a = struc(mu_a);
y_b = struc(mu_b);
y_c = struc(mu_c);

cd ..
cd('DataRegression\hxcr')


% LAUNCH CFTOOL -----------------------------------------------------------
X = [x_a;x_c];
Y = [y_a;y_c];

for i = 1:numel(X)
    if X(i)>=1
        disp('deleting.')
        X(i) = nan;
        Y(i) = nan;
    end
end
cc=corrcoef(X,Y,'rows','pairwise');
min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
