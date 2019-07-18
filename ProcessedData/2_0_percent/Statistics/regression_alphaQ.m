% April 2016, Sebastian Schwindt
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
alphaQ_temp = xlsread(sourceName, 1, 'F4:F274');
ax_temp = xlsread(sourceName, 1, 'D4:D274');
bx_temp = xlsread(sourceName, 1, 'E4:E274');
qbx_temp = xlsread(sourceName, 1,'G4:G274');
Fr_temp = xlsread(sourceName, 1, 'H4:H274');
hx_temp = xlsread(sourceName, 1, 'I4:I274');
taux = xlsread(sourceName, 1, 'J4:J274');
eta = xlsread(sourceName, 1, 'K4:K274');
mu_temp = xlsread(sourceName, 1, 'P4:P274');

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

pos1com = 1;
posXcom = 98;

pos1lat = 99;
posXlat = 204;

pos1top = 205;
posXtop = numel(expNo);

alphaQ = nan(size(expNo));
alphaQ(pos1lat:posXlat) = alphaQ_temp;
% consider rectangular cross-sections only (bx < 0.4)
alphaQtrap = nan(size(alphaQ));
for i = 1:numel(bx)
    if bx(i)>0.4
        alphaQtrap(i) = alphaQ(i);
        alphaQ(i) = nan;
    end
end

% PREPARE DATA ------------------------------------------------------------
X = nan(150,3);
Xb = nan(150,3);
Y = nan(150,3);
Yb = nan(150,3);


for i = 2
    switch i
        case 1
            pos1 = pos1com;
            posX = posXcom;
            cX = ax(pos1:posX).*bx(pos1:posX);%.*hx(pos1:posX).^2;
        case 2
            pos1 = pos1lat;
            posX = posXlat;
            cX = bx(pos1:posX);%.*hx(pos1:posX);
        case 3
            pos1 = pos1top;
            posX = posXtop;
            cX = ax(pos1:posX);%.*hx(pos1:posX)
    end

    X(1:posX-pos1+1,i) = Fr(pos1:posX);
    Y(1:posX-pos1+1,i) = alphaQtrap(pos1:posX); % for bx: use alphaQtrap(pos1:posX);
%     for j = 1:numel(bx(pos1:posX));
%         if bx(pos1+j-1)<.6115
%             Ylow(j,i) = alphaQ(pos1+j-1);
%         end
% %         if and(bx(pos1+j-1)>=.6215,bx(pos1+j-1)<.625)
% %             Ylow(j,i) = alphaQ(pos1+j-1);
% %             Yup(j,i) = alphaQ(pos1+j-1);
% %         end
%         if bx(pos1+j-1)>=.6115
%             Yup(j,i) = alphaQ(pos1+j-1);
%         end
%     end
    
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

trust = [min(XX);max(XX)]

cftool(XX(:,2),YY(:,2));
% cftool(Xb(:,3),Yb(:,3));
disp('Data processed.');
