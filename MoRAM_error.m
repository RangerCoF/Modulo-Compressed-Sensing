clear all;
close all
path = 'mnist_test.csv';
T = readtable(path);
matrixData = table2array(T);
len_data = length(matrixData);
R = 2;
N = 784;

index_array = [41,232,299];
M_array = 50:50:700;
len_index = length(index_array);
len_M = length(M_array);

error_BP = zeros(len_index, len_M);
error_OMP = zeros(len_index, len_M);
error_MoRAM = zeros(len_index, len_M);
z_BP = zeros(len_index, len_M, 784);
z_OMP = zeros(len_index, len_M, 784);
z_MoRAM = zeros(len_index, len_M, 784);

for ii=1:len_M
    M = M_array(ii);
    A = Measure(M,N);
for jj=1:len_index
    index = index_array(jj);
    sample = matrixData(index,:);
    labels = sample(1);
    x = sample(2:end)'/255;
    y_true = A * x;
    y = mod(y_true, R);
    
    z = BasisPursuit(A, y_true);
    z_BP(jj,ii,:) = z;
    error_BP(jj,ii) = norm(z-x)/norm(x);
    
    z = OMP(A, y_true);
    z_OMP(jj,ii,:) = z;
    error_OMP(jj,ii) = norm(z-x)/norm(x);
    
    z = MoRAM(A, y, 5, R);
    z_MoRAM(jj,ii,:) = z;
    error_MoRAM(jj,ii) = norm(z-x)/norm(x);
end
end

x_M = 50:50:700;

figure
set(gcf, 'Position', [100, 100, 600, 300]);
hold on
plot(x_M, error_BP(1,:), '-o')
plot(x_M, error_OMP(1,:), '-+')
plot(x_M, error_MoRAM(1,:), '-*')
xlabel("M (Digit 1, Sparity 46)")
ylabel("Relative error")
legend("BP","OMP","MoRAM")
grid on
yticks(0:0.25:1.5)

figure
set(gcf, 'Position', [100, 100, 600, 300]);
hold on
plot(x_M, error_BP(2,:), '-o')
plot(x_M, error_OMP(2,:), '-+')
plot(x_M, error_MoRAM(2,:), '-*')
xlabel("M (Digit 3, Sparity 117)")
ylabel("Relative error")
legend("BP","OMP","MoRAM")
grid on
ylim([0, 1.5])
yticks(0:0.25:1.5)

figure
set(gcf, 'Position', [100, 100, 600, 300]);
hold on
plot(x_M, error_BP(3,:), '-o')
plot(x_M, error_OMP(3,:), '-+')
plot(x_M, error_MoRAM(3,:), '-*')
xlabel("M (Digit 2, Sparity 175)")
ylabel("Relative error")
legend("BP","OMP","MoRAM")
grid on
yticks(0:0.25:1.5)

