clear all;
close all
path = 'mnist_test.csv';
T = readtable(path);
matrixData = table2array(T);
len_data = length(matrixData);
len_data = 10000; 

%M = 600;
N = 784;
R = 2;

labels = zeros(len_data, 1);
sparsity = zeros(len_data, 1);
z_rec = zeros(len_data, N );

errors = zeros(len_data, 13);

M_index = 0;
for M=100:50:700
M_index = M_index + 1;
for ii=1:len_data 
    sample = matrixData(ii,:);
    labels(ii) = sample(1);
    x = sample(2:end);
    x = x(:);
    sparsity(ii) = nnz(x);
    x = x./255;
    A = Measure(M, N);
    
    y_true = A*x;
    %y_true(y_true>1) = 1 - eps;
    %y_true(y_true<-1) = -1;
    %y = y_true - floor(y_true);
    y = mod(y_true, R);
    %y = y_true;
    
    %z = BasisPursuit(A, y);
    %z = OMP(A, y);
    z = MoRAM(A, y, 5, R);
    %z_rec(ii, :) = z;
    
    %figure
      %subplot(121)
    %imshow(reshape(x, 28, 28)')
    %subplot(122)
    %imshow(reshape(z, 28, 28)')
    
    errors(ii, M_index) = norm(z - x)/norm(x);

    if mod(ii, 100)==0
        disp(ii)
    end
end
disp(M)
end

prob_0 = sum(errors<0.001);
prob_0 = prob_0(1:13);
prob_1 = sum(errors<0.1);
prob_1 = prob_1(1:13);
prob_2 = sum(errors<0.5);
prob_2 = prob_2(1:13);
prob_3 = sum(errors>=0.5);
prob_3 = prob_3(1:13);

plot_x = 100:50:700;
plot(plot_x, prob_0, '-o')
hold on
plot(plot_x, prob_1, '-+')
plot(plot_x, prob_2, '-*')
plot(plot_x, prob_3, '-x')
xlabel("M")
ylabel("Reconstruction probability")
legend("Lossless Reconstruction", "Visual Reconstruction",...
    "Flawed Reconstruction", "Failure", "Location", "west")
grid on
set(gcf, 'Position', [100, 100, 600, 300]);
