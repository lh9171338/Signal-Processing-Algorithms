%mykalman_demo.m

%%
clc,clear;
close all;

%% 参数
N = 300;  
t = 1:N;  
CON = 25;%房间温度，假定温度是恒定的  

%% 卡尔曼滤波 
z = CON+randn(1,N); %带噪声的观察值 
x0 = 1; %初始均值  
P0 = 10; %初始协方差  
Q = cov(randn(1,N));%过程噪声协方差  
R = cov(randn(1,N));%观测噪声协方差  
[x,x_e,G] = mykalman({1,0,1},x0,P0,[],z,Q,R);
  
%% 绘图
figure;  
expValue = zeros(1,N);  
expValue(:) = CON;  
plot(t,expValue,'r',t,x_e,'m',t,z,'b',t,x,'g');  
legend('真实值','估计值','观察值','最优估计值');  

%% 参数
fs = 1;
T = 100;
t = 0:1/fs:T;
nx = length(t);

% %% 卡尔曼滤波——匀速直线运动估计
% k = 2;
% b = -5;
% u = k*t+b; %真实信号
% v = 0*t+k;
% % noise = 10*randn(1,nx); 
% noise = 20*sin(2*pi*0.1*t); 
% z = u+noise; %带噪声的观察值 
% x0 = zeros(2,1); %初始均值  
% P0 = ones(2); %初始协方差  
% Q = 0.0001; %过程噪声协方差  
% R = 1000; %观测噪声协方差  
% [x,x_e,G] = mykalman({[1,1;0,1],[0;0],[1,0]},x0,P0,[],z,Q,R);
%   
% %% 绘图
% figure;  
% plot(t,u,'r.-',t,x_e(1,:),'k.-',t,z,'b.-',t,x(1,:),'g.-');  
% legend('真实值','估计值','观察值','最优估计值');
% title('位移估计');
% figure;
% plot(t,v,'r.-',t,x_e(2,:),'k.-',t,x(2,:),'g.-');  
% legend('真实值','估计值','最优估计值');
% title('速度估计');
% figure;  
% plot(t,x(1,:),'g.-');  
% title('位移最优估计值');

