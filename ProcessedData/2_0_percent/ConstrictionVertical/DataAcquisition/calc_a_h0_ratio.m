% January 2016, Sebastian Schwindt
% EPF Lausanne, LCH

% Script for the computation of the ratio between opening height a and
% 1)    upstream flow depth h0 
% 2)    non-constricted flow depth hNC
%--------------------------------------------------------------------------
clear all;
close all;
sourceName = '20160402_data_vertical.xlsx';
wc = 0.108007185405901;
alphac = 24.1823071481361;

% READ DATA ---------------------------------------------------------------
% get channel bottom slope 
[c, Jf] = fGetcJData(0.005,4,0); % dummy values, only J from interest

% get linear interpolation data of non-constricted flow
ncDataQh =  xlsread(sourceName, 1, 'F4:J5');
ncDataQh_Qb =  xlsread(sourceName, 1, 'F7:J8');

% get measured flow depth of vert. const. experiments
h = xlsread(sourceName, 1, 'F44:J80');
h_Qb = xlsread(sourceName, 1, 'F13:J43');

% get discharges
Q = xlsread(sourceName, 1, 'D44:D80');
Q_Qb = xlsread(sourceName, 1, 'D13:D43');

% get opening height
a = xlsread(sourceName, 1, 'L44:L80');
a_Qb = xlsread(sourceName, 1, 'L13:L43');

a_c = 122.062;
b_c=-48.2962;
c_c=-108.3;
d_c=-87.629;


g=9.81;

% COMPUTE -----------------------------------------------------------------
D90 = 0.014;
Dm = 0.008;
Qb = [0,1];
% get discretization length of Jf computation
dx = 1.5*0.01/2.0;
njConst = 11;      % position of constriction (value from lateral const.)
DX = [0.5920, 0.5480, 0.4210, 0.2740]; % section length
NX = ceil(DX./dx);      %[-]
for qb = 1:numel(Qb)
    switch Qb(qb)
        case 0
            a_h0 = nan(size(Q));
            a_hnc= nan(size(Q));
            for dq = 1:numel(Q)
                
                c = a_c*exp(b_c*Q(dq))+c_c*exp(d_c*Q(dq));
                % non-constricted (a_hnc)
                h4nc = ncDataQh(1,4)*Q(dq)+ncDataQh(2,4);
                h5nc = ncDataQh(1,5)*Q(dq)+ncDataQh(2,5);
                dhnc = h4nc-h5nc;
                hCnc = h4nc-njConst/NX(4)*dhnc;
                A0 = hCnc*(wc+hCnc/tand(alphac));
                P0 = wc+2*hCnc/sind(alphac);
                Rh0 = A0/P0;
                u0 = Q(dq)/A0;                
                H = hCnc+u0^2/(2*g)+dx*u0^2/c^2/Rh0;
                a_hnc(dq) = a(dq)/H;   
                
                % upstream flow depth
                h0 = h(dq,4)+dx*sum(Jf(1:njConst));
                A0 = h0*(wc+h0/tand(alphac));
                P0 = wc+2*h0/sind(alphac);
                Rh0 = A0/P0;
                u0 = Q(dq)/A0;                
                H = h0+u0^2/(2*g)+dx*u0^2/c^2/Rh0;
                a_h0(dq) = a(dq)/H;
            end
            targetRange = 'M44:N80';
        case 1
            a_h0 = nan(size(Q_Qb));
            a_hnc= nan(size(Q_Qb));
            for dq = 1:numel(Q_Qb)
                c = a_c*exp(b_c*Q_Qb(dq))+c_c*exp(d_c*Q_Qb(dq));
                % upstream flow depth
                h0 = h_Qb(dq,4)+dx*sum(Jf(1:njConst));
                A0 = h0*(wc+h0/tand(alphac));
                P0 = wc+2*h0/sind(alphac);
                Rh0 = A0/P0;
                u0 = Q(dq)/A0;                
                H = h0+u0^2/(2*g)+dx*u0^2/c^2/Rh0;
                a_h0(dq) = a_Qb(dq)/H;
                
                % non-constricted (a_hnc)
                h4nc = ncDataQh_Qb(1,4)*Q_Qb(dq)+ncDataQh_Qb(2,4);
                h5nc = ncDataQh_Qb(1,5)*Q_Qb(dq)+ncDataQh_Qb(2,5);
                dhnc = h4nc-h5nc;
                hCnc = h4nc-njConst/NX(4)*dhnc;
                A0 = hCnc*(wc+hCnc/tand(alphac));
                P0 = wc+2*hCnc/sind(alphac);
                Rh0 = A0/P0;
                u0 = Q_Qb(dq)/A0;                
                H = hCnc+u0^2/(2*g)+dx*u0^2/c^2/Rh0;
                
                a_hnc(dq) = a_Qb(dq)/H;                
            end
            targetRange = 'M13:N43';
    end
    % write data
    xlswrite(sourceName,[a_h0, a_hnc], 1, targetRange);
end


disp('Data successfully processed.');
