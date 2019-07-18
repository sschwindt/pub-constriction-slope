function [ jf_num, Jf ] = fMakeGrid(xData,zData,diff)
% This function finds flow depth h0 numerically for a trapezoidal bed 
%   profile solving manning equation by Newton Raphson method

DX = xData(2:end)-xData(1:end-1);
DZ = zData(1:end-1)-zData(2:end);

Jf = DZ./DX;

dx_num = 1.5*diff/2.0;
nx_num = ceil(DX/dx_num);
% create output matrix col1=section col2=Jf
jf_num = nan(sum(nx_num),2);
for i = 1:numel(xData)-1
    for j = 1:nx_num(i)
        
       if i == 1
           jf_num(j,1)=i;
           if j/nx_num(i) <= 0.5
               jf_num(j,2)=Jf(i);
           else
               dJf = (Jf(i+1)-Jf(i))/(nx_num(i)/2+nx_num(i+1)/2);
               jf_num(j,2)=Jf(i)-(nx_num(i)/2-j)*dJf;
           end
       end
       if and( i > 1, i < numel(xData)-1 )
           position = sum(nx_num(1:i-1))+j;
           jf_num(position,1) = i;
           if j/nx_num(i) <= 0.5
               dJf = (Jf(i-1)-Jf(i))/(nx_num(i-1)/2+nx_num(i)/2);
               jf_num(position,2)=Jf(i)-(j-nx_num(i)/2)*dJf;
           else
               dJf = (Jf(i+1)-Jf(i))/(nx_num(i)/2+nx_num(i+1)/2);
               jf_num(position,2)=Jf(i)-(nx_num(i)/2-j)*dJf;
           end
       end
       if i == numel(xData)-1
           position = sum(nx_num(1:i-1))+j;
           jf_num(position,1) = i;
           
           if j/nx_num(i) <= 0.25
               dJf = (Jf(i-1)-Jf(i))/(nx_num(i-1)/2+nx_num(i)/4);
                jf_num(position,2)=Jf(i)-(j-nx_num(i)/4)*dJf;
           else
               jf_num(position,2)=Jf(i)+(j-nx_num(i)/4)*dJf;
           end
       end
   end
end

end

