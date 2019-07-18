function [ amean, Ainterp ] = fGeta_comb( ames, b )
% This returns the mean opening height based on a measured value 
% Function must be called in the Matlab Folder
% ames =  measured maximum opening height [m]
% b = opening width [m] --> 0=no lateral constriction
alphac = 24.1823071481361;  %[deg] channel bank slope at constriction
wc = 0.108007185405901;     %[m] channel base width at constriction


% LOAD CAD DATA -----------------------------------------------------------
fileName = ['aAmesb',num2str(b*10^3,'%03i'),'.txt']; % aAmesbXXX.txt
cd('ChannelGeometry');
data = load(fileName);
aIntv = data(:,1); %[m]
AIntv = data(:,2); %[m²]
cd ..

% INTERPOLATE EXACT MEASURED SURFACE (FROM CAD DATA) ----------------------
Ainterp = interp1(aIntv,AIntv,ames);  %[m²]

% COMPUTE MEAN OPENING HEIGHT USING GEOMETRY SUBSITUTION ------------------
if b > wc
    wcc = b;
else 
    wcc =wc;
end
a1 = 0.5*(b-wcc)*tand(alphac);
a2 = 1/b*(Ainterp-0.25*(b^2-wcc^2)*tand(alphac));

amean = a1+a2;

end

