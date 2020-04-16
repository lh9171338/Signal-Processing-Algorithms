%% mylssmoothing_demo.m
%% LS平滑
%% 
clear,clc;
close all;

%% 产生信号
N = 50;
n = 1:N;
s = sin(2*pi*n/N)';

%% 加噪声
x = s + 0.2 * randn(N,1);

%% LS平滑
lambda = 10;
D = toeplitz([-2,1,zeros(1,N-2)]);
y = (eye(N) + lambda * (D' * D)) \ x;

%% 显示
figure;
subplot(3,1,1);plot(s);title('原始信号');
subplot(3,1,2);plot(x);title('加噪信号');
subplot(3,1,3);plot(y);title('平滑信号');
