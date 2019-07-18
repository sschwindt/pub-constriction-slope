% February 2016, SEBASTIAN SCHWINDT
% EPF Lausanne, LCH

% Script outputs dimensionless critical shear stress at the constriction,
% based on US 4 flow depth
%--------------------------------------------------------------------------
clear all;
close all;

g = 9.81;       %[m/s²]
Dmax = 0.021;   %[m]
s = 2.68;       %[m]


w4 = 0.1387;
alpha4 = 23.7858;
sourceName = '20160128_Qh_undisturbed.xlsx';

sourceRangeQ = 'D13:D46';
sourceRangeM = 'R4:R27';
%sourceRangeUj = 'G9:G32';
%targetRange = 'B4:F4';

% READ INPUT --------------------------------------------------------------
Q = xlsread(sourceName, 1, sourceRangeQ);
c = nan(size(Q));
tauXc = nan(size(Q));
coeffs = xlsread(sourceName, 1, 'I7:I8');
% h = nan(size(Q));
% h_temp = xlsread(sourceName, 1, 'I13:I46');
% h(3:numel(h_temp)+2) = h_temp;
%uj = xlsread(sourceName, 1, sourceRangeUj);
h = coeffs(1).*Q+coeffs(2);

for i = 1:numel(Q)
    if Q(i) > 0.01
        tauXc(i) = nan;
    else
        [c, Jf_temp] = fGetcJData(Q(i), 4, 1);
        
        a_c = 122.062;
        b_c=-48.2962;
        c_c=-108.3;
        d_c=-87.629;
        c = a_c*exp(b_c*Q(i))+c_c*exp(d_c*Q(i));

        A = h(i)*(w4+h(i)/tand(alpha4));
        tauXc(i) = Q(i)^2/(A^2*c(1)^2*(s-1)*Dmax);  
    end
end
%rU = ui./uj;
% output = nan(1,3);
cftool(Q,tauXc);

% [xData, yData] = prepareCurveData(data(:,1),data(:,2+i));
% 
% % Set up fittype and options
% ft = fittype( 'a*x^b', 'independent', 'x', 'dependent', 'y' );
% opts = fitoptions( ft );
% opts.Display = 'Off';
% opts.Lower = [-Inf -Inf];
% opts.StartPoint = [1 1];
% opts.Upper = [Inf Inf];
% 
% % Fit model to data
% [fitresult, gof] = fit( xData, yData, ft, opts );
% output(:,i) = [fitresult.a; fitresult.b; gof.rsquare];
% 
% 
% % Write to file
% xlswrite(sourceName, output, 1, targetRange);
% disp(['Results of Q-h fitting written to file.']);
