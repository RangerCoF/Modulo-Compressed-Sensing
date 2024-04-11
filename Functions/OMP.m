function z = OMP(A, y, max_iter, Eps)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if nargin < 3 || isempty(max_iter)
    max_iter = 500;
end

if nargin < 4 || isempty(Eps)
    Eps = 0.01;
end

[M, N] = size(A);
z = zeros(N, 1);
Lambda = [];
r = y;

for ii = 1:max_iter
    h = A' * r;
    [~, k] = max(h);
    Lambda = [Lambda, k];
    A_l = A(:, Lambda);
    z_l = (A_l' * A_l) \ A_l' * y;
    z(Lambda) = z_l;
    r = y - A * z;
    if norm(r) < Eps
        break
    end
end

end