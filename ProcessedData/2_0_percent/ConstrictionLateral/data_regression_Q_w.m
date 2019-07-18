% Script outputs regression curve
% 
% December 2015, Sebastian SCHWINDT
% EPF Lausanne, LCH
%--------------------------------------------------------------------------

clear all;
close all;

% Interpolation constants
p1 = 0.00467;       % from Q-w regression curve
p2 = 0.20635;       % from Q-w regression curve
writeRange = 'j24:j55'; % adjust range for datawrite

% READ DATA
%--------------------------------------------------------------------------
%cd ..

% Read pump discharge from Excelfile
Q = xlsread('20151217_Qsmax_lat.xls', 1, 'C24:C55');
w = nan(size(Q));

% COMPUTE
%--------------------------------------------------------------------------
for i = 1:numel(w)
    w(i) = p1*Q(i)+p2;  % apply regression
end

% WRITE DATA
%--------------------------------------------------------------------------
xlswrite('20151207_Qsmax_lat.xls',w, 1, writeRange);




