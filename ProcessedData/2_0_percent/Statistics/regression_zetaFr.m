% February 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script completes summary table for combined constrictions
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160402_statistics_h.xlsx';


% READ DATA ---------------------------------------------------------------
% from statistics summary file

% get opening size
expNo = xlsread(sourceName, 1, 'B4:B274');
mu_temp = xlsread(sourceName, 1, 'P4:P274');
muh = xlsread(sourceName, 1, 'O4:O274');
ax_temp = xlsread(sourceName, 1, 'D4:D274');
bx_temp = xlsread(sourceName, 1, 'E4:E274');
qbx_temp = xlsread(sourceName, 1,'G4:G274');
Fr_temp = xlsread(sourceName, 1, 'H4:H274');
hx_temp = xlsread(sourceName, 1, 'I4:I274');
taux = xlsread(sourceName, 1, 'J4:J274');
eta = xlsread(sourceName, 1, 'K4:K274');
qbx = nan(size(expNo));
qbx(1:numel(qbx_temp)) = qbx_temp;

ax = nan(size(expNo));
ax(1:numel(ax_temp))=ax_temp;

bx = nan(size(expNo));
bx(1:numel(bx_temp))=bx_temp;

Fr = nan(size(expNo));
Fr(1:numel(Fr_temp)) = Fr_temp;

mu = nan(size(expNo));
mu(1:numel(mu_temp)) = mu_temp;

hx = nan(size(expNo));
hx(1:numel(hx_temp)) = hx_temp;

zeta_temp = xlsread(sourceName, 1, 'M4:M274');
zeta = nan(size(expNo));
zeta(1:numel(zeta_temp))=zeta_temp;

pos1com = 1;
posXcom = 98;

pos1lat = 99;
posXlat = 204;

pos1top = 205;
posXtop = numel(mu);

% PREPARE DATA ------------------------------------------------------------
X = nan(150,3);
Xb = nan(150,3);
Y = nan(150,3);
Yb = nan(150,3);

for i = 1:3
    switch i
        case 1
            pos1 = pos1com;
            posX = posXcom;
            cX = (ax(pos1:posX).*bx(pos1:posX));%./hx(pos1:posX);
        case 2
            pos1 = pos1lat;
            posX = posXlat;
            cX = bx(pos1:posX);%.*hx(pos1:posX);
        case 3
            pos1 = pos1top;
            posX = posXtop;
            cX = ax(pos1:posX);%.*hx(pos1:posX);
    end
    %cX = hx(pos1:posX);
    X(1:posX-pos1+1,i) = Fr(pos1:posX);
    Y(1:posX-pos1+1,i) = zeta(pos1:posX);
    % points with bedload
    posQb = find(not(isnan(qbx(pos1:posX)))); % positions
    for j = 1:numel(posQb)
        Xb(posQb(j),i) = X(posQb(j),i);
        Yb(posQb(j),i) = Y(posQb(j),i);
        % delete points from without-bedload-data
        X(posQb(j),i) = nan;
        Y(posQb(j),i) = nan;
    end
end
XX = [X;Xb];
YY = [Y;Yb];
XXX = [XX(:,1);XX(:,2);XX(:,3)];
YYY = [YY(:,1);YY(:,2);YY(:,3)];
trust = [min(XX);max(XX)]
%XX(end,:)=[1,1,1];
%YY(end,:)=[0,0,0];
cftool(XXX(:,1),YYY(:,1));
disp('Data processed.');
