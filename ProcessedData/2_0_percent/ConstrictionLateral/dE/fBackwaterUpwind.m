function [ hijUp ] = ...
    fBackwaterUpwind( Q,wij,dw,hijDown,alphaij, dalpha,c,dx, dh)
% Function computes hij and local losses at cross section ij
g = 9.81;
k =1;
eps = 1;
% fit dx due to stability
xMult = 1/dx;
dx = dx*xMult;

AijDown = hijDown*(wij+hijDown/tand(alphaij));
PijDown = wij+2*hijDown/sind(alphaij);
%PijDown = wij+2*hijDown*sqrt(1+1/tand(alphaij));
RhijDown = AijDown/PijDown;
uDown = Q/AijDown;

while eps > 0.001
    dh1 = dh;
    hijUp = hijDown+dh1;
    AijUp = hijUp*(wij+dw+hijUp/tand(alphaij+dalpha));
    PijUp = wij+dw+2*hijUp/sind(alphaij+dalpha);
    %PijUp = wij+dw+2*hijDown*sqrt(1+1/tand(alphaij+dalpha));
    RhijUp = AijUp/PijUp;
    Rhijm = (RhijUp+RhijDown)/2;
    uUp = Q/AijUp;
    um = 0.5*(uUp+uDown);
    du = uDown-uUp;
    
    dh = -um^2/(c^2*Rhijm)*dx-  um/g * du;
    eps = abs(abs(dh1-dh)/dh1);
    k=k+1;
    if k > 10^3
        break;
    end
end


dh = dh/xMult;
hijUp = hijUp+dh;

end



