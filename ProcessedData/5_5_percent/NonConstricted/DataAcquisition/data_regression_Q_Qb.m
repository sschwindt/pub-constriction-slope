% June 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script makes regression curve of Q-Qb relation 
%--------------------------------------------------------------------------
clear all;
close all;

hand = 1;       % activate this to make manual data regression
sourceName = '20160622_Qb_h_nonconstricted.xlsx';
sourceRange = 'D13:E37';

% load data to analyse
data = xlsread(sourceName, 1, sourceRange);
Q = data(:,1);
Qb = data(:,2);
clear data
targetRange = 'E7:E9';

if not(hand)
    [xData, yData] = prepareCurveData(Q,Qb);

    % Set up fittype and options
    ft = fittype( 'power2' );
    opts = fitoptions( ft );
    opts.Display = 'Off';
    opts.Lower = [-Inf -Inf -Inf];
    opts.Robust = 'Bisquare';
    % opts.StartPoint = [1990064277.73929 5.23813527677848 -0.0042857637109916];
    opts.Upper = [Inf Inf Inf];

    % Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft, opts );
    
    % Write to file
    output = [fitresult.a; fitresult.b; fitresult.c];
    xlswrite(sourceName, output, 1, targetRange);
    
    disp(['Results written to ', sourceName,'.']);
else
    cftool(Q,Qb)
end
