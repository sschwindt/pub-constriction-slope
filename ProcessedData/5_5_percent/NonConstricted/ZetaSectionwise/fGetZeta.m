function [ zeta ] = fGetZeta( Data, hi, hj, c, Jf, i  )
% This returns the evaluation of the Chezy coefficient under quasi
% non-uniform flow conditions in the 4 sections between the 5 ultrasonic
% probes
g=9.81;
% pick up values of upstream boundary
Xi = Data(1,i);
zi = Data(2,i);
wi = 0.5*(Data(3,i) + Data(4,i));
alphai = 0.5*(Data(5,i) + Data(6,i));

% pick up values of downstream boundary
Xj = Data(1,i+1);
zj = Data(2,i+1);
wj = 0.5*(Data(3,i+1) + Data(4,i+1));
alphaj = 0.5*(Data(5,i+1) + Data(6,i+1));


DX = Xj - Xi;   %[m] section length)
DZ = zi - zj;   %[m] geodetic difference in section
DW = wi-wj;     %[m] difference in section base width
DH = hi-hj;     %[m] difference of flow depth between sections
Dalpha = alphai-alphaj;  %[m] difference in section bank slope


% set dx according to Peclet Number < 2 (Pe = u*dx/diff)
diff = 0.01;        %[m²/s] exp. diffusion coefficient
dx = 1.5*diff/2.0;    %[m] u=2.0 highest measured flow velocity
nx = ceil(DX/dx);   %[-] INT, number of subsection

% set initial value of chezy based on shallow water eq. (St Venant)
Ai0 = hi*(wi+hi/tand(alphai));
Pi0 = wi+2*hi/tand(alphai);


zetaij = nan(nx,1);
for j = 1:nx
    wij = wi-j/nx*DW;
    dhij = j/nx*DH;
    hij = hi-dhij;
    dzij = j/nx*DZ;
    alphaij = alphai-j/nx*Dalpha;
    

    Aij = hij*(wij+hij/tand(alphaij));
    Pij = wij+2*hij/sind(alphaij);
    
    zetaij(j) = 1+2*g*(dzij+dhij)*Pi0/(c(j)^2*Ai0*Jf(j))-Aij*Pi0/(Ai0*Pij);

    Ai0 = Aij;
    Pi0 = Pij;    
end
zeta = mean(zetaij);
%zeta=zetaij(end);
end

