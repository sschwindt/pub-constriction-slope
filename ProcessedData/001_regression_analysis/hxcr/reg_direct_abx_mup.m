% June 2017, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160913_2-4-6_data_hcr.xlsx';
alsoLateral = 0; % if 1: consideration of lateral data, too
Jf = [0.020433, 0.034772 , 0.055021];
% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')

% X-DATA
axv = xlsread(sourceName, 1, 'K255:M374'); % vertical
bxc = xlsread(sourceName, 1, 'N5:P124'); % combined
bxc = [bxc(:,1)./Jf(1), bxc(:,2)./Jf(2), bxc(:,3)./Jf(3)];
axc = xlsread(sourceName, 1, 'K5:M124');   % combined

x_a = axv;
x_c = axc.*bxc;

x_a = struc(x_a);

x_c = struc(x_c);

% Y-DATA
mu_a = xlsread(sourceName, 1, 'AC255:AE374'); % vertical

mu_c = xlsread(sourceName, 1, 'AC5:AE124');   % combined
y_a = struc(mu_a);
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

min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
