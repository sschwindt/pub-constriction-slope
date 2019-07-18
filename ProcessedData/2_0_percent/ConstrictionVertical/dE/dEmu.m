% February 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script analyzes head losses due to constrictions
%--------------------------------------------------------------------------
clear all;
close all;

plotting = 1;               %[0/1] plotting off=0 / on=1
g = 9.81;


sourceNameGeo = '20160220_sectiondata.xlsx';
sourceRangeGeo = 'D4:I9';% contains geometry data of each cross-section
fileName = '20160229_dEmu_vertical.xlsx';
targetRange = 'N4:O70';

% LOAD DATA ---------------------------------------------------------------
% measurements
Q = xlsread(fileName, 1, 'E4:E70');
Qb_temp = xlsread(fileName, 1,'F4:F70');
h4 = xlsread(fileName, 1,'G4:G70');
h5 = xlsread(fileName, 1,'H4:H70');
a = xlsread(fileName, 1,'I4:I70');
mu = xlsread(fileName, 1,'K4:K70');
Qb = nan(size(Q));
Qb(1:numel(Qb_temp))=Qb_temp;

% section geometry
geoData = xlsread(sourceNameGeo,1,sourceRangeGeo);
w4 = (geoData(3,4) + geoData(4,4))./2;     %[m] section base width
wc = 0.108007185405901;
w5 = (geoData(3,5) + geoData(4,5))./2;     %[m] section base width
alpha4 = (geoData(5,4)+geoData(6,4))/2;   %[deg] section bank slope
alphac = 24.1823071481361;
alpha5 = (geoData(5,5)+geoData(6,5))/2;   %[deg] section bank slope
DX = geoData(1,2:end-1)-geoData(1,1:end-2); %[m] section lengths
dx45 = DX(4);
DZ = geoData(2,1:end-2)-geoData(2,2:end-1); %[m] scetion geodetic change
dz45 = DZ(4);
coeffs =  xlsread(sourceNameGeo,1,'Q15:U16');
coeffsQb =  xlsread(sourceNameGeo,1,'Q18:U19');

% roughness function coefficients
% c - coefficients
a_c = 122.062;
b_c=-48.2962;
c_c=-108.3;
d_c=-87.629;

% COMPUTE -----------------------------------------------------------------
zeta = nan(size(Q));
dE = nan(size(Q));
Qcalc = nan(size(Q));

for i = 1:numel(Q)
    A4 = h4(i)*(w4+h4(i)/tand(alpha4));
    P4 = w4+2*h4(i)/sind(alpha4);
    A5 = h5(i)*(w5+h5(i)/tand(alpha5));
    P5 = w5+2*h5(i)/sind(alpha5);
    Am = 0.5*(A4+A5);
    Rh4 = A4/P4;
    c = a_c*exp(b_c*Q(i))+c_c*exp(d_c*Q(i));
    if isnan(Qb(i))
        zetaQb = 0;
        h4nc = coeffs(1,4)*Q(i)+coeffs(2,4);
        h5nc = coeffs(1,5)*Q(i)+coeffs(2,5);
    else
        zetaQb = 0.031;
        h4nc = coeffsQb(1,4)*Q(i)+coeffsQb(2,4);
        h5nc = coeffsQb(1,5)*Q(i)+coeffsQb(2,5);
    end
    A4nc = h4nc*(w4+h4nc/tand(alpha4));
    P4nc = w4+2*h4nc/sind(alpha4);
    A5nc = h5nc*(w5+h5nc/tand(alpha5));
    P5nc = w5+2*h5nc/sind(alpha5);
    Amnc = 0.5*(A4+A5);
    Rh4nc = A4nc/P4nc;
    H = h4(i)+Q(i)^2/(A4^2*2*g);

    
    b = wc + 2* a(i)/tand(alphac);
    hb = H - a(i);
    Qcalc(i) = mu(i)*sqrt(2*g)*(2/3*wc*(H^(3/2)-hb^(3/2))-...
        2/3*H/(H-hb)*(wc-b)*(H^(3/2)-hb^(3/2))+2/5*(wc-b)/...
        (H-hb)*(H^(5/2)-hb^(5/2)));

    if not(isnan(mu(i)))
        zeta(i) = Qcalc(i)/mu(i)/Q(i);
    end    
end

xlswrite(fileName,[zeta,dE], 1, targetRange);
disp(['Finished, data written to ',fileName,'.']);  