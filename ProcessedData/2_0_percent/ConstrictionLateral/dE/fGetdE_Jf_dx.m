function [ gLvl, wLvl, wLvlNC, egl, Fr, zetaIn ] = ...
                        fGetdE( h, hNC, w, b, alpha, DX, DZ, Q, gLvl, Qb )
% Function returns values along the channel of:
% bed level     (gLvl)  [m]
% water level   (wLvl)  [m]
% energy level  (egl)   [m]
% Froude number (Fr)    [-]
% and the number of discretization steps NX


% ASSIGN VARIABLES --------------------------------------------------------
g = 9.81;


% set dx according to Peclet Number < 2 (Pe = u*dx/diff)
diff = 0.01;            %[m²/s] exp. diffusion coefficient
dx = 1.5*diff/2.0;      %[m] u=2.0 highest measured flow velocity

NX = ceil(DX./dx);      %[-]
hijNC = nan(size(gLvl));  %[m] water depth non-constricted
wLvl = nan(size(gLvl)); %[m]
hij = nan(size(gLvl));  %[m] water depth 
%wLvlNC =nan(size(gLvl));%[m] non-constricted
egl = nan(size(gLvl));  %[m]
Fr = nan(size(gLvl));   %[m]
constPos = 0.194;       %[m] start of the constriction (upstream of US5)
Nconst = ceil(0.03/dx); %[-] No. of elements along the constriction
njConst = ceil((DX(4)-constPos)/dx);

Jfm = mean(DZ./DX);


% LEVEL UPSTREAM OF CONSTRICTION ------------------------------------------
% COMPUTATION IN SUPERCRITICAL --------------------------------------------
% prepare updates of channel sections
A = h.*(w(1:5)+h./tand(alpha(1:5)));
dw = w(1:end-2)-w(2:end-1);            %[m] section base width change
dalpha = alpha(1:end-2)-alpha(2:end-1);%[deg] section bank slope
dh = (h(1:end-1)-h(2:end))./NX;
[c, Jf] = fGetcData(Q, 4, Qb);
dh(4) = -dx*mean(Jf(1:njConst));
dhNC = (hNC(1:end-1)-hNC(2:end))./NX;
iCrit=1;


gLvl(1) = sum(DZ);
hijIni = h(1);
startUpwind = 0;
for i = 1:4
    jStart = sum(NX(1:i))-NX(i)+1;
    [c, Jf] = fGetcData(Q, i, Qb);

    if not(startUpwind)
        hij(jStart) = hijIni;
        wLvl(jStart) = gLvl(jStart)+hij(jStart);
        A_ini = hij(jStart)*(w(i)+hij(jStart)/tand(alpha(i)));
        Rh_ini = A_ini/(w(i)+hij(jStart)/sind(alpha(i)));
        egl(jStart) = wLvl(jStart)+(Q/A_ini)^2*(dx/c(1)^2/Rh_ini+1/(2*g));
    end
    if not(i==1)
        gLvl(jStart) = gLvl(jStart-1)-dx*Jf(1);
    end
    Fr(jStart) = Q/(A(i)*sqrt(g*h(i)));
    if i < 4
        FrDown = Q/(A(i+1)*sqrt(g*h(i+1)));
    else
        FrDown = 0;
    end
    if b == 0.1
        hijNC(jStart) = hNC(i);
        
        for j = 2:NX(i)
            ijPos = sum(NX(1:i))-NX(i)+j;
            hijNC(ijPos) = hijNC(ijPos-1)-dhNC(i);
            gLvl(ijPos) = gLvl(ijPos-1)-dx*Jf(j);
        end

        
        disp(['Finished non-constricted in section ', num2str(i),'-',...
            num2str(i+1),' (Q=',num2str(Q*10^3,'%0.1f'), 'l/s).']);
    else 
        for j = 2:NX(i)
            ijPos = sum(NX(1:i))-NX(i)+j;
            gLvl(ijPos) = gLvl(ijPos-1)-dx*Jf(j);
        end
    end

    % check if flow is subcritical --> activate upwind 
    if and(Fr(jStart) > 1,FrDown > 1)
        for j = 2:NX(i)
            ijPos = sum(NX(1:i))-NX(i)+j;
            wij = w(i)-j/NX(i)*dw(i);
            alphaij = alpha(i)-j/NX(i)*dalpha(i);
            if i == 4
                dh(4) = 0;
            end
            hij(ijPos) =  hij(ijPos-1)-dh(i);
            Aij = hij(ijPos)*(wij+hij(ijPos)/tand(alphaij));
            Rhij = Aij / (wij+2*hij(ijPos)/sind(alphaij));
            wLvl(ijPos) = gLvl(ijPos)+hij(ijPos);
            egl(ijPos) = wLvl(ijPos)+(Q/Aij)^2*(dx/c(j)^2/Rhij+1/(2*g));
            Fr(ijPos) = Q/(Aij*sqrt(g*hij(ijPos)));
            hijIni = h(i+1);
        end
        startUpwind = 0;
    end
    if and(Fr(jStart) > 1,FrDown < 1)
        for j = 2:NX(i)
            ijPos = sum(NX(1:i))-NX(i)+j;
            wij = w(i)-j/NX(i)*dw(i);
            alphaij = alpha(i)-j/NX(i)*dalpha(i);
            hij(ijPos) = hij(jStart);
            Aij = hij(ijPos)*(wij+hij(ijPos)/tand(alphaij));
            Rhij = Aij / (wij+2*hij(ijPos)/sind(alphaij));
            wLvl(ijPos) = gLvl(ijPos)+hij(ijPos);
            egl(ijPos) = wLvl(ijPos)+(Q/Aij)^2*(dx/c(j)^2/Rhij+1/(2*g));
            Fr(ijPos) = Q/(Aij*sqrt(g*hij(ijPos)));
            hijIni = h(i+1);
        end
        startUpwind = 1;   
        iCrit = i;
    end
    if and(Fr(jStart) < 1,FrDown < 1)
        if not(startUpwind)
            if i > 1
                iCrit = i-1;
            else
                iCrit = 1;
            end
        end
        hijIni = nan;
        startUpwind = 1;   
    end
