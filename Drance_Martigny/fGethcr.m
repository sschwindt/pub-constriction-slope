function [ hcri ] = fGethcr(alphai, Qi, wi)
% Function computes critical flow depth of trapezoidal channels

% definition of analysis consideration
% alpha = bank slope [deg]
% Q = dischare [m³/s]
% w = base width [m]


%% DATA AND VARIABLE PREPARATION ------------------------------------------

m = 1/tand(alphai);
g = 9.81;  
hcri = nan(size(Qi));
%% COMPUTATION ------------------------------------------------------------


for i = 1:numel(Qi)
   count = 0;
   eps = 1;
   ycr = 0.00;%Q(i)^2/g;
   while eps > 10^-3
       ycr = ycr+0.00001;
       %ycr_it = (g*(w*ycr+ycr^2/m)^3-Q(i)^2*w)/(2*m*Q(i));
       Q_it = sqrt(g*(wi*ycr+m*ycr^2)^3/(wi+2*m*ycr));
       %eps = abs(abs(ycr_it-ycr)/ycr);
       eps = abs(Q_it-Qi(i))/Qi(i);
       count = count+1;
       if count > 10^6
           disp('Iteration break for critical flow depth.')
           ycr = nan;
           break;
       end
   end
   if not(isnan(Qi(i)))
       hcri(i) = ycr;
   end
end



