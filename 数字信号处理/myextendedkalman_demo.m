% myextendedkalman_demo.m
%%
clc,clear;
close all;

%% 匀速直线运动估计
nx = 100;  
T = 10;
dt = T / nx;
t = (1:nx) * dt;  
v = [1;1]; % 速度
x0 = [0;0]; % 初位移
x_gt = x0 + v * t;
z = [sqrt(sum((x_gt-[0;10]).^2));sqrt(sum((x_gt-[10;0]).^2))] + 0.1 * randn(2,nx); 

%% 绘制真实轨迹
figure;
plot(x_gt(1,:),x_gt(2,:));
figure;
subplot(2,1,1);plot(z(1,:));
subplot(2,1,2);plot(z(2,:));

%% 扩展卡尔曼滤波
dimx = 4;
dimz = 1;
x0 = zeros(dimx,1); % 初始均值  
P0 = eye(dimx);     % 初始协方差  
Q = 0.01 * eye(dimx);  % 过程噪声协方差  
R = 1 * eye(dimz);  % 观测噪声协方差  
symx = sym('x',[dimx,1],'real');
symu = sym('u','real');
symf = [1,0,dt,0;0,1,0,dt;0,0,1,0;0,0,0,1] * symx;
symg = [0;0;0;0] * symu;
symh = [sqrt(symx(1)^2+(symx(2)-10)^2);sqrt((symx(1)-10)^2+symx(2)^2)];
x = myextendedkalman({symf,symg,symh},x0,P0,[],z,Q,R);
  
%% 绘图
figure; 
plot(x_gt(1,:),x_gt(2,:),'r',x(1,:),x(2,:),'g');
legend('真实值','最优估计值'); title('位移估计');

