% August 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies values from respective slope and non-constricted folder 
% into bedload data summary file (2-4-6_bedloaddata_nc.xlsx)
%% VARIABLE DECLARATION ---------------------------------------------------
clear variables;
close all;

slope = [2, 4, 6];  % [name] names of exp series
I0 = [0.020433,0.034772,0.055021]; % [per cent] real verified bottom slopes
readLen = 120;      % Dummy value
targetName0 = '20160815_2-4-6_bedload_nc.xlsx';
targetName1 = '20161121_2-4-6_bedload_error.xlsx';

% preparation of output matrices (2-4-6 %)
rowLen = readLen;
expNo = nan(rowLen, numel(slope));
fileNo= nan(rowLen, numel(slope));
Q = nan(rowLen, numel(slope));
Qb = nan(rowLen, numel(slope));
h4   = nan(rowLen, numel(slope));
c    = nan(rowLen, numel(slope));
Fr    = nan(rowLen, numel(slope));
Phi   = nan(rowLen, numel(slope));
evalSJ = nan(rowLen, numel(slope));
evalRIC = nan(rowLen, numel(slope));
hcr   = nan(rowLen, numel(slope));
hcrX  = nan(rowLen, numel(slope));
hx    = nan(rowLen, numel(slope));
wm    = nan(rowLen, numel(slope));

file_names = {'20160128_Qh_undisturbed', ...        % 2 per cent
                '20160322_Qb_h_nonconstricted', ... % 4 per cent
                    '20160622_Qb_h_nonconstricted'};    % 6 per cent

rowN = nan(1,3);    % stores No. of experiments in each file

%       e  f  Q, Qb, h4,  c,taux
colN = [1, 2, 3,  4,  8, 10, 11; ... % 2p 
        1, 2, 3,  4,  8, 10, 11; ... % 4p 
        1, 2, 3,  4,  8, 10, 11; ... % 6p 
        ];
    
D90 = 0.01478;
D84 = 0.01368;
D65 = 0.01097;
D60 = 0.01045;
Dm  = 0.00938; 
D50 = 0.00965;
D30 = 0.00423;
D16 = 0.00727;
g = 9.81;       %[m/s²]

% Preparation for bedload formulae
fCopyFunction('fRecking.m');
fCopyFunction('fRickenmann.m');
fCopyFunction('fSmartJaeggi.m');
fCopyFunction('fGethcr.m');
fCopyFunction('fGetQ.m');
fCopyFunction('fGetQbmaxGlob.m');

Q_theo = 0.005:10^-4:0.01;
hX_theo = nan(numel(Q_theo),3);
Phi_SJ = nan(numel(Q_theo),3); %[-] Phi according to Smart-Jaeggi, 3 I0s
Phi_RIC = nan(numel(Q_theo),3); %[-] Phi according to Rickenmann, 3 I0s
Phi_REC = nan(numel(Q_theo),3); %[-] Phi according to Recking, 3 I0s

err_SJ = nan(numel(Q_theo),3); %[-] error Smart-Jaeggi, 3 I0s
err_RIC = nan(numel(Q_theo),3); %[-] error Rickenmann, 3 I0s
err_REC = nan(numel(Q_theo),3); %[-] error Recking, 3 I0s

