function y_t = kernelconv(X_fht, kernel)
% function y_t = kernelconv(X_fht, kernel)
% 
% Calculate output of inseparable kernel to stimulus X_fht
%
% Inputs:
%  X_fht -- tensorized stimulus
%  kernel -- separable kernel containing k_fh, c
% 
% Output:
%  y_t -- response vector

y_t = k + squeeze(sum(sum(multiprod(data.X_fht, boostkernel.k_fh, 3), 1), 2));
