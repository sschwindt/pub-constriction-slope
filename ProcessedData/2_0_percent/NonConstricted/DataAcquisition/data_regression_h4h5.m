% January 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script interpolates of Q-u relation between to probes
%--------------------------------------------------------------------------
clear all;
close all;


sourceName = '20160128_Qh_undisturbed.xlsx';
sourceRangeQ = 'Q4:Q27';
sourceRangeM = 'R4:R27';
%sourceRangeUj = 'G9:G32';
%targetRange = 'B4:F4';

% READ INPUT --------------------------------------------------------------
Q = xlsread(sourceName, 2, sourceRangeQ);
M = xlsread(sourceName, 2, sourceRangeM);
%uj = xlsread(sourceName, 1, sourceRangeUj);

%rU = ui./uj;
output = nan(1,3);
cftool(Q,M);

% [xData, yData] = prepareCurveData(data(:,1),data(:,2+i));
% 
% % Set up fittype and options
% ft = fittype( 'a*x^b', 'independent', 'x', 'dependent', 'y' );
% opts = fitoptions( ft );
% opts.Display = 'Off';
% opts.Lower = [-Inf -Inf];
% opts.StartPoint = [1 1];
% opts.Upper = [Inf Inf];
% 
% % Fit model to data
% [fitresult, gof] = fit( xData, yData, ft, opts );
% output(:,i) = [fitresult.a; fitresult.b; gof.rsquare];
% 
% 
% % Write to file
% xlswrite(sourceName, output, 1, targetRange);
% disp(['Results of Q-h fitting written to file.']);
