% Script creates water level plot for publication

% January 2016, Sebastian Schwindt
% EPF Lausanne, LCH
%--------------------------------------------------------------------------

clear all;
close all;

write2disc = 1;

sourceName = '20160126_chezy_sectionwise.xlsx';
sourceRangeQ = 'J8:J58';
sourceRangeC = 'K8:L58';


% READ DATA ---------------------------------------------------------------
% 1=X -- 2=BedLvl -- 3=UndistLvl -- 4=TopLvl -- 5=LatLvl
Q = xlsread(sourceName, 4, sourceRangeQ);
C = xlsread(sourceName, 4, sourceRangeC);

% ANOVA -------------------------------------------------------------------

% data preparation
X = [Q, zeros(numel(Q),1); Q, ones(numel(Q),1)];
Y = [C(:,1);C(:,2)];

model=LinearModel.stepwise(X,Y,'constant');


    

