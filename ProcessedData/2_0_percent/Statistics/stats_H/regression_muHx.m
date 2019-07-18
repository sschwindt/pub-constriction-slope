% February 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script completes summary table for combined constrictions
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160224_statistics.xlsx';


% READ DATA ---------------------------------------------------------------
% from statistics summary file

% get opening size
mu = xlsread(sourceName, 1, 'F4:F274');
ax = xlsread(sourceName, 1, 'D4:D274');
bx = xlsread(sourceName, 1, 'E4:E274');
qbx_temp = xlsread(sourceName, 1,'G4:G274');
Fr = xlsread(sourceName, 1, 'H4:H274');
Hx = xlsread(sourceName, 1, 'I4:I274');
taux = xlsread(sourceName, 1, 'J4:J274');
eta = xlsread(sourceName, 1, 'K4:K274');
qbx = nan(size(mu));
qbx(1:numel(qbx_temp)) = qbx_temp;

pos1com = 1;
posXcom = 98;

pos1lat = 99;
posXlat = 204;

pos1top = 205;
posXtop = numel(mu);

% PREPARE DATA ------------------------------------------------------------
X = nan(150,3);
Y = nan(150,3);

for i = 1:3
    switch i
        case 1
            pos1 = pos1com;
            posX = posXcom;
            cX = ax(pos1:posX).*bx(pos1:posX)./Hx(pos1:posX).^2;
        case 2
            pos1 = pos1lat;
            posX = posXlat;
            cX = bx(pos1:posX)./Hx(pos1:posX);
        case 3
            pos1 = pos1top;
            posX = posXtop;
            cX = ax(pos1:posX)./Hx(pos1:posX);
    end
    
    X(1:posX-pos1+1,i) = cX;
    Y(1:posX-pos1+1,i) = mu(pos1:posX);

end
cftool(X(:,1),Y(:,1));
disp('Data processed.');