end

% COMPUTATION IN SUBCRITICAL UPSTREAM OF CONSTRICTION ---------------------
if startUpwind
    disp(['Hydraulic jump in section ', num2str(iCrit(1)),...
            ' --> upwind calculation activated.'])
    
    hijIni = h(4)-dh(4)*(njConst);

    stopIteration = 0;
    stopIterationFr = 0;

    % levels upstream of the constriction ---------------------------------
    for i = 4:-1:iCrit
        [c, Jf] = fGetcData(Q, i, Qb);
        % set initial values
        if i == 4
            nj = njConst;
            dw(4) = (w(4)-w(6))/nj;
            dalpha(4) = (alpha(4)-alpha(6))/nj;
        else
            nj = NX(i);
        end
        
        jDown = sum(NX(1:i-1))+nj;
        hijDownwind = hij(sum(NX(1:i))-NX(i)+1:sum(NX(1:i))-NX(i)+nj);
        hij(jDown) = hijIni;

        w_ini = w(i)-nj/NX(i)*dw(i);
        alpha_ini = alpha(i)-nj/NX(i)*dalpha(i);
        A_ini = hij(jDown)*(w_ini+hij(jDown)/tand(alpha_ini));
        Rh_ini = A_ini/(w_ini+2*hij(jDown)/sind(alpha_ini));
        wLvl(jDown) = gLvl(jDown) + hij(jDown);
        
        egl(jDown) = wLvl(jDown)+(Q/A_ini)^2*(dx/c(nj)^2/Rh_ini+1/(2*g));
        Fr(jDown) = Q/(A_ini*sqrt(g*hij(jDown)));
        
        
        for j = nj-1:-1:1
            wij = w(i)-(j-1)/NX(i)*dw(i);
            alphaij = alpha(i)-(j-1)/NX(i)*dalpha(i);
            
            ijPos = sum(NX(1:i))-NX(i)+j;
            if i > iCrit
                hij(ijPos) = hij(ijPos+1)+dh(i);
                Aij = hij(ijPos)*(wij+hij(ijPos)/tand(alphaij));
                Rhij = Aij/(wij+2*hij(ijPos)/sind(alphaij));
            else
                if not(or(stopIteration,stopIterationFr))
                    %jStartC = sum(NX(1:3))+njConst;
                    hij(ijPos) = fBackwaterUpwind(Q,wij,dw(i),...
                        hij(ijPos+1), alphaij, dalpha(i), c(j+1), dx, dh(i));
                    Aij = hij(ijPos)*(wij+hij(ijPos)/tand(alphaij));
                    Rhij = Aij/(wij+2*hij(ijPos)/sind(alphaij));
                    %dhMean = nanmean(hij(ijPos:jStartC-2)-hij(ijPos+1:jStartC-1));
                    %hij(ijPos) = hij(ijPos+1)+dhMean;
                end
            end
            
            wLvl(ijPos) = gLvl(ijPos)+hij(ijPos);
            egl(ijPos) = wLvl(ijPos)+(Q/Aij)^2*(dx/c(j+1)^2/Rhij+1/(2*g));
            Fr(ijPos) = Q/(Aij*sqrt(g*hij(ijPos)));
            if Fr(ijPos) > 1
                disp('Reached supercritical state.')
                stopIterationFr = 1;
                jCrit = j+1;
                dhCrit = (h(i)-hij(ijPos+1))/jCrit;
                break;

