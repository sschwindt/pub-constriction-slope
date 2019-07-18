% February 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of US probe measurement
%--------------------------------------------------------------------------
clear all;
close all;

% READ INPUT --------------------------------------------------------------
probeNum = 5;     % total number of probes to analyze
sourceName = '20160208_data_summary.xlsx';
sourceRange = 'D13:K118';
targetName = '20160207_sectiondata.xlsx';

% PREPARATION -------------------------------------------------------------
data = xlsread(sourceName,1,sourceRange);
b = unique(data(:,end));
Qb = [0,1];
output = nan(3*numel(b),probeNum*numel(Qb));

targetRange = ['D15:',char('C'+probeNum*2),num2str(numel(b)*3+14)];
% ANALYSIS ----------------------------------------------------------------
for db = 1:numel(b)
    bPositions = find(data(:,end)==b(db));
    tempData_b = data(bPositions(1):bPositions(end),1:end-1);
    for dqb = 1:numel(Qb)
        if not(Qb(dqb)) % without bedload
            QbPositions = find(isnan(tempData_b(:,2)));
        else            % with bedload
            QbPositions = find(not(isnan(tempData_b(:,2))));
        end
        if numel(QbPositions)>1
            tempData = tempData_b(QbPositions(1):QbPositions(end),:);
            for i = 1:probeNum
                [xData,yData]=prepareCurveData(tempData(:,1)*10^-3,tempData(:,2+i));
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
                if not(Qb(dqb)) % without bedload
                    output((db-1)*3+1:(db-1)*3+3,i) =...
                        [fitresult.p1; fitresult.p2; gof.rsquare];
                else            % with bedload
                    output((db-1)*3+1:(db-1)*3+3,i+probeNum) =...
                        [fitresult.p1; fitresult.p2; gof.rsquare];
                end            
            end
        end
    end
end

% WRITE -------------------------------------------------------------------
cd ..
cd('dE')
xlswrite(targetName, output, 1, targetRange);
cd ..
cd('DataAquisition');
disp(['Results of Q-h fitting written to file ', targetName,'.']);
