function [ ck, kst ] = fGetChezy( Data, hi, hj, Q, Jf, i, xlsName, dq, Qb, diff )
% This returns the evaluation of the Chezy coefficient under quasi
% non-uniform flow conditions in the 4 sections between the 5 ultrasonic
% probes
% diff = 0.01;        %[m²/s] exp. diffusion coefficient

% pick up values of upstream boundary
Xi = Data(1,i);

wi = 0.5*(Data(3,i) + Data(4,i));
alphai = 0.5*(Data(5,i) + Data(6,i));

% pick up values of downstream boundary
Xj = Data(1,i+1);

wj = 0.5*(Data(3,i+1) + Data(4,i+1));
alphaj = 0.5*(Data(5,i+1) + Data(6,i+1));

DX = Xj - Xi;   %[m] section length)

DW = wi-wj;  %[m] difference in section base width
Dalpha = alphai-alphaj;  %[m] difference in section bank slope


% set dx according to Peclet Number < 1.5 (Pe = u*dx/diff)

dx = 1.5*diff/2.0;    %[m] u=2.0 highest measured flow velocity
nx = ceil(DX/dx);   %[-] INT, number of subsection



% set initial value of chezy based on shallow water eq. (St Venant)
A_i = hi*(wi+hi/tand(alphai));
P_i = wi+2*hi/sind(alphai);
ck = Q*sqrt(P_i)/A_i^(3/2)/sqrt(Jf(1));

k = 1;
eps = 1;

while eps > .001
    hij = nan(nx,1);
    cwrite = nan(nx,2);
    cwrite(1,:)= [ck(1), Jf(1)];
    epsQ = nan(nx,1);
    hij(1) = hi;
    for j = 2:nx
        wij = wi-j/nx*DW;
        alphaij = alphai-j/nx*Dalpha;
            
        [hij(j), epsQ(j)]=fFindH0(Jf(j), ck(k), hij(j-1), wij, alphaij, Q);
        
        A_ij = hij(j)*(wi+hij(j)/tand(alphaij));
        P_ij = wij+2*hij(j)/sind(alphaij);
        cwrite(j,1) = Q*sqrt(P_ij)/A_ij^(3/2)/sqrt(Jf(j));
        cwrite(j,2) = Jf(j);
    end
    hk(k) = hij(nx);
    ck(k+1)=fEvaldhk(hk,hj,ck, k);
    eps = abs(hj-hij(nx))/hj;
    k = k+1;
    if k > 10^5
        break;
    end
end
if not(Qb)
    if 1 % put 1 here to get error in chezy coefficient (0 = error in h)
        epshij = hj-hij(nx);
        epsQ = epsQ(nx);
        m = 1/tand(alphaj);
        % compute error in chezy coefficient (ref. calulation on hardcover)
        epsC = Q^2/Jf*(epsQ*(wj+hij(nx)*m)-epshij*(wj+3*hij(nx)*m))/...
                (hij(nx)^3*(wj+hij(nx)*m)*(1+4*epshij));
        xlswrite(xlsName,epsC, 3, [char('C'+i-1),num2str(dq+4),':',...
                 char('C'+i-1),num2str(dq+4)]); % accuracy report
    else % activate for writing error in flow depth at section end
        writeData = [hj, hij(nx)];
        xlswrite(xlsName,writeData, 3, [char('H'+3*i-1),num2str(dq+4),':',...
                            char('H'+3*i),num2str(dq+4)]); % accuracy report
    end
end
disp(['---> SECTION ', num2str(i), '-', num2str(i+1), ' finished.'])
if not(Qb)
    cd('cData')
    csvwrite(['c_Q',num2str(Q,'%0.4f'),'sec',num2str(i),num2str(i+1),'.csv'],cwrite);
    cd ..
else
    cd('cDataQb')
    csvwrite(['c_Q',num2str(Q,'%0.4f'),'sec',num2str(i),num2str(i+1),'.csv'],cwrite);
    cd ..
end
ck=ck(k);

wi = wi+0.5*DW;
alphai = alphai+0.5*Dalpha;
Rh = hij(end)*(wi+hij(end)/tand(alphai))/(wi+2*hij(end)/sind(alphai));
kst = ck/Rh^(1/6);
end

