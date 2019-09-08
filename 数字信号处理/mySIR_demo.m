%%mySIR_demo.m

%%
clc,clear;
close all;

%% 参数
nx = 300;  
t = 1:nx;  

%% SIR滤波——匀速直线运动估计
k = 4;
b = 0;
u = k * t + b;                  % 真实信号
v = 0 * t + k; 
x0 = 0 * ones(2,1);             % 粒子初始均值  
P0 = 100 * ones(2);             % 粒子初始协方差  
Q = 0.01;                       % 过程噪声协方差  
R = 100;                        % 观测噪声协方差 
N = 100;                        % 粒子数量
noise = sqrt(R) * randn(1, nx); % 噪声
z = u + noise;                  % 带噪声的观察值 
x = mySIR({[1,1;0,1], [0;0], [1,0]}, x0, P0, [], z ,Q, R, N);
  
%% 绘图
figure;  
plot(t, u, 'r.-', t, z, 'b.-', t, x(1,:), 'g.-');  
legend('真实值', '观察值', '最优估计值');


