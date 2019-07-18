% January 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of Distometer measurement
%--------------------------------------------------------------------------
clear all;
close all;

analysis = 0;  % 0 =  Q - h // 1 = Q - h + Qs 

% READ INPUT --------------------------------------------------------------
ProbeNum = 5;     % total number of probes to analyze
sourceName = '20160128_Qh_undisturbed.xlsx';


% sourceRangeH = 'D:J58';
% sourceRangeHQs = 'D11:J29';

switch analysis
    case 0
        data = xlsread(sourceName, 1, sourceRangeH);
        sourceRange = 'F4:J5';
    case 1
        data = xlsread(sourceName, 1, sourceRangeHQs);
        sourceRange = 'F7:J8';
end

output = nan(3,ProbeNum);

for i = 1:ProbeNum
    [xData, yData] = prepareCurveData(data(:,1),data(:,2+i));

    % Set up fittype and options
    %ft = fittype( 'a*x^b', 'independent', 'x', 'dependent', 'y' );
    ft = fittype( 'poly1' ); %other: power1
    opts = fitoptions( ft );
    %opts.Algorithm = 'Levenberg-Marquardt';
    %opts.Display = 'Off';
    opts.Lower = [-Inf -Inf];
    opts.Robust = 'Bisquare';
    %opts.StartPoint = [1 1];
    opts.Upper = [Inf Inf];

    % Fit model to data
    [fitresult, gof] = fit( xData, yData, ft, opts );
    output(:,i) = [fitresult.p1; fitresult.p2; gof.rsquare];
    
end

% Write to file
xlswrite(sourceName, output, 1, targetRange);
disp(['Results of Q-h fitting written to file.']);
