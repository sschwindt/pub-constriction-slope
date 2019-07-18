% September 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
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
ax_a = xlsread(sourceName, 1, 'K255:M374'); % vertical
bx_b = xlsread(sourceName, 1, 'N130:P249'); % lateral
ax_c = xlsread(sourceName, 1, 'K5:M124'); % ax (combined)
bx_c = xlsread(sourceName, 1, 'N5:P124'); % bx (combined)
x_a = ax_a;
x_b = [bx_c(:,1)./Jf(1),bx_c(:,2)./Jf(2),bx_c(:,3)./Jf(3)];
x_c = [ax_c(:,1).*bx_c(:,1)./Jf(1),...
            ax_c(:,2).*bx_c(:,2)./Jf(2),...
                ax_c(:,3).*bx_c(:,3)./Jf(3)];
            
cc = 0;
c_all = 0;
for i = 1:numel(x_b(:,1))
    for j = 1:numel(Jf)
        c_all = c_all+1;
        if or(x_a(i,j) > 9.95, x_b(i,j)<2.5)
            x_c(i,j) = nan;
            cc = cc+1;
            disp(bx_c(i,j))
        end
    end
end
% Y-DATA
hx_a = xlsread(sourceName, 1, 'T255:V374'); % vertical
hx_b = xlsread(sourceName, 1, 'T130:V249'); % lateral
hx_c = xlsread(sourceName, 1, 'T5:V124');   % combined
y_a = hx_a;
y_b = hx_b;
y_c = hx_c;

cd ..
cd('DataRegression')
disp(['Percentage of deleted data: ', num2str(cc/c_all*100), ' %.'])

% LAUNCH CFTOOL -----------------------------------------------------------
X = struc(x_c);
Y = struc(y_c);
min(X)
max(X)
cftool(X,Y);
disp('Data processed.');
