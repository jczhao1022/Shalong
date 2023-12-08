clear; clc; close all;
rng('default');
% load("TestData\Text2.mat");
% x_true = 1- x_true; fspecial('motion',15,30)


% load("TestData\Grain.mat")
% load("TestData\satellite.mat")
% load("TestData\Text.mat")
% load("TestData\Text2.mat"); % x_true = 1- x_true;
x_true = double(imread("cameraman.tif"));
% x_true = double(imread("mri.tif"));
% x_true = x_true./256;
x_true = double(x_true);

A = fspecial('motion',15,30); % a motion PSF
% A = fspecial('disk',3); % a disk PSF
% A = fspecial('Gaussian',15,2);
% A = fspecial('average',[11,11]); % an average PSF
g = A_times_x(A, x_true, 1); % g = A*x_true

e = rand(size(g));
e = e./norm(e, "fro");
pEpsilon = norm(g,"fro");
g = g + 0.01 * norm(g,"fro") * e;


maxit  = 3e3;
% del = 0.9 / max(abs(S), [], "all") ^ 2;
del = 1;
% lambda = 1e-5;
lambda = 2 * max(x_true, [], "all");


[m, n] = size(x_true);
W = tightFrame2D(n);
x_true_vec = x_true(:);
r = g(:);
b = r;
x = zeros(size(W, 1),1);
z = x;
x_old = x;
t0 = 0;
psnr_iter = zeros(maxit, 1);
snr_iter = psnr_iter;
for ind = 1 : maxit

    tic;
    tem1 = A_times_x(A, reshape(r, n, n), 2); %A' r
    z = z + del .* W * tem1(:); % W A' r

    x = sign(z).*max(abs(z) - lambda, 0);

    tem2 = A_times_x(A, reshape( W' * x, n, n), 1); % A W' x
    r = b - tem2(:);
    t1 = toc;
    t0 = t0 + t1;
    x_solve_ista = reshape(W' *x, n, n);

    SNR1 = 10*log10(norm(x_solve_ista)^2 / norm(x_solve_ista - x_true)^2);
    snr_iter(ind) = SNR1;
    Var_x_solve = (x_true - x_solve_ista).^2;
    Var_x_solve = sum(Var_x_solve,"all")/(m*n);
    Var_x_solve = sqrt(Var_x_solve);
    peaksnr = 20*log10(max(x_true,[],"all")/Var_x_solve);
    psnr_iter(ind) = peaksnr;
    % 偏差原理
%     if norm(r, "fro") < 1.01 * 0.01 * pEpsilon
%         fprintf("Break at iteration: %d\n", ind)
%         break
%     end
    
    %     if norm(x - x_old, "fro") / norm(b, "fro") < 1e-5
    %         fprintf("Break at iteration: %d\n", ind)
    %         break
    %     end
    %     x_old = x;
end
x_solve_ista = reshape(W' *x, n, n);
figure(5)
imshow(x_solve_ista, 'DisplayRange', [], 'border', 'tight')
fprintf("Total time is: %.3f\n", t0)
SNR1 = 10*log10(norm(x_solve_ista)^2 / norm(x_solve_ista - x_true)^2);
fprintf("SNR of x_solve is: %.1f\n", SNR1);
Var_x_solve = (x_true - x_solve_ista).^2;
Var_x_solve = sum(Var_x_solve,"all")/(m*n);
Var_x_solve = sqrt(Var_x_solve);
% peaksnr = psnr(x_solve, x_true);
peaksnr = 20*log10(max(x_true,[],"all")/Var_x_solve);
fprintf('Peak-SNR of x_solve is %.1f\n', peaksnr);
% imshow(reshape(W' * W * x_true_vec,n,n), 'DisplayRange', [], 'border', 'tight')
figure(6)
plot(1:length(psnr_iter), psnr_iter)
hold on
plot(1:length(snr_iter), snr_iter)
legend('psnr', 'snr')
