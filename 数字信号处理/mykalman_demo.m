%% mykalman_demo.m
%% 卡尔曼滤波示例
%%
clc,clear;
close all;

%% 参数
N = 100;  
t = 1:N;  

%% 卡尔曼滤波——匀速直线运动估计
k = 3;
b = 0;
u = k * t + b;      %真实信号
v = 0 * t + k;
x0 = [0,0];         %初始均值  
P0 = ones(2);       %初始协方差  
Q = 1 * ones(2,2);  %过程噪声协方差  
R = 100;              %观测噪声协方差  
noise = sqrt(R) * randn(1, N); 
z = u + noise;        %带噪声的观察值 
[x,x_e,G] = mykalman({[1,1;0,1],[0;0],[1,0]},x0,P0,[],z,Q,R);
  
%% 绘图
figure;  
plot(t,u,'r.-',t,x_e(1,:),'k.-',t,z,'b.-',t,x(1,:),'g.-', 'linewidth', 2);  
legend('真实值','估计值','观察值','最优估计值');
title('位移估计');
figure;
plot(t,v,'r.-',t,x_e(2,:),'k.-',t,x(2,:),'g.-');  
legend('真实值','估计值','最优估计值');
title('速度估计');
figure;  
plot(t,z,'b.-', t,x(1,:),'g.-');  
title('位移最优估计值');
