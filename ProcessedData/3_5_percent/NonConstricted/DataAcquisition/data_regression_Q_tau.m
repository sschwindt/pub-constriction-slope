% April 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of Distometer measurement
%--------------------------------------------------------------------------
clear all;
close all;

analysis = 1;  % 0 =  Q - tau // 1 = Q - tau + Qs 

% READ INPUT --------------------------------------------------------------

sourceName = '20160322_Qb_h_nonconstricted.xlsx';


tau = xlsread(sourceName, 1, 'L13:L36');
Q = xlsread(sourceName, 1, 'D13:D36');


cftool(Q,tau)
