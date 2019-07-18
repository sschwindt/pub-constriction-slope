% September 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Reads Drance measurements and evaluated discharge capacity
%%
clear all;
close all;
sourceName = '20160927_data.xlsx';
tabNo = 1; % 1 = classic, 2 = Voigt 72

%% READ DATA

type = xlsread(sourceName, tabNo, 'A4:A29'); % 0 = free surface // 1 = pressure
spill = xlsread(sourceName, tabNo, 'B4:B29');
pile = xlsread(sourceName, tabNo, 'C4:C29');
Q = xlsread(sourceName, tabNo, 'D4:D29');
h0 = xlsread(sourceName, tabNo, 'G4:G29');

% other
a = 2.5/42;    %[m] orifice height
b = 4.0/42;    %[m] orifice width
g = 9.81;   %[m/s²]
I = 0.024;  %[-] bottom slope
%kst = 20;   %[m''³/s]
w = 11.7/42;   %[m] channel bottom width
alphai = 45;%[deg] bank slope
m = 1/tand(alphai);%[-]
L = 5.0/42;
fcr = -100/2;
%% COMPUTE 
hnc = nan(size(Q));
hcr = nan(size(Q));
hcr_s = nan(size(Q));
dH0  = nan(size(Q));
H0  = nan(size(Q));
hx  = nan(size(Q));
Cc = nan(size(Q));
mu = nan(size(Q));
Qc = nan(size(Q));
Qspill = nan(size(Q));
Fr = nan(size(Q));
wm = nan(size(Q));
errSpill = zeros(size(Q));

Q = Q.*10^-3; %conversion to m³/s

% spillway characteristics
Cd_p = 0.05; % pile
Cd_s = 0.0; % side walls
b_p = 4/42;
b_tot = 24/42;

for i = 1:numel(Q)
    %hnc(i) = fFindH0(J,kst,w,alphai,Q(i));
    hcr(i) = fGethcr(alphai,Q(i),w); % us cr flow depth
    hx(i) = hcr(i)/h0(i);
    if hx(i) < 1
        Cc(i) = hx(i)-0.29;
        mu(i) = 0.25*hx(i)+0.46;
    else
        Cc(i) = hx(i)-0.29;
    end
    A0 = h0(i)*(w+h0(i)/tand(alphai));
    wm(i) = w+h0(i)/tand(alphai);
    Fr(i) = Q(i)*sqrt(w+2*h0(i)/tand(alphai))/A0^1.5/sqrt(g);
    switch type(i)
        case 0
            hcr_s(i) = fGethcr(90,Q(i),b); % critical flow depth in slit
            Qc(i) = Cc(i)*A0*sqrt(2*g*(1.5*hcr_s(i)-h0(i)-fcr*I*L));
            mu(i) = nan;
        case 1
            u0 = Q(i)/A0;
            H0(i) = h0(i)+u0^2/(2*g);
            Qc(i) = 2/3 *mu(i)*b*sqrt(2*g)*(H0(i)^1.5-(H0(i)-a)^1.5);
            dH0(i)=H0(i)-h0(i);
            Cc(i)=nan;
    end
    if spill(i)
        dH_s = H0(i)-4.8/42; % diff spillway to channel
        if pile(i)
            b_eff = b_tot - b_p -(Cd_p+Cd_s)*dH_s;
            errSpill(i) = 0.03/1000;
        else
            b_eff = b_tot - Cd_s*dH_s;
            errSpill(i) = 0.012/1000;
        end
        H_Hd = dH_s/(dH_s+0.5);
        Cd = 0.494*H_Hd^0.12;
        Qspill(i) = Cd*b_eff*sqrt(2*g)*dH_s^1.5;
    end
end
errQcLat = fGetErrQlat(Cc,fcr,g,h0,hcr_s,I,L,m,Q,w,wm,type);
errQcVert = fGetErrQvert(a,b,g,H0,mu,type);
err = 10^3.*(errSpill + errQcLat + errQcVert); % sum & scale errors
Qc = Qc*10^3; % reconversion to l/s
xlswrite(sourceName,[hx,Cc,mu,Qc],tabNo,'H4:K29'); % orifice
xlswrite(sourceName,Qspill*10^3,tabNo,'E4:E29'); % spillways
xlswrite(sourceName,err,tabNo,'M4:M29'); % propagated error

disp('Data processed.');


