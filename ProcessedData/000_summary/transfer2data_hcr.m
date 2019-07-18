% September 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script copies values from respective slope and constriction folder into
% data summary file (2-4-6_data.xlsx)
%% VARIABLE DECLARATION ---------------------------------------------------

clear all;
close all;

slope = [2, 4, 6];  % [per cent] tested channel slopes
readLen = 120;      % Dummy value
targetName = '20171002_2-4-6_data_hcr.xlsx';

% preparation of output matrices (2-4-6 %)
rowLen = readLen*3;

Ax    = nan(rowLen, numel(slope));
a     = nan(rowLen, numel(slope));
ah0   = nan(rowLen, numel(slope));
alpha = nan(rowLen, numel(slope));
ax    = nan(rowLen, numel(slope));
b     = nan(rowLen, numel(slope));
bx    = nan(rowLen, numel(slope));
D16x  = nan(rowLen, numel(slope));
D50x  = nan(rowLen, numel(slope));
Dmx   = nan(rowLen, numel(slope));
D84x  = nan(rowLen, numel(slope));
eta   = nan(rowLen, numel(slope));
expNo = nan(rowLen, numel(slope));
Fr    = nan(rowLen, numel(slope));
fileNo= nan(rowLen, numel(slope));
h4    = nan(rowLen, numel(slope));
h5    = nan(rowLen, numel(slope));
hcr   = nan(rowLen, numel(slope));
hcrX  = nan(rowLen, numel(slope));
hx    = nan(rowLen, numel(slope));
mu    = nan(rowLen, numel(slope));
Q     = nan(rowLen, numel(slope));
taux  = nan(rowLen, numel(slope));
theta = nan(rowLen, numel(slope));
zeta  = nan(rowLen, numel(slope));

% folder and file names
const_folder = {'ConstrictionCombined', 'ConstrictionLateral', ...
                    'ConstrictionVertical'};
const_files = {'_data_combined', '_data_lateral', '_data_vertical'};

%              combined    lateral     vertical
file_dates = {'20160402', '20160405', '20160402'; ... % 2 per cent
                '20160425', '20160421', '20160422'; ... % 4 per cent
                    '20160707', '20160707', '20160706'};  % 6 per cent

rowN = nan(3,3);    % stores No. of experiments in each file

%       1 2   3   4   5  6  7   8   9 10  11  12  13 14 15  16  17 18
%       e f ah0, ax, bx,hx,Fr,zet,alp,mu,tau,eta,the,h4,h5,  a   b  Q
colN = [1,2, 14, 15, 16,21,20, 26,nan,28, 22, 23, 19, 8, 9, 11, 12, 3; ... % 2p comb
        1,2,nan,nan, 11,15,14, 20, 12,22, 16, 17, 13, 8, 9,nan, 10, 3; ... % 2p lat
        1,2, 12, 13,nan,17,16, 21,nan,14, 18, 19, 15, 8, 9, 11,nan, 3; ... % 2p vert
        1,2, 13, 14, 15,19,18, 24,nan,26, 20, 21, 17, 8, 9, 11, 12, 3; ... % 4p comb
        1,2,nan,nan, 11,15,14, 20, 12,22, 16, 17, 13, 8, 9,nan, 10, 3; ... % 4p lat
        1,2, 12, 13,nan,17,16, 21,nan,19, 18, 14, 15, 8, 9, 11,nan, 3; ... % 4p vert
        1,2, 13, 14, 15,19,18, 24,nan,26, 20, 21, 17, 8, 9, 11, 12, 3; ... % 6p comb
        1,2,nan,nan, 11,15,14, 20, 12,22, 16, 17, 13, 8, 9,nan, 10, 3; ... % 6p lat
        1,2, 12, 13,nan,17,16, 21,nan,19, 18, 14, 15, 8, 9, 11,nan, 3; ... % 6p vert
        ];
D90 = 0.01478;
D84 = 0.01368;
Dm  = 0.00938; 
D50 = 0.00965;
D30 = 0.00423;
D16 = 0.00727;
g = 9.81;
fCopyFunction('fGethcr.m')

