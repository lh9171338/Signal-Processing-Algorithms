%% myfastica_demo.m
%% Fast ICA示例
%%
clc,clear;
close all;

%% 产生原始信号
fs = 1000;
T = 1;
t = 0:1/fs:T;
m = 4; % 信号数量
n = length(t); % 信号长度
S = zeros(m,n); % 原始信号
S(1,:) = sin(2*pi*10*t); % 信号1
S(2,:) = square(2*pi*13*t); % 信号2
S(3,:) = sawtooth(2*pi*10*t).^2; % 信号3
S(4,:) = 0.1*randn(1,n); % 信号4
% 显示原始信号
y = S;
figure;
subplot(4,1,1);
plot(t,y(1,:));
title('原始信号');
subplot(4,1,2);
plot(t,y(2,:));
subplot(4,1,3);
plot(t,y(3,:));
subplot(4,1,4);
plot(t,y(4,:));

%% 构造混合样本
A = rand(m); %随机生成混合矩阵
X = A*S;
% 显示混合样本
y = X;
figure;
subplot(4,1,1);
plot(t,y(1,:));
title('混合样本');
subplot(4,1,2);
plot(t,y(2,:));
subplot(4,1,3);
plot(t,y(3,:));
subplot(4,1,4);
plot(t,y(4,:));

%% FastICA提取独立成分
maxiter = 100; % 迭代次数
S = myfastica(X,maxiter);

%% 显示结果
y = S;
figure;
subplot(4,1,1);
plot(t,y(1,:));
title('分离的信号');
subplot(4,1,2);
plot(t,y(2,:));
subplot(4,1,3);
plot(t,y(3,:));
subplot(4,1,4);
plot(t,y(4,:));
