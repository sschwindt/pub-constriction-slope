% July 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script interpolates of Q-h relation of Distometer measurement
%--------------------------------------------------------------------------
clear all;
close all;

analysis = 1;  % 0 =  Q - h // 1 = Q - h + Qs 

% READ INPUT --------------------------------------------------------------

sourceName = '20160622_Qb_h_nonconstricted.xlsx';

switch analysis
    case 0 % DULL ?!
        tau = xlsread(sourceName, 1, 'L38:L62');
        Q = xlsread(sourceName, 1, 'D38:D62');
        % targetRange = 'F4:J6';
    case 1
        tau = xlsread(sourceName, 1, 'L13:L37');
        Q = xlsread(sourceName, 1, 'D13:D37');
        % targetRange = 'F7:J9';
end

cftool(Q,tau)


