load("Methods.mat")
load("saved_files5.mat")
x_M0 = 50:50:700;
x_M1 = 100:100:700;
figure
set(gcf, 'Position', [100, 100, 600, 300]);
hold on
plot(x_M0, error_BP(1,:), '-o')
plot(x_M0, error_OMP(1,:), '-+')
plot(x_M1, error_list(1,:), '-*')
plot(x_M0, error_MoRAM(1,:), '-^')
xlabel("M (Digit 1, Sparity 46)")
ylabel("Relative error")
legend("BP","OMP","MILP-based","MoRAM")
grid on
ylim([0, 1.5])
yticks(0:0.25:1.5)

figure
set(gcf, 'Position', [100, 100, 600, 300]);
hold on
plot(x_M0, error_BP(2,:), '-o')
plot(x_M0, error_OMP(2,:), '-+')
plot(x_M1, error_list(2,:), '-*')
plot(x_M0, error_MoRAM(2,:), '-^')

xlabel("M (Digit 3, Sparity 117)")
ylabel("Relative error")
legend("BP","OMP","MILP-based","MoRAM")
grid on
ylim([0, 1.5])
yticks(0:0.25:1.5)

figure
set(gcf, 'Position', [100, 100, 600, 300]);
hold on
plot(x_M0, error_BP(3,:), '-o')
plot(x_M0, error_OMP(3,:), '-+')
plot(x_M1, error_list(3,:), '-*')
plot(x_M0, error_MoRAM(3,:), '-^')
xlabel("M (Digit 2, Sparity 175)")
ylabel("Relative error")
legend("BP","OMP","MILP-based","MoRAM")
grid on
ylim([0, 1.5])
yticks(0:0.25:1.5)