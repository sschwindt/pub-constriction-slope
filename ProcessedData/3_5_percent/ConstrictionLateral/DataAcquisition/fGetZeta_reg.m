function [ zeta ] = fGetZeta_reg( Fr0 )
% Function computes local loss coefficient zeta based on overall (2-4-6)
% regression analyses and the upstream Froude number

zeta = 0.3079 * Fr0^-0.8309 - 0.4046;

end



