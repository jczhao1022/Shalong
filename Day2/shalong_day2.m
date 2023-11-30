clear; clc;close all;
load x_true.mat
N = sqrt(length(x));% 方阵
X = reshape(x, N, N);

A = fspecial('motion',15, 30);
b = imfilter(X, A, 'symmetric', 'conv') ; % 矩阵向量乘积的快速算法

% 生成噪声
e = randn(size(b));
e = e ./ norm(e, "fro");
e = 0.01 * norm(b, "fro") * e;
%X = reshape(X_vec, N, N);
figure(1)
imshow(X, [], 'InitialMagnification', 'fit')
figure(2)
imshow(b + e, [], 'InitialMagnification', 'fit')
% 生成紧标架
load W1.mat 
load W2.mat
load W3.mat
Frame = [kron(W1', W1); % 低通
         kron(W1', W2); % 高通
         kron(W1', W3); % 高通
         kron(W2', W1); % 高通
         kron(W2', W2); % 高通
         kron(W2', W3); % 高通
         kron(W3', W1); % 高通
         kron(W3', W2); % 高通
         kron(W3', W3); % 高通 
];
g = (kron(W1', W1)) * x; % 低频
figure(3)
imshow(reshape(g, N, N), [], 'InitialMagnification', 'fit')
g = (kron(W2', W1)) * x; % 高频
figure(4)
imshow(reshape(g, N, N), [], 'InitialMagnification', 'fit')