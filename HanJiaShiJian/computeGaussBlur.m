function [g, B, x_naive, P, center] = computeGaussBlur(x_true, s)
%COMPUTEGAUSSBLUR 
%   s = [s1, s2, rho]
%   type = ''
if nargin == 1
    s = [2, 2, 0];
end
[P, center] = psfGauss(size(x_true), [s(1), s(2)], s(3));
S = fft2(circshift(P, 1 - center));
g = real(ifft2(S .* fft2(x_true)));

E = randn(size(g)) ;
E = E / norm(E, 'fro' );
B = g + 0.01 * norm(g, 'fro') * E;
x_naive = real( ifft2(fft2(B) ./ S));
end

