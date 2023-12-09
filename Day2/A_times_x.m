function C = A_times_x(A, x, options)
%A_TIMES_B Compute A*x
% A is a blur matrix with reflect boundary conditions for x
% A is the PSF and x is the unblured image
% options == 1 --------- A*x
% options == 2 --------- A'*x

if options == 1
C = imfilter(x, A, 'symmetric', 'conv') ;
elseif options == 2
    A = rot90(A,2);
    C = imfilter(x, A, 'symmetric', 'conv') ;
else
    error('Need to figure out transpose or not!')
end
end

