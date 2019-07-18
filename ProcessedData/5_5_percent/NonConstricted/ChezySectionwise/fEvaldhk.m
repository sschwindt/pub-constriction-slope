function [ ck1 ] = fEvaldhk( hk, hj, ck, k )
% This returns the evaluation of the computed and the measured flow depth
% at the end of the section ij
% hk and ck are vectors --> output ck1 is a variable(double)

delta = 10^-2;   %[-] variance allowance

% inverse
if k==1
    if hk(k) < hj
        ck1 = (1-delta)*ck(k);
    else
        ck1 = (1+delta)*ck(k);
    end
else
    if and(hk(k) < hj, hk(k-1) < hj)
        ck1 = (1-delta)*ck(k);
    end
    if or(and(hk(k) < hj, hk(k-1) > hj), and(hk(k) > hj, hk(k-1) < hj))
        ck1 = 0.5*(ck(k)+ck(k-1));
    end
    if and(hk(k) > hj, hk(k-1) > hj)
        ck1 = (1+delta)*ck(k);
    end
end