%% READ DATA --------------------------------------------------------------
for s = 1:numel(slope)
    cd ..\..
    cd([num2str(slope(s)),'perCent\NonConstricted\DataAcquisition'])

        
    % read file
    fileN = [file_names{s},'.xlsx'];
    disp(['Reading ', num2str(slope(s)),'%, ', fileN, ' ...']);
    fileData = nan(readLen, 30); % covers field B13:AE13+readLen
    tempData = xlsread(fileN, 1, ['B13:AC',num2str(readLen+13)]);
    rowN(s) = numel(tempData(:,1));
    
    % write data to output matrices

    expNo(1:rowN(s),s) = tempData(:,1);
    fileNo(1:rowN(s),s) = tempData(:,2);

    Q(1:rowN(s),s)=tempData(:,colN(s,3));
    
    
    Qb(1:rowN(s),s)=tempData(:,colN(s,4));
    
    h4(1:rowN(s),s)=tempData(:,colN(s,5));
    c(1:rowN(s),s)=tempData(:,colN(s,6));


    % set interpolation parameters for nan values of h4 probe
    switch s
        case 1 
             % set interpolation parameters for nan values of h4 probe
            p1 = 2.48579619222229;
            p2 = 0.0321024089663519;
            % set channel geometry values at constriction
            w = 0.111;
            alpha = 0.5*(24.51525627+24.73653666);
        case 2
             % set interpolation parameters for nan values of h4 probe
            p1 = 2.66230598445963;
            p2 = 0.0238379501572616;
            % set channel geometry values at constriction
            w = 0.5*(0.085066638+0.099039895);
            alpha = 0.5*(22.64513793+24.99056711);
        case 3
             % set interpolation parameters for nan values of h4 probe
            p1 = 2.36778008867252;
            p2 = 0.0235276512003156;
            % set channel geometry values at constriction
            w = 0.5*(0.0822632278295273+0.10656594817979);
            alpha = 0.5*(23.1253549056903+25.7942975891345);
    end
    m = 1/tand(alpha);
    
    % Compute missing variables
    for i = 1:rowN(s)
        if isnan(h4(i,s))
            h4(i,s) = p1*Q(i,s)+p2;
            
        end
        wm(i,s) = w+h4(i,s)./tand(alpha);
        Fr(i,s) = Q(i,s)*sqrt(w+2*h4(i,s)./tand(alpha))/...
                    (h4(i,s)*(w+ h4(i,s)./tand(alpha)))^(3/2)/sqrt(g);
        qb = Qb(i,s)/wm(i,s); % [m²/s]
        Phi(i,s) = qb/sqrt(g*1.68)/D84^1.5/1000;
    end
    
    hcr(:,s) = fGethcr(alpha, Q(:,s), w);
    hcrX(:,s) = (h4(:,s)./hcr(:,s)).^-1;
    cd ..\..\..
    cd('2-4-6-summary\Data')
    
    %% BEDLOAD FORMULAE PERFORMANCE
    evalSJ(:,s) = fSmartJaeggi(D84,D30,D90,...
                          h4(:,s),I0(s),m,w,Q(:,s));
    evalRIC(:,s) = fRickenmann(D50,D30,D90,...
                          h4(:,s),I0(s),m,w,Q(:,s));
    
    %% BEDLOAD FORMULAE IN Q RANGE
    hcr_theo = fGethcr(alpha,Q_theo,w);
    h0_theo = p1.*Q_theo+p2;
    hX_theo(:,s) = (h0_theo./hcr_theo).^-1;
    Qb_theo = fGetQbmaxGlob(Q_theo,I0(s));
    wm_theo = w+h0_theo./tand(alpha);
    qb_theo = Qb_theo./wm_theo; % [m²/s]
    Phi_theo = qb_theo./sqrt(g*1.68)./D84^1.5./1000;
    
    Phi_SJ(:,s) = fSmartJaeggi(Dm,D30,D90,...
                          h0_theo,I0(s),m,w,Q_theo);
    Phi_RIC(:,s) = fRickenmann(D50,D30,D90,...
                          h0_theo,I0(s),m,w,Q_theo);
    Phi_REC(:,s) = fRecking(D84,D50,Dm,...
                          h0_theo,I0(s),m,w);
    Phi_REC(:,s) = Phi_REC(:,s).*wm_theo';
    Phi_RIC(:,s) = Phi_RIC(:,s).*wm_theo';
    Phi_SJ(:,s) = Phi_SJ(:,s).*wm_theo';
    
    err_SJ(:,s) = (Phi_SJ(:,s)-Phi_theo')./Phi_theo'.*100;
    err_RIC(:,s) = (Phi_RIC(:,s)-Phi_theo')./Phi_theo'.*100;
    err_REC(:,s) = (Phi_REC(:,s)-Phi_theo')./Phi_theo'.*100;
    

end
%% STATISTICS
dims = sqrt(g*(s-1))*D84^1.5*1000;

mdlSJ2 = fitlm(Qb(:,1)./wm(:,1),evalSJ(:,1).*dims);
mdlSJ4 = fitlm(Qb(:,2)./wm(:,2),evalSJ(:,2).*dims);
mdlSJ6 = fitlm(Qb(:,3)./wm(:,3),evalSJ(:,3).*dims);

mdlRIC2 = fitlm(Qb(:,1)./wm(:,1),evalRIC(:,1).*dims);
mdlRIC4 = fitlm(Qb(:,2)./wm(:,2),evalRIC(:,2).*dims);
mdlRIC6 = fitlm(Qb(:,3)./wm(:,3),evalRIC(:,3).*dims);

% Coefficient of dtermination R2 - use ordinary!
R2RicAdj = [mdlRIC2.Rsquared.Adjusted, mdlRIC4.Rsquared.Adjusted, ...
                mdlRIC6.Rsquared.Adjusted];
R2RicOrd = [mdlRIC2.Rsquared.Ordinary, mdlRIC4.Rsquared.Ordinary, ...
                mdlRIC6.Rsquared.Ordinary];
            
R2SjAdj = [mdlSJ2.Rsquared.Adjusted, mdlSJ4.Rsquared.Adjusted, ...
                mdlSJ6.Rsquared.Adjusted];
R2SjOrd = [mdlSJ2.Rsquared.Ordinary, mdlSJ4.Rsquared.Ordinary, ...
                mdlSJ6.Rsquared.Ordinary];
            
%% WRITE DATA 
startRow = 5;
dataStartRow = 1;


rowVec = dataStartRow:dataStartRow+readLen-1;
Write0 = nan(numel(rowVec),3*8);
Write0(rowVec,1:3) = expNo(rowVec,:);
Write0(rowVec,4:6) = fileNo(rowVec,:);
Write0(rowVec,7:9) = h4(rowVec,:);
Write0(rowVec,10:12) = Q(rowVec,:);
Write0(rowVec,13:15) = Qb(rowVec,:);
Write0(1:numel(Q_theo),16:18) = Phi_REC.*dims;
Write0(1:numel(Q_theo),19:21) = Phi_RIC.*dims;
Write0(1:numel(Q_theo),22:24) = Phi_SJ.*dims;

targetRange0 = ['B',num2str(startRow),':Y',num2str(readLen+startRow-1)];
xlswrite(targetName0, Write0,...
    1, targetRange0);

targetRange1 = ['B5:M',num2str(5+numel(Q_theo)-1)];
xlswrite(targetName1, [hX_theo, err_REC, err_RIC, err_SJ], ...
    1, targetRange1);

disp('Data successfully processed.');
