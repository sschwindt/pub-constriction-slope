% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of Distometer measurement
%--------------------------------------------------------------------------
clear all;
close all;

analysis = 1;  % 0 =  Q - tau // 1 = Q - tau + Qs 

% READ INPUT --------------------------------------------------------------

sourceName = '20160128_Qh_undisturbed.xlsx';


tau = xlsread(sourceName, 1, 'L15:L46');
Q = xlsread(sourceName, 1, 'D15:D46');


cftool(Q,tau)