%                 [hij(ijPos+1),Aij, Rhij] = fBackwaterDownwind(Q,Jf(j),wij,dw(i),...
%                         hij(ijPos), alphaij, dalpha(i), c(j), dx, dh(i));
            end
            
            if (and(hij(ijPos) > 0.99*hijDownwind(j),...
                    hij(ijPos) < 1.01*hijDownwind(j)))
                disp(['Upwind reached end of backwater.'])
                stopIteration = 1;
                break;
            end
        end
        if i > 1
            hijIni = h(i)+dh(i-1);
        end
        
        if stopIterationFr
            dE = (egl(sum(NX(1:i))-NX(i)+1)-egl(sum(NX(1:i)+1)))/NX(i);
            
            for j = 2:jCrit
                ijPos = sum(NX(1:i))-NX(i)+j;
                hij(ijPos) = hij(ijPos-1)-dhCrit;
                wij = w(i)-j/NX(i)*dw(i);
                alphaij = alpha(i)-j/NX(i)*dalpha(i);
                Aij = hij(ijPos)*(wij+hij(ijPos)/tand(alphaij));
                Rhij = Aij/(wij+2*hij(ijPos)/sind(alphaij));
                wLvl(ijPos) = gLvl(ijPos)+hij(ijPos);
                %egl(ijPos) = wLvl(ijPos)+(Q/Aij)^2*(dx/c(j)^2/Rhij+1/(2*g));
                egl(ijPos) =egl(ijPos-1)-dE;
                Fr(ijPos) = Q/(Aij*sqrt(g*hij(ijPos)));
            end
            for j = jCrit+1:NX(i)
                ijPos = sum(NX(1:i))-NX(i)+j;
                egl(ijPos) =egl(ijPos-1)-dE;
            end
                
            break;
        end
    end
end  


% ALONG CONSTRICTION ------------------------------------------------------
[c, Jf] = fGetcData(Q, 4, Qb);
jStartC = sum(NX(1:3))+njConst;
AupC = hij(jStartC)*(w(6)+hij(jStartC)/atand(alpha(6)));
RhupC = AupC/(w(6)+hij(jStartC)/atand(alpha(6)));
% get target level based on trajectory of a projectile
if b > w(6)
    wC = w(6);
else
    wC = b;
end
A0 = 0.5*(b-wC)^2+b*(hij(jStartC)-0.5*tand(alpha(6))*(b-wC));
u0 = Q/A0;


