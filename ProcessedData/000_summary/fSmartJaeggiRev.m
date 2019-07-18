function[taxcr,extr] = fSmartJaeggiRev(D,D30,D90,h,S0,m,w0,Q, Qb,Chezy)
% November 2017
% function computes dimls critical bed shear stress using SMART/JAEGGI formula
% Computes bed load for trapezoidal bed shapes
% VALIDITY DOMAIN (checked by function)
% ++ Dm > 0.4 [mm] 
% ++ D90/D30 > 8.5 
% ++ 0.2 < J < 20 [%] 
% 
% INPUT:    D [m] SCALAR Representative grain size
%           h [m] VECTOR flow depth
%           S0[-] SCALAR channel slope
%           m [-] SCALAR bank slope (1/tand(alpha))
%           w0[m] SCALAR channel base width
%
% OUTPUT: Phi [-] Dimensionless bedload (as defined by Einstein, 1950)
%
% Script requires function fGetQ.m
%
%% CONSTANTS
g = 9.81;               %[m/s²]
rhos = 2680;            %[kg/m³] densite sediment
rhof = 1000;            %[kg/m³] densite fluide
s = rhos/rhof;          %[-] densite relative
pkg load io

%% CONTROL VALIDITY
if or(S0 < 0.002,S0 > 0.2)
    disp('Warning: Channel slope out of validity range.')
end
if D < 0.4*10^-3
    disp('Warning: Grain size too small.')
end
if D90/D30 > 8.5
    disp('Warning: Grain size distribution too wide.')
end



%% Hydraulics
wm = w0+h.*m;
A_tot = h.*(wm);
u = Q./A_tot;
%hezy = u./(g.*h.*S0).^0.5;
tax = h.*S0./((s-1)*D);
Phi = Qb./(wm.*sqrt((s-1)*g*D^3))./rhos;

taxcr = tax - Phi.*sqrt(g) ./ (4*(D90/D30)^0.2*S0^0.6 .*Chezy .*tax.^0.5);

extr = tax;