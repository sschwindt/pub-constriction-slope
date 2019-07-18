% May 2017, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20161031_2-4-6_data_Fr0.xlsx';
corr = 0;
% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')

% X-DATA
Fr0a = xlsread(sourceName, 1, 'T255:V374'); % vertical
Fr0b = xlsread(sourceName, 1, 'T130:V249'); % lateral
Fr0c = xlsread(sourceName, 1, 'T5:V124');   % combined
x_a = struc(Fr0a);
x_b = struc(Fr0b);
x_c = struc(Fr0c);

% Y-DATA
the_a = xlsread(sourceName, 1, 'AL255:AN374'); % vertical
the_b = xlsread(sourceName, 1, 'AL130:AN249'); % lateral
the_c = xlsread(sourceName, 1, 'AL5:AN124');   % combined
y_a = nan(size(Fr0a));
y_b = nan(size(Fr0a));
y_c = nan(size(Fr0a));

y_a(1:numel(the_a(:,1)),1) = the_a(:,1);
y_a(1:numel(the_a(:,1)),2) = the_a(:,2);
y_a(1:numel(the_a(:,1)),3) = the_a(:,3);
y_a = struc(y_a);

y_b(1:numel(the_b(:,1)),1) = the_b(:,1);
y_b(1:numel(the_b(:,1)),2) = the_b(:,2);
y_b(1:numel(the_b(:,1)),3) = the_b(:,3);
y_b = struc(y_b);

y_c(1:numel(the_c(:,1)),1) = the_c(:,1);
y_c(1:numel(the_c(:,1)),2) = the_c(:,2);
y_c(1:numel(the_c(:,1)),3) = the_c(:,3);
y_c = struc(y_c);

cd ..
cd('DataRegression\Fr0')


% LAUNCH CFTOOL -----------------------------------------------------------
X = [x_a;x_b;x_c];
Y = [y_a;y_b;y_c];
if corr
    for i = 1:numel(X)
        if or(X(i)<0.49,X(i)>1.6)
            X(i) = nan;
            Y(i) = nan;
        end
    end
end
min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
