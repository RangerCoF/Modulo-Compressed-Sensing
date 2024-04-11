function z = BasisPursuit(A, y)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[M, N] = size(A);

%{
cvx_begin quiet
    variable u(N)
    minimize(norm(u, 1))
    subject to
        A * u == y
cvx_end
%}

z = spgl1(A,y,0,0,'verbosity',0);
end