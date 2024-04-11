clc;
clear all;

load('Methods.mat')
load('saved_files5.mat')
path = 'mnist_test.csv';
T = readtable(path);
matrixData = table2array(T);
%%
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

ax = tight_subplot(5, 3, [0.1, 0.1], [0.1, 0.1], [0.1, 0.1]);

axes(ax(1));
imshow(reshape(x_list(:,1),28,28)')
xlabel({"Original image 1", "s=46"})
axes(ax(2));
imshow(reshape(x_list(:,2),28,28)')
xlabel({"Original image 3", "s=117"})
axes(ax(3));
imshow(reshape(x_list(:,3),28,28)')
xlabel({"Original image 2", "s=175"})
axes(ax(4));
imshow(reshape(x_recon_list(:,1,1),28,28)')
xlabel({"MILP-based", "M=100"})
axes(ax(5));
imshow(reshape(x_recon_list(:,2,3),28,28)')
xlabel({"MILP-based",  "M=300"})
axes(ax(6));
imshow(reshape(x_recon_list(:,3,6),28,28)')
xlabel({"MILP-based", "M=600"})
axes(ax(7));
imshow(reshape(x_recon_list(:,1,3),28,28)')
xlabel({"MILP-based", "M=300"})
axes(ax(8));
imshow(reshape(x_recon_list(:,2,5),28,28)')
xlabel({"MILP-based", "M=500"})
axes(ax(9));
imshow(reshape(x_recon_list(:,3,7),28,28)')
xlabel({"MILP-based", "M=700"})
% z_MoRAM(1,2,:)
axes(ax(10));
imshow(reshape(z_MoRAM(1,2,:),28,28)')
xlabel({"MoRAM", "M=100"})
axes(ax(11));
% z_MoRAM(2,6,:)
imshow(reshape(z_MoRAM(2,6,:),28,28)')
xlabel({"MoRAM", "M=300"})
axes(ax(12));
% z_MoRAM(3,12,:)
imshow(reshape(z_MoRAM(3,12,:),28,28)')
xlabel({"MoRAM", "M=600"})
axes(ax(13));
% z_MoRAM(1,6,:)
imshow(reshape(z_MoRAM(1,6,:),28,28)')
xlabel({"MoRAM", "M=300"})
axes(ax(14));
% z_MoRAM(2,10,:)
imshow(reshape(z_MoRAM(2,10,:),28,28)')
xlabel({"MoRAM", "M=500"})
axes(ax(15));
% z_MoRAM(3,14,:)
imshow(reshape(z_MoRAM(3,14,:),28,28)')
xlabel({"MoRAM", "M=700"})
