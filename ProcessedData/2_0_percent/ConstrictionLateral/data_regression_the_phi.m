% Script outputs regression curve
% 
% December 2015, Sebastian SCHWINDT
% EPF Lausanne, LCH
%--------------------------------------------------------------------------

clear all;
close all;

% READ DATA
%--------------------------------------------------------------------------
%cd ..

% Read pump discharge from Excelfile
phi = xlsread('20151217_Qsmax_lat.xls', 1, 'k24:k55');
theta = xlsread('20151217_Qsmax_lat.xls', 1, 'g24:g55');

% COMPUTE
%--------------------------------------------------------------------------
cftool(phi,theta)

% WRITE DATA
%--------------------------------------------------------------------------
%xlswrite('20151201_Qsmax_lat.xls',w, 1, writeRange);
