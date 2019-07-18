% January 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of Distometer measurement
%--------------------------------------------------------------------------
clear all;
close all;

analysis = 0;  % 0 = chezy without Qs // 1 = chezy with Qs

% READ INPUT --------------------------------------------------------------
sourceName = '20160126_chezy_sectionwise.xlsx';
sourceRangeQ = 'B8:B58';
switch analysis
    case 0
        sourceRangeC = 'C8:C58';
        targetRange = 'Q5:Q9';
    case 1
        sourceRangeC = 'D8:D58';
        targetRange = 'R5:R9';
end

Q = xlsread(sourceName, 4, sourceRangeQ);
C = xlsread(sourceName, 4, sourceRangeC);


[xData, yData] = prepareCurveData(Q,C);

% Set up fittype and options
ft = fittype( 'a*exp(b*x)+c*exp(d*x)', 'independent', 'x', 'dependent', 'y' );
%ft = fittype( 'poly1' ); %other: power1
opts = fitoptions( ft );
%opts.Algorithm = 'Levenberg-Marquardt';
opts.Display = 'Off';
opts.Lower = [-Inf -Inf];
%opts.Robust = 'Bisquare';
%opts.StartPoint = [1 1];
opts.Upper = [Inf Inf];

% Fit model to data
[fitresult, gof] = fit( xData, yData, ft, opts );
output = [fitresult.a; fitresult.b; fitresult.c; fitresult.d; gof.rsquare];


% Write to file
xlswrite(sourceName, output, 4, targetRange);
disp(['Results written to file (R2 = ',...
    num2str(output(end),'%0.4f'),').']);
