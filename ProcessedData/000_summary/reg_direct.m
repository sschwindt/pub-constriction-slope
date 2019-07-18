% Octobre 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20161014_opt_Qc_lat.xlsx';
fNo = 21;
% READ DATA ---------------------------------------------------------------
Jf = [0.020433,0.034772,0.055021];
% X-DATA
hx = xlsread(sourceName, 1, 'B5:B143');
R2x = nan(1,fNo);
for i = 1:fNo
    alphai = xlsread(sourceName, 1, [char('B'+i),'5:',char('B'+i),'143']);
    [xData, yData] = prepareCurveData(hx,alphai);
    % Set up fittype and options
    % Set up fittype and options
    ft = fittype( 'p1*x+p2', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0.8 0.1];
    
    % Fit model to data
    [fitresult, gof] = fit( xData, yData, ft, opts );
    R2x(i) = gof.rsquare;
    clear ft
    clear opts
end
%xlswrite('20161014_opt_Qc_lat.xlsx', R2x, 1, 'C2:W2');