function z = MoRAM(A, y, T, R)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3 || isempty(T)
    T = 5;
end

if nargin < 4 || isempty(R)
    R = 1;
end

[M, N] = size(A);
p = zeros(M,1);
p(y>(R/2)) = 1;

A_aug = [A, eye(M)];

for ii=1:T
    y_iter = y - R * p;
    %{
    cvx_begin quiet
        variable u(N+M,1);
        minimize( norm( u, 1 ) );
        subject to
            [A, eye(M)]*u == y_iter
            %u(1:N)<=1
            %u(1:N)>=0
    cvx_end
    %}
    u = spgl1(A_aug,y_iter,0,0,'verbosity',0);
    x = u(1:N);
    p = (1-sign(A*x))./2;
end

z = x;
end