%% READ DATA --------------------------------------------------------------
cd ..\..
for s = 1:numel(slope)
    cd([num2str(slope(s)),'perCent'])
    switch s
        case 1
            Jf = 0.020433;
            w_geo = 0.111;
            alpha_geo = 0.5*(24.51525627+24.73653666);
            % set interpolation parameters for nan values of h4 probe
            p1 = 2.375;
            p2 = 0.03237;
            dz45 = 0.004;
            % chezy
            a_c = 122.062;
            b_c=-48.2962;
            c_c=-108.3;
            d_c=-87.629;
        case 2
            Jf = 0.034772;
            w_geo = 0.5*(0.085066638+0.099039895);
            alpha_geo = 0.5*(22.64513793+24.99056711);
            % set interpolation parameters for nan values of h4 probe
            p1 = 2.4372593174459;
            p2 = 0.0231639367681246;
            dz45 = 0.0129;
            % chezy
            a_c = -0.00396922789729619;
            b_c = -1.47621496194006;
            c_c = 36.1006979386107;
        case 3
            Jf = 0.055021;
            w_geo = 0.5*(0.0822632278295273+0.10656594817979);
            alpha_geo = 0.5*(23.1253549056903+25.7942975891345);
            % set interpolation parameters for nan values of h4 probe
            p1 = 2.42326708705156;
            p2 = 0.0200518926402256;
            dz45 = 0.0187;
            % chezy
            a_c = -1.24019995440512*10^-9;
            b_c = -4.11609949701863;
            c_c = 35.0398976030953;
    end
    m_geo = 1/tand(alpha_geo);
    for cType = 1:3
        cd([const_folder{cType},'\DataAcquisition'])
        
        % read file
        fileN = [file_dates{s,cType},const_files{cType},'.xlsx'];
        disp(['Reading ', num2str(slope(s)),'%, ', fileN, ' ...']);
        fileData = nan(readLen, 30); % covers field B13:AE13+readLen
        tempData = xlsread(fileN, 1, ['B13:AC',num2str(readLen+13)]);
        rowN(cType,s) = numel(tempData(:,1));
        
        % write data to output matrices
        startRow = readLen*(cType-1)+1;
        rCN = (s-1)*3+cType;
        rr = startRow:startRow+rowN(cType,s)-1;
        
        expNo(rr,s) = tempData(:,1);
        fileNo(rr,s) = tempData(:,2);
        
        % read measurements
        if not(isnan(colN(rCN,3)))
            a(rr,s) = tempData(:,colN(rCN,16));
            ah0(rr,s)=tempData(:,colN(rCN,3));
            ax(rr,s)=tempData(:,colN(rCN,4));
        end
        if not(isnan(colN(rCN,5)))
            b(rr,s) = tempData(:,colN(rCN,17));
            bx(rr,s)=tempData(:,colN(rCN,5));
        end

        
        eta(rr,s) = tempData(:,colN(rCN,12));
        Fr(rr,s) = tempData(:,colN(rCN,7));
        h4(rr,s) = tempData(:,colN(rCN,14));
        hx(rr,s) = tempData(:,colN(rCN,6));
        Q(rr,s) = tempData(:,colN(rCN,18));
        mu(rr,s) = tempData(:,colN(rCN,10));
        taux(rr,s) = tempData(:,colN(rCN,11));
        theta(rr,s) = tempData(:,colN(rCN,13));
        zeta(rr,s) = tempData(:,colN(rCN,8));
        
        if isnan(colN(rCN,4))
            % compute discharge capacity according to energy balance and 
            % replace alpha
            for iq = rr

                A0 = h4(iq,s)*(w_geo+h4(iq,s)*m_geo);

                hcr_t = fGethcr(90, Q(iq,s), b(iq,s));
                hx_t = hcr_t/h4(iq,s);
                Acr = hcr_t*b(iq,s);%(w_geo+hcr_t*m_geo);

                Lw = 2*0.03; % experimentally found drawdown length (until contraction end)
                zeta_r = 2.6*10^-5*Q(iq,s)^-1.67+0.945; % from zeta_r.xlsx in folder Roughness
                hf = 0; % if not: zeta_r*Lw*(Q(iq,s)/A0)^2/(2*g);
                
                dh = -h4(iq,s)+1.5*hcr_t;
                fj = -100/2;
                
                if hx_t < 2
                    Q_calc = A0*sqrt(2*g*(dh+hf-fj*Jf*Lw));
                    alpha(iq,s) = Q(iq,s)/Q_calc;
                end
            end
        end
        
        for iq = rr
            hcr_t = fGethcr(alpha_geo, Q(iq,s), w_geo);
            D16x(iq,s) = D16/hcr_t;
            D50x(iq,s) = D50/hcr_t;
            Dmx(iq,s) = Dm/hcr_t;
            D84x(iq,s) = D84/hcr_t;
        end
        
        % compute Ax
        if and(not(isnan(a(startRow+1,s))), isnan(b(startRow+1,s)))
            % vertical flow constriction
            P = 2*w_geo+2*a(rr,s).*(1/sind(alpha_geo)+m_geo);
            Ax(rr,s) = a(rr,s).*(w_geo+a(rr,s).*m_geo);
        end
        if and(isnan(a(startRow,s)), not(isnan(b(startRow,s))))
            % lateral flow constriction
            P = nan(numel(rr),1);
            cc = 0;
            for ib = rr
                cc = cc+1;
                if b(ib,s) <= w_geo
                    % rectangular
                    P(cc) = 2*(h4(ib,s)+b(ib,s));
                    Ax(ib,s) = h4(ib,s)*b(ib,s);
                else
                    % trapezoidal bottom + rectangular top
                    P(cc) = w_geo+(b(ib,s)-w_geo)./cosd(alpha_geo)+2.*(h4(ib,s)-(b(ib,s)-w_geo)./(2*m_geo));
                    Ax(ib,s) = b(ib,s)*(h4(ib,s)-...
                                (b(ib,s)-w_geo)/(2*m_geo)+ ...
                                    (b(ib,s)^2-w_geo^2)/(4*m_geo));
                end
            end            
        end
        if and(not(isnan(a(startRow,s))), not(isnan(b(startRow,s))))
            % combined flow constriction
            P = nan(numel(rr),1);
            cc = 0;
            for ib = rr
                cc = cc+1;
                if b(ib,s) <= w_geo
                    % rectangular
                    P(cc) = 2*(a(ib,s)+b(ib,s));
                    Ax(ib,s) = a(ib,s)*b(ib,s);
                else
                    % trapezoidal bottom + rectangular top
                    P(cc) = w_geo+(b(ib,s)-w_geo)/cosd(alpha_geo)+2*(a(ib,s)-(b(ib,s)-w_geo)/(2*m_geo))+b(ib,s);
                    Ax(ib,s) = b(ib,s)*(a(ib,s)-...
                                (b(ib,s)-w_geo)/(2*m_geo)+ ...
                                    (b(ib,s)^2-w_geo^2)/(4*m_geo));
                end
            end
        end
        Ax(rr,s) = Ax(rr,s)./P;
        clear P
        cd ..\..
    end
    
    hcr(:,s) = fGethcr(alpha_geo, Q(:,s), w_geo);
    Ax(:,s) = Ax(:,s)./hcr(:,s);
    wcr = w_geo+2.*hcr(:,s).*m_geo;
    ax(:,s) = a(:,s)./hcr(:,s);
    bx(:,s) = b(:,s)./hcr(:,s)*Jf;
    A_geo  = h4(:,s).*(w_geo+h4(:,s).*m_geo);
    A_cr  = hcr(:,s).*(w_geo+hcr(:,s).*m_geo);
    Rh = A_geo./(w_geo+2.*h4(:,s)./sind(alpha_geo));
    Rh_cr = A_cr./(w_geo+2.*hcr(:,s)./sind(alpha_geo));
    
    
    
    
    hcrX(:,s) = (h4(:,s)./hcr(:,s)).^-1;
    cd ..
