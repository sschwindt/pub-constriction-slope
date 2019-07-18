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
Jf = [0.020433,0.034772,0.055021];
% X-DATA
ax_a = xlsread(sourceName, 1, 'K255:M374'); % vertical
bx_b = xlsread(sourceName, 1, 'N130:P249'); % lateral

% Y-DATA
hx_a = xlsread(sourceName, 1, 'T255:V374'); % vertical
hx_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
y_a = hx_a;
y_b = hx_b;


cd ..
cd('DataRegression')


% LAUNCH CFTOOL -----------------------------------------------------------
ji = 3; % slope no. 1= 2p, 2=3.5p, 3=5.5p
X = bx_b(:,ji)./Jf(ji);
Y = y_b(:,ji);
min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
