clear; clc; close all; rng("default"); load Grain.mat
[g, B, x_naive, P, center] = computeGaussBlur(x_true);
% g: 仅模糊
% B: 模糊+噪声
% x_naive = A\b;
% P: PSF
% center: PSF 的中心
figure(1)
imshow(x_true, []) % 原始图像
figure(2)
imshow(x_naive, []) % A\b = x_true + A\e
%% 最小二乘解
% 奇异值（特征值）
S = fft2(circshift(P, 1 - center));
% A'b
S1 = fft2(circshift(rot90(P), 1 - center));
ATB = real(ifft2(S1 .* fft2(B)));
% A'A 的奇异值（特征值）
S2 = S .* S;
X_LS = real(ifft2(( (S2).\ fft2(ATB))));
figure(3)
imshow(X_LS, [])
%% 正则化
% 奇异值（特征值）
S = fft2(circshift(P, 1 - center));
% A'b
S1 = fft2(circshift(rot90(P), 1 - center));
ATB = real(ifft2(S1 .* fft2(B)));
% A'A 的奇异值（特征值）
S2 = S .* S;
X_LS = real(ifft2(( (S2 + 1e-2) .\ fft2(ATB))));
figure(4)
imshow(X_LS, [])