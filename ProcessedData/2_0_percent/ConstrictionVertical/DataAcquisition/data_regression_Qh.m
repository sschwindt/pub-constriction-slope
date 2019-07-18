% February 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of US probe measurement
%--------------------------------------------------------------------------
clear all;
close all;

% READ INPUT --------------------------------------------------------------
probeNum = 5;     % total number of probes to analyze
sourceName = '20160220_data_summary.xlsx';
sourceRange = 'D13:M80';
targetName = '20160220_sectiondata.xlsx';

% PREPARATION -------------------------------------------------------------
data = xlsread(sourceName,1,sourceRange);
a = unique(data(:,end));
Qb = [0,1];
output = nan(3,2*probeNum);
% DX = [0.5920, 0.5480, 0.4210, 0.2740]; % section length
% constPos = 0.194;       %[m] start of the constriction (upstream of US5)
% xPos = sum(DX)-0.194;

targetRange = ['D15:',char('C'+probeNum*2),'17'];
% ANALYSIS ----------------------------------------------------------------

for dqb = 1:numel(Qb)
    if not(Qb(dqb)) % without bedload
        QbPositions = find(isnan(data(:,2)));
        
    else            % with bedload
        QbPositions = find(not(isnan(data(:,2))));
    end
    vQb = 1;
    if numel(QbPositions)>1
        tempData = data(QbPositions(1):QbPositions(end),:);
        for i = 1:probeNum
            %xRel = xPos/(sum(DX(1+i-1:end))-constPos);
            
            if i < probeNum
                ah = tempData(:,end);
              
            else
                ah = tempData(:,end).^-1;
            end
            if Qb(dqb)
                vQb = 1-tempData(:,2).^0.5;
            end
            [xData,yData]=prepareCurveData(tempData(:,1)./ah.*vQb,tempData(:,2+i));
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
                output(1:3,i) =...
                    [fitresult.p1; fitresult.p2; gof.rsquare];
            else            % with bedload
                output(1:3,i+probeNum) =...
                    [fitresult.p1; fitresult.p2; gof.rsquare];
            end
        end
    end
end


% WRITE -------------------------------------------------------------------
cd ..
cd('dE')
xlswrite(targetName, output, 1, targetRange);
cd ..
cd('DataAcquisition');
disp(['Results of Q-h fitting written to file ', targetName,'.']);
