function W = tightFrame2D(n)
%TIGHTFRAME2D 此处显示有关此函数的摘要
%   此处显示详细说明
W2 = zeros(n, n);
W2(1, 1) = 1; W2(1, 2) = -1;
W2(end, end) = 1; W2(end, end - 1) = -1;
for i = 2 : n -1
    W2(i, i - 1) = -1;
    W2(i, i) = 2;
    W2(i, i + 1) = -1;
end
W2 = 0.25 * W2;

%
W1 = zeros(n, n);
W1(1, 1) =-1; W1(1, 2) = 1;
W1(end, end) = 1; W1(end, end - 1) = -1;
for i = 2 : n -1
    W1(i, i - 1) = -1;
    W1(i, i) = 0;
    W1(i, i + 1) = 1;
end
W1 = sqrt(2) * 0.25 * W1;
%

W0 = zeros(n, n);
W0(1, 1) = 3; W0(1, 2) = 1;
W0(end, end) = 3; W0(end, end - 1) = 1;
for i = 2 : n -1
    W0(i, i - 1) = 1;
    W0(i, i) = 2;
    W0(i, i + 1) = 1;
end
W0 = 0.25 * W0;
%
W0 = sparse(W0);
W1 = sparse(W1);
W2 = sparse(W2);
% W = [kron(W0, W0); 
%     kron(W0, W1);
%     kron(W0, W2); 
%     kron(W1, W0); 
%     kron(W1, W1);
%     kron(W1, W2);
%     kron(W2, W0); 
%     kron(W2, W1);
%     kron(W2, W2);
%     ];
W = [kron(W0, W0); 
    kron(W1, W0);
    kron(W2, W0); 
    kron(W0, W1); 
    kron(W1, W1);
    kron(W2, W1);
    kron(W0, W2); 
    kron(W1, W2);
    kron(W2, W2); 
    ];
end

