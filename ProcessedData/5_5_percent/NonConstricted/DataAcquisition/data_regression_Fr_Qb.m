% May 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script makes regression curve of Q-Qb relation 
%--------------------------------------------------------------------------
clear all;
close all;

hand = 0;       % activate this to make manual data regression
sourceName = '20160322_Qb_h_nonconstricted.xlsx';
sourceRange = 'D13:E40';

% load data to analyse
data = xlsread(sourceName, 1, sourceRange);
Fr = xlsread(sourceName, 1, 'M13:M40');
Qb = data(1:24,2);
clear data
targetRange = 'P17:P20';

if not(hand)
    [xData, yData] = prepareCurveData(Fr,Qb);

    % Set up fittype and options
    ft = fittype( 'power2' );
    opts = fitoptions( ft );
    opts.Display = 'Off';
    opts.Lower = [-Inf -Inf -Inf];
    opts.Robust = 'Bisquare';
    opts.StartPoint = [1990064277.73929 5.23813527677848 -0.0042857637109916];
    opts.Upper = [Inf Inf Inf];

    % Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft, opts );
    
    % Write to file
    output = [fitresult.a; fitresult.b; fitresult.c; gof.rsquare];
    xlswrite(sourceName, output, 1, targetRange);
    
    disp(['Results written to ', sourceName,'.']);
else
    cftool(Fr,Qb)
end
