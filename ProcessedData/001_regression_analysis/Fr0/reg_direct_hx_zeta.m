% September 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160913_2-4-6_data_hcr.xlsx';
subcrit = 1;% 1 = subcritical US flow / 2 = supercritical US flow / 3 = all

% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..
cd('Data')

% X-DATA
hx_a = xlsread(sourceName, 1, 'T255:V374'); % vertical
hx_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
hx_c = xlsread(sourceName, 1, 'T5:V124');   % combined
x_a = struc(hx_a);
x_b = struc(hx_b);
x_c = struc(hx_c);

% Y-DATA
zet_a = xlsread(sourceName, 1, 'W255:Y374'); % vertical
zet_b = xlsread(sourceName, 1, 'W130:Y249'); % lateral
zet_c = xlsread(sourceName, 1, 'W5:Y124');   % combined
y_a = struc(zet_a);
y_b = struc(zet_b);
y_c = struc(zet_c);

cd ..
cd('DataRegression')


% LAUNCH CFTOOL -----------------------------------------------------------
X = [x_a;x_b;x_c];
Y = [y_a;y_b;y_c];
switch subcrit
    case 1
        for i = 1:numel(X)
            if X(i)>=1
                X(i) = nan;
                Y(i) = nan;
            end
        end
    case 2
        for i = 1:numel(X)
            if X(i)<=1
                X(i) = nan;
                Y(i) = nan;
            end
        end
    case 3
        disp('Global analyses.')
end
min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
