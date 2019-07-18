% February 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script compute correlation matrices
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160224_statistics.xlsx';


% READ DATA ---------------------------------------------------------------

% get opening size
mu = xlsread(sourceName, 1, 'F4:F274');
ax = xlsread(sourceName, 1, 'D4:D274');
bx = xlsread(sourceName, 1, 'E4:E274');
qbx_temp = xlsread(sourceName, 1,'G4:G274');
Fr = xlsread(sourceName, 1, 'H4:H274');
HH = xlsread(sourceName, 1, 'I4:I274');
taux_temp = xlsread(sourceName, 1, 'J4:J274');
eta_temp = xlsread(sourceName, 1, 'K4:K274');

% COMPUTE ------------------------------------------------------------------
%Interactions(1:numel(qbx),:)];
qbx = nan(size(Fr));
qbx(1:numel(qbx_temp))=qbx_temp;

taux = nan(size(Fr));
taux(1:numel(taux_temp))=taux_temp;

eta = nan(size(Fr));
eta(1:numel(eta_temp))=eta_temp;
% ax = ax(1:numel(qbx));
% bx = bx(1:numel(qbx));
% Fr = Fr(1:numel(qbx));
DATA = [ax,bx,Fr,qbx,mu,HH,taux,eta];
no = numel(DATA(1,:));
corr_ij = nan(no,no);

% ALL
for i = 1:no
    ai = DATA(:,i);
    for j = 1:no
        
       aj = DATA(:,j);
       if isnan(sum(ai))
            nNan = numel(find(isnan(ai)));
        end
        if isnan(sum(aj))
            nNan = numel(find(isnan(aj)));
        end
        if not(exist('nNan','var'))
            nNan = 1;
        end
        cov_ij = 1/(numel(ai)-nNan)*nansum((ai-nanmean(ai)).*(aj-nanmean(aj)));
        %cov_ij = mean(mean(nancov(DATA(:,i),DATA(:,j))));
        var_ai = 1/(numel(ai)-nNan)*nansum((ai-nanmean(ai)).*(ai-nanmean(ai)));
        var_aj = 1/(numel(aj)-nNan)*nansum((aj-nanmean(aj)).*(aj-nanmean(aj)));
        corr_ij(i,j) = cov_ij/(sqrt(var_ai)*sqrt(var_aj));
    end
end
targetRange = 'P5:W12';
xlswrite(sourceName,corr_ij, 1, targetRange);

% TOP
for i = 1:no
    ai = DATA(99:204,i);
    for j = 1:no
        
        aj = DATA(99:204,j);
        if isnan(sum(ai))
            nNan = numel(find(isnan(ai)));
        end
        if isnan(sum(aj))
            nNan = numel(find(isnan(aj)));
        end
        if not(exist('nNan','var'))
            nNan = 1;
        end
        cov_ij = 1/(numel(ai)-nNan)*nansum((ai-nanmean(ai)).*(aj-nanmean(aj)));
        var_ai = 1/(numel(ai)-nNan)*nansum((ai-nanmean(ai)).*(ai-nanmean(ai)));
        var_aj = 1/(numel(aj)-nNan)*nansum((aj-nanmean(aj)).*(aj-nanmean(aj)));
        corr_ij(i,j) = cov_ij/(sqrt(var_ai)*sqrt(var_aj));
    end
end
targetRange = 'P16:W23';
xlswrite(sourceName,corr_ij, 1, targetRange);

% LATERAL
for i = 1:no
    ai = DATA(205:end,i);
    for j = 1:no
        
        aj = DATA(205:end,j);
        if isnan(sum(ai))
            nNan = numel(find(isnan(ai)));
        end
        if isnan(sum(aj))
            nNan = numel(find(isnan(aj)));
        end
        if not(exist('nNan','var'))
            nNan = 1;
        end
        cov_ij = 1/(numel(ai)-nNan)*nansum((ai-nanmean(ai)).*(aj-nanmean(aj)));
        var_ai = 1/(numel(ai)-nNan)*nansum((ai-nanmean(ai)).*(ai-nanmean(ai)));
        var_aj = 1/(numel(aj)-nNan)*nansum((aj-nanmean(aj)).*(aj-nanmean(aj)));
        corr_ij(i,j) = cov_ij/(sqrt(var_ai)*sqrt(var_aj));
    end
end
targetRange = 'P27:W34';
xlswrite(sourceName,corr_ij, 1, targetRange);


disp('Data processed.');
