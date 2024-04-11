%% 
% *Image Compression With Modulo Compressed Sensing*
% 
% Load data

clc;
clear all;
path = 'mnist_test.csv'
T = readtable(path);
matrixData = table2array(T);
rng('default');
%% 
% Read image vector x

sample = matrixData(1,:);
label = sample(1);
x = sample(2:end);
x = x(:);
x = x./255;
img = reshape(x,[28,28])';
sparsity = nnz(x); %norm(x,0) is not available in MATLAB
disp("the shape of x is: "+mat2str(size(x)))
disp("the sparsity of x is: "+sparsity)
imshow(img)
%% 
% Generate A matrix

M = 450;
N = 784;
A = 1/sqrt(M).*randn(M,N);
A = A ./ sqrt(sum(A.^2,2));
disp("the l2 norm of A's first row is: "+norm(A(1,:),2))

%% 
% Modulo Compressed Sensing

y_true = A*x;
disp("the maximum of y_true is: "+max(y_true))
disp("the minimum of y_true is:"+min(y_true))
y = y_true - floor(y_true);
disp("the shape of y is: "+mat2str(size(y)))
disp("the maximum of y is: "+max(y))
disp("the minimum of y is:"+min(y))

%% 
% MILP (equality form)

% % min |x|1
% % s.t. y=A*(x_plus-x_minus)-v, v is a integer

% % Define the objective function
f = [ones(N, 1); ones(N, 1); zeros(M, 1)];
intcon = 2*N+1:2*N+M;

% Define the equality constraints
Aeq = [A, -A, -eye(M)];
beq = y;

lb_MILP = zeros(2*N+M,1);
lb_MILP(2*N+1:2*N+M) = -2;
ub_MILP = zeros(2*N+M,1);
ub_MILP(1:2*N) = Inf;
ub_MILP(2*N+1:2*N+M) = 1;

% Solve the problem using intlinprog
[x_hat, fval, exitflag, output] = intlinprog(f, intcon, [], [], Aeq, beq,lb_MILP,ub_MILP,optimoptions('intlinprog','MaxTime',300))
% [x_hat, fval, exitflag, output] = intlinprog(f, intcon, [], [], Aeq, beq,lb_MILP,ub_MILP)
%%
x_plus = x_hat(1:N);
x_minus = x_hat(N+1:2*N); 
x0=x_plus-x_minus;
img_recon = reshape(x0,[28,28])';
subplot(1,2,1)
imshow(img)
subplot(1,2,2)
imshow(img_recon)
relative_error = norm(img_recon-img,2)/norm(img,2)