% April 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of Distometer measurement
%--------------------------------------------------------------------------
clear all;
close all;

analysis = 0;  % 0 = chezy without Qs // 1 = chezy with Qs

% READ INPUT --------------------------------------------------------------
sourceName = '20160421_chezy_sectionwise.xlsx';
sourceRangeQ = 'B8:B58';
switch analysis
    case 0
        sourceRangeC = 'C8:C58';
        targetRange = 'Q5:Q8';
    case 1
        sourceRangeC = 'D8:D58';
        targetRange = 'R5:R8';
end

Q = xlsread(sourceName, 4, sourceRangeQ);
C = xlsread(sourceName, 4, sourceRangeC);


[xData, yData] = prepareCurveData(Q,C);

% Set up fittype and options
%ft = fittype( 'a*x^b+c', 'independent', 'x', 'dependent', 'y' );
ft = fittype( 'power2' ); %other: power1, poly1
opts = fitoptions( ft );
%opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.Lower = [-Inf -Inf -Inf];
%opts.Robust = 'Bisquare';
%opts.StartPoint = [1 1];
opts.Upper = [Inf Inf Inf];

% Fit model to data
[fitresult, gof] = fit( xData, yData, ft, opts );
output = [fitresult.a; fitresult.b; fitresult.c; gof.rsquare];


% Write to file
xlswrite(sourceName, output, 4, targetRange);
disp(['Results written to file (R2 = ',...
    num2str(output(end),'%0.4f'),').']);
