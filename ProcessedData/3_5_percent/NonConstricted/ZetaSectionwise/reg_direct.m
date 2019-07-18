% Octobre 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Creates regression curves directly from summary file
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160425_sectiondata.xlsx';

% READ DATA ---------------------------------------------------------------
Jf = [0.020433,0.034772,0.055021];
% X-DATA
Q = xlsread(sourceName, 2, 'L5:L55');
zeta = xlsread(sourceName, 2, 'O5:O55');


% LAUNCH CFTOOL -----------------------------------------------------------
X = Q;
Y = zeta;
cftool(X,Y);
disp('Data processed.');
