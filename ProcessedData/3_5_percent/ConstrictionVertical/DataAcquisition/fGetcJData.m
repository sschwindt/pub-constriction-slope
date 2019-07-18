function [ c, Jf ] = fGetcJData( Q, i, Qb )
% Function loads c coefficients for distinct discharges and channel
% sections based on non-constricted chezy scriptum

% REQUIREMENT: 
% Peclet Number < 1.5 (Pe = u*dx/diff)
% dx = 1.5*diff/2.0;  %[m] u=2.0 highest measured flow velocity
% nx = ceil(DX/dx);   %[-] INT, number of subsection

% returns c(size nx*1) and Jf (size nx*1)

if Qb==0
    cd ..\..
    cd('NonConstricted/ChezySectionwise/cData')
    data = csvread(['c_Q',num2str(Q,'%0.4f'),'sec',num2str(i),num2str(i+1),'.csv']);
    c = data(:,1);
    Jf = data(:,2);
    cd ..\..\..
    cd('ConstrictionLateral/DataAcquisition')
else
    cd ..\..
    cd('NonConstricted/ChezySectionwise/cDataQb')
    data = csvread(['c_Q',num2str(Q,'%0.4f'),'sec',num2str(i),num2str(i+1),'.csv']);
    c = data(:,1);
    Jf = data(:,2);
    cd ..\..\..
    cd('ConstrictionLateral/DataAcquisition')
end
end