end
cd('2-4-6-summary\Data') 

%% WRITE DATA -------------------------------------------------------------
startRow = 5;
dataStartRow = 1;
for cType = 1:3
    targetRange = ['B',num2str(startRow),':AN',num2str(readLen+startRow-1)];
    % write hydraulics + bed load
    xlswrite(targetName, [expNo(dataStartRow:dataStartRow+readLen-1,:), ...
                          fileNo(dataStartRow:dataStartRow+readLen-1,:),...
                          ah0(dataStartRow:dataStartRow+readLen-1,:), ...
                          ax(dataStartRow:dataStartRow+readLen-1,:), ...
                          bx(dataStartRow:dataStartRow+readLen-1,:), ...
                          hx(dataStartRow:dataStartRow+readLen-1,:), ...
                          hcrX(dataStartRow:dataStartRow+readLen-1,:), ...
                          zeta(dataStartRow:dataStartRow+readLen-1,:), ...
                          alpha(dataStartRow:dataStartRow+readLen-1,:), ...
                          mu(dataStartRow:dataStartRow+readLen-1,:), ...
                          taux(dataStartRow:dataStartRow+readLen-1,:), ...
                          eta(dataStartRow:dataStartRow+readLen-1,:), ...
                          theta(dataStartRow:dataStartRow+readLen-1,:)],...
                          1, targetRange);
%     % write dim.less grain sizes ->> SHIFTED TO transfer2data_Dx.m !
%     xlswrite('20161018_2-4-6_Dx.xlsx', [expNo(dataStartRow:dataStartRow+readLen-1,:), ...
%                           fileNo(dataStartRow:dataStartRow+readLen-1,:),...
%                           D84x(dataStartRow:dataStartRow+readLen-1,:), ...
%                           Dmx(dataStartRow:dataStartRow+readLen-1,:), ...
%                           D50x(dataStartRow:dataStartRow+readLen-1,:), ...
%                           D16x(dataStartRow:dataStartRow+readLen-1,:), ...
%                           hcrX(dataStartRow:dataStartRow+readLen-1,:),...
%                           theta(dataStartRow:dataStartRow+readLen-1,:)],...
%                           2, ['B',num2str(startRow),':Y',num2str(readLen+startRow-1)]);
    startRow = startRow+readLen+5;
    dataStartRow = dataStartRow+readLen;
end

disp(['Data written to ', targetName]);

% load handel
% sound(y,Fs)