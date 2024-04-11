function A = Measure(M,N)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
A = randn(M,N);
%A = A / sqrt(M);
A = A ./ sqrt(sum(A.^2,2));
end