stopTraj = 0;
c_const = 40;
for j = njConst:njConst+Nconst
    ijPos = sum(NX(1:3))+j;
    if not(stopTraj)
        if hij(ijPos)>h(5)
            hij(ijPos+1) = hij(jStartC)-...
                dx*(j-njConst+1)*Jf(j)-...
                (dx*(j-njConst+1))^2*g/(2*(u0*cosd(atand(Jf(j))))^2);
        else
            hij(ijPos+1) = h(5);
            dhC = (hij(ijPos)-h(5))/(njConst-Nconst+1-j);
            stopTraj = 1;
        end
        
        
    else
        hij(ijPos+1) = hij(ijPos)-dhC;
    end
    Aij = 0.5*(b-wC)^2+b*(hij(ijPos+1)-0.5*tand(alpha(6))*(b-wC));
    Pij = wC+2*hij(ijPos+1)+(b-wC)/cosd(alpha(6))*(1-sind(alpha(6)));
    Rhij = Aij/Pij;
    wLvl(ijPos+1)= gLvl(ijPos+1)+ hij(ijPos+1);
    if j == njConst
        EGLcalc = wLvl(ijPos+1)+(Q/Aij)^2*(dx/c_const^2/Rhij+1/(2*g));
        EGLsoll = egl(ijPos)-dx*Jf(j);
        zetaIn = 2*g*AupC^2/Q^2*(EGLcalc-EGLsoll);
        if zetaIn < 0
            % occurs for large widths due to measuring imprecisions 
            % (however,very small values...)
            zetaIn = 0;
        end
        egl(ijPos+1) = wLvl(ijPos+1)+(Q/Aij)^2*(dx/c_const^2/Rhij+1/(2*g))...
                    -(Q/AupC)^2*(zetaIn)/(2*g);
    else
        dEr = dx*Q^2/c_const^2*(1/(A0^2*Rh0)-1/(Aij^2*Rhij));
        %dEr = dx*Q^2*(1/(A0^2*c_const^2*Rh0));
        %dEu = Q^2/(2*g)*(1/A0^2-1/Aij^2);
        egl(ijPos+1) = egl(ijPos)-dEr-dx*Jf(j);
    end
    A0 = Aij;
    Rh0 = Rhij;
    Fr(ijPos+1) = Q/(Aij*sqrt(g*hij(ijPos+1)));
end


% DOWNSTREAM OF CONSTRICTION ----------------------------------------------
% -------------------------------------------------------------------------
jEndC = njConst+Nconst+1;
%jStart = sum(NX(1:3))+jEndC;

dwij = (w(6)-w(5))/(NX(4)-jEndC);
dalphaij = (alpha(6)-alpha(5))/(NX(4)-jEndC);
dhCorr = hNC(5)-h(5);
dhDC = (hNC(4)-dhCorr-h(5))/NX(4);

for j =jEndC:NX(4)-1
    ijPos = sum(NX(1:3))+j;
    wij = w(6)-(j-jEndC+1)/(NX(4)-jEndC)*dwij;
    alphaij = alpha(6)-(j-jEndC+1)/(NX(4)-jEndC)*dalphaij;
    if not(stopTraj)
        if hij(ijPos)>h(5)
            hij(ijPos+1) = hij(jStartC)-...
                dx*(j-njConst+1)*Jf(j)-...
                (dx*(j-njConst+1))^2*g/(2*(u0*cosd(atand(Jf(j))))^2);
        else
            hij(ijPos+1) = h(5)+(NX(4)-j+1)*dhDC;
            stopTraj = 1;
        end
        wLvl(ijPos+1)= gLvl(ijPos+1)+ hij(ijPos+1);
        Aij = hij(ijPos+1)*(wij+hij(ijPos+1)/tand(alphaij));
        Pij = wij+2*hij(ijPos+1)/sind(alphaij);
        Rhij = Aij/Pij;
        dEr = dx*Q^2*(1/(A0^2*c(j)^2*Rh0));%-1/(Aij^2*c(j)^2*Rhij));
        %dEu = Q^2/(2*g)*(1/A0^2-1/Aij^2);
        egl(ijPos+1) = egl(ijPos)-dEr;
        A0 = Aij;
        Rh0 = Rhij;
    else
        hij(ijPos+1) = h(5)+(NX(4)-j+1)*dhDC;%hNC(4)-(j+1)*dhDC;
        Aij = hijNC(ijPos+1)*(wij+hijNC(ijPos+1)/tand(alphaij));
        Pij = wij+2*hijNC(ijPos+1)/sind(alphaij);
        Rhij = Aij/Pij;
        dEr = dx*Q^2*(1/(Aij^2*c(j)^2*Rhij));%1/(A0^2*c(j)^2*Rh0)-
        wLvl(ijPos+1)= gLvl(ijPos+1)+ hij(ijPos+1);
        egl(ijPos+1) = wLvl(ijPos+1)+dEr+(Q/Aij)^2/(2*g);
        A0 = Aij;
        Rh0 = Rhij;
    end
    
    Fr(ijPos+1) = Q/(Aij*sqrt(g*hij(ijPos+1)));
    
end

wLvlNC = gLvl+hijNC;%smooth(hijNC,0.9);

    
end

