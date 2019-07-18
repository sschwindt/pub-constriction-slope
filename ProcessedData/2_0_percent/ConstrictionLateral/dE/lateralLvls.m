% February 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script analyzes Backwatercurves due to constrictions
%--------------------------------------------------------------------------
clear all;
close all;

plotting = 1;               %[0/1] plotting off=0 / on=1
fontS = 18;

% load necessary functions ------------------------------------------------
fileID = fopen('WriteFiguresFunctionNames.txt');
wffn = textscan(fileID, '%s', 'delimiter','\n'); 
fclose(fileID);
cd('WriteFiguresFunctions')
for i =  1:length(wffn{:})
    fCopyFunction([wffn{1}{i}])
end 
cd ..
% MAIN --------------------------------------------------------------------

% DATA DESCRIPTION
Qb = [0;1];
Q = (5.:0.1:10).*10^(-3);          %[m³/s] pump discharge
plotCheck = 1:5:numel(Q);
sourceName = '20160207_sectiondata.xlsx';
sourceRange = 'D4:I9';% contains geometry data of each cross-section
targetName = '20160211_comp_results.xlsx';
targetRange = ['C5:H',num2str(4+numel(Q))];
targetRangeNC = ['C5:F',num2str(4+numel(Q))];
b = [0.1,0.15,0.17,0.187,0.2, 0.22, 0.234];

for qb = 1:numel(Qb)
    if Qb(qb)
        disp('Computation with bedload.')
    else
        disp('Computation without bedload.')
    end
  
    switch Qb(qb)
        case 0
            hRange = 'D15:H35';	 % contains p1 and p2 values for linear interpolation
            hRangeNC = 'Q15:U16';%  p1, p2 values , non-constricted      
            sheetNo = 1;
        case 1
            hRange = 'I15:M35';       % contains p1 amnd p2 values for linear interpolation
            hRangeNC = 'Q18:U19';%  p1, p2 values , non-constricted
            sheetNo = 2;
    end
    xlswrite(targetName,Q',sheetNo, ['B5:B',num2str(4+numel(Q))]);
    Data = xlsread(sourceName, 1, sourceRange);
    hData = xlsread(sourceName, 1, hRange);
    hDataNC = xlsread(sourceName, 1, hRangeNC);

    % DATA PREPARATION ----------------------------------------------------
    w = (Data(3,:) + Data(4,:))./2;     %[m] section base width
    alpha = (Data(5,:)+Data(6,:))/2;   %[deg] section bank slope
    DX = Data(1,2:end-1)-Data(1,1:end-2); %[m] section lengths
    DZ = Data(2,1:end-2)-Data(2,2:end-1); %[m] scetion geodetic change
    dx = 1.5*0.01/2;
    NX=sum(ceil(DX./dx));
    
    % COMPUTE -------------------------------------------------------------
    GLVL = nan(NX,1);
    WLVL = nan(NX,numel(Q));
    ELVL = nan(size(WLVL));
    FR = nan(size(WLVL));
    WLVLnc = nan(size(WLVL));
    ZETA = nan(numel(Q),numel(b));
    
    bheader = cell(1,1);
    bheader{1,1} = 'Q';
    

    for db = 1:numel(b)
        Qheader = cell(1,1);
        gheader = cell(1,1);
        gheader{1,1}='Bed level';
        cQ = 0;
        hData_b = hData((db-1)*3+1:(db-1)*3+2,:);
        bheader{1,db+1} = ['b = ',num2str(b(db),'%0.3f')];
        for dq = 1:numel(Q)
            Qheader{1,dq} = num2str(Q(dq)*10^3,'%0.1f');
            disp(['Q = ', num2str(Q(dq)*10^3), ' l/s, b = ',...
                                num2str(b(db),'%0.3f'),' m.'])
            if db > 1
                GLVL = storeGLVL;
            end
            h = hData_b(1,:).*Q(dq)+hData_b(2,:);  %[m] flow depth for Q(dq)
            hNC = hDataNC(1,:).*Q(dq)+hDataNC(2,:);%[m] flow depth NC 
            [ GLVL(:), WLVL(:,dq), WLVLnc(:,dq), ELVL(:,dq), ...
                FR(:,dq), ZETA(dq,db) ] = ...
                    fGetdE(h, hNC, w, b(db), alpha, DX, DZ, Q(dq),GLVL(:), Qb(qb));
            cQ = cQ+1;
            if db > 1
                WLVLnc(:,dq) = storeWLVLnc(:,dq);
            end
            % PLOT DATA -------------------------------------------------------
            % plot only for every 0.5 l/s increment...
            if and(plotting, sum(find(plotCheck==cQ,1,'first')) > 0)
                dataName = ['lvl_Q_',num2str(Q(dq),'%0.4f')];
                fPlot(dx*(1:1:sum(NX)),[GLVL(:),WLVL(:,dq),...
                    WLVLnc(:,dq), ELVL(:,dq)],...
                    fontS, dataName, b(db), Q, Qb(qb));
            end
        end
        if db == 1
            storeGLVL = GLVL;
            storeWLVLnc = WLVLnc;
        end
        % WRITE DATA ----------------------------------------------------------
        if Qb(qb)==0
            cd('results_data/Qb_off')
            if db == 1
                csvwrite_with_headers(['gLvl_b',num2str(b(db)*1000),'.csv'],GLVL,gheader)
            end
            csvwrite_with_headers(['eLvl_b',num2str(b(db)*1000),'.csv'],ELVL,Qheader)
            csvwrite_with_headers(['wLvl_b',num2str(b(db)*1000),'.csv'],WLVL,Qheader)
            csvwrite_with_headers(['wLvlNC_b',num2str(b(db)*1000),'.csv'],WLVLnc,Qheader)
            csvwrite_with_headers(['Froude_b',num2str(b(db)*1000),'.csv'],FR,Qheader)
            cd ..\..
        else
            cd('results_data/Qb_on')
            if db == 1
                csvwrite_with_headers(['gLvl_b',num2str(b(db)*1000),'.csv'],GLVL,gheader)
            end
            csvwrite_with_headers(['eLvl_b',num2str(b(db)*1000),'.csv'],ELVL,Qheader)
            csvwrite_with_headers(['wLvl_b',num2str(b(db)*1000),'.csv'],WLVL,Qheader)
            csvwrite_with_headers(['wLvlNC_b',num2str(b(db)*1000),'.csv'],WLVLnc,Qheader)
            csvwrite_with_headers(['Froude_b',num2str(b(db)*1000),'.csv'],FR,Qheader)
            cd ..\..
        end
    end
    % WRITE ZETA ----------------------------------------------------------
    if Qb(qb)==0
        cd('results_data/Qb_off')
        csvwrite_with_headers('zetaIn.csv',[Q',ZETA],bheader)
        cd ..\..
    else
        cd('results_data/Qb_on')
        csvwrite_with_headers('zetaIn.csv',[Q',ZETA],bheader)
        cd ..\..
    end     
end
disp(['Finished, data written to *.csv files.']);  