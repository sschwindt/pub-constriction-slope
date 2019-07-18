% Octobre 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160913_2-4-6_data_hcr.xlsx';
findJfrel = 0; % if 1: running of best R^2 --> may take time!
Jfp1 = 0; % activate this for analysing the relation between Jf and p1;
% READ DATA ---------------------------------------------------------------
% from statistics summary file
cd ..\..
cd('Data')
Jf = [0.020433,0.034772,0.055021];
% X-DATA
bx = xlsread(sourceName, 1, 'N130:P249'); % lateral
hx = xlsread(sourceName, 1, 'T130:V249'); % lateral
x_a = struc(bx);
x_b = struc(hx);
x = hx;
for i = 1:numel(x(:,1))
    for j = 1:numel(x(1,:))
        if x(i,j)>1
            x(i,j) = nan;
        end
    end
end

% Y-DATA
alpha = xlsread(sourceName, 1, 'Z130:AB249'); % lateral
y_b = struc(alpha);
y = nan(size(x));
y(1:numel(alpha(:,1)),:) = alpha;


cd ..
cd('DataRegression')


% LAUNCH CFTOOL -----------------------------------------------------------
if findJfrel
    fac = 0:0.01:1;
    R2 = nan(numel(fac),1);

    %y = (y.*(-25.*Jf_matrix))+1.9;
    Xf = [x(:,1);x(:,2);x(:,3)];
    for f = 1:numel(fac)
        yf = nan(size(y));    
        for j = 1:3
            yf(:,j) = (y(:,j)-fac(f)*Jf(j))./(-8.*Jf(j)+0.8);
        end
        Yf = [yf(:,1);yf(:,2);yf(:,3)];
        [xData, yData] = prepareCurveData(Xf,Yf);
        % Set up fittype and options
        % Set up fittype and options
        ft = fittype( ['x+p2'], 'independent', 'x', 'dependent', 'y' );
        opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
        opts.Display = 'Off';
        opts.StartPoint = [0.8];

        % Fit model to data
        [fitresult, gof] = fit( xData, yData, ft, opts );
        R2(f) = gof.rsquare;
        clear ft
        clear opts
    end

    plot(fac,R2)
    bestPos = find(R2==max(R2));
    bestf = fac(bestPos); % found: bestf =3.7
else
    bestf = 0.25; % =3.3 without f_cr
end

X = [x(:,1);x(:,2);x(:,3)];

f1 = -8;
f2 = 0.8;
Y = [(y(:,1)-bestf*Jf(1))./(f1*Jf(1)+f2);...
        (y(:,2)-bestf*Jf(2))./(f1*Jf(2)+f2);...
            (y(:,3)-bestf*Jf(3))./(f1*Jf(3)+f2)];

% X = x(:,1);
% Y = y(:,1);


min(X)
max(X)
cftool(X,Y);
if Jfp1
    % p1 = [1.47, 0.9212, 0.576]; % 2p, 4p, 6p without f_cr
    p1 = [0.6336, 0.4887, 0.3681]; % 2p, 4p, 6p
    cftool(Jf,p1);
end
disp('Data processed.');

