% June 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of Distometer measurement
%--------------------------------------------------------------------------
clear all;
close all;

analysis = 0;  % 0 =  Q - h // 1 = Q - h + Qs 
hand = 0;
% READ INPUT --------------------------------------------------------------
probe = 5;      % probe No. -- only if hand = 1
ProbeNum = 5;    % total number of probes to analyze -- if hand = 0
sourceName = '20160622_Qb_h_nonconstricted.xlsx';
sourceRangeH = 'D38:J62';
sourceRangeHQs = 'D13:J37';

switch analysis
    case 0
        data = xlsread(sourceName, 1, sourceRangeH);
        targetRange = 'F4:J6';
    case 1
        data = xlsread(sourceName, 1, sourceRangeHQs);
        targetRange = 'F7:J9';
end

output = nan(3,ProbeNum);

if not(hand)
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
else
    cftool(data(:,1),data(:,2+probe))
end
% Write to file
xlswrite(sourceName, output, 1, targetRange);
disp(['Results of Q-h fitting written to file.']);
