%% 
% *Image Compression With Modulo Compressed Sensing*
% 
% Load data

clc;
clear all;
path = './mnist_dataset/mnist_test.csv';
T = readtable(path);
matrixData = table2array(T);
rng('default')
%% Read images
% index list idx_list=[41,190,123,40,232,101, 295,299,227] 
% 46 59 80 100 117 143 163 179 200
% idx_list=[41,190];
% idx_list=[41,190,123,40,232,101,295,299,227];
idx_list=[41,232,299];
% idx_list=[101,295,299];
% idx_list=[299];

x_list = zeros(784,length(idx_list)); % x list
label_list = zeros(1,length(idx_list)); % label list
s_list = zeros(1,length(idx_list)); % sparsity list
for ii=1:length(idx_list)
    sample = matrixData(idx_list(ii),:);
    label = sample(1);
    x = sample(2:end);
    x = x(:);
    x = x./255;
    sparsity = nnz(x); %norm(x,0) is not available in MATLAB
    x_list(:,ii) = x;
    label_list(:,ii) = label;
    s_list(:,ii) = sparsity;
end
%% 
% M_list = [100, 200, 300, 400, 500, 600, 700, 784];
% M_list = [200,300,400,500,700];
% M_list = [400,500,700];
M_list = [100, 200, 300, 400, 500, 600, 700];
x_recon_list = zeros(784,length(idx_list),length(M_list)); 
error_list = zeros(length(idx_list),length(M_list));
disp (size(x_recon_list))
for m=1:length(M_list)
    M = M_list(m);
    N = 784;
    A = randn(M,N);
    A = A ./ sqrt(sum(A.^2,2));
    for ii=1:length(idx_list)
        y_true = A*x_list(:,ii);
        % disp(sum(x_list(:,ii)))
        y = y_true - floor(y_true);
        % x_recon_list(:,ii,m) = ii*m*ones(784,1);
        f = [ones(N, 1); ones(N, 1); zeros(M, 1)];
        intcon = 2*N+1:2*N+M;

        Aeq = [A, -A, -eye(M)];
        beq = y;

        lb_MILP = zeros(2*N+M,1);
        lb_MILP(2*N+1:2*N+M) = -2;
        ub_MILP = zeros(2*N+M,1);
        ub_MILP(1:2*N) = Inf;
        ub_MILP(2*N+1:2*N+M) = 1;

        [x_hat, fval, exitflag, output] = intlinprog(f, intcon, [], [], Aeq, beq,lb_MILP,ub_MILP,optimoptions('intlinprog','MaxTime',300));
        x_plus = x_hat(1:N);
        x_minus = x_hat(N+1:2*N);
        x_hat=x_plus-x_minus;
        x_recon_list(:,ii,m) = x_hat;
        error_list(ii,m) = norm(x_list(:,ii)-x_hat,2)/norm(x_list(:,ii),2);
    end

end


%% 
save('saved_files5.mat','x_recon_list','idx_list','s_list','M_list','error_list')
