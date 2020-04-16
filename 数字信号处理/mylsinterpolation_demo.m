%% mylsinterpolation_demo.m
%% LS插值
%% 
clear,clc;
close all;

%% 产生信号
N = 50;
n = 1:N;
s = sin(2*pi*n/N) + sin(2*pi*3*n/N);
s = s';

%% 观测
m = 20;
n = 30;
H = eye(N);
Sx = H([1:m-1,n+1:end],:);
Sc = H(m:n,:);
x = Sx * s;

%% LS插值
D = toeplitz([-2,1,zeros(1,N-2)]);
v = -(Sc * (D' * D) * Sc') \ Sc * (D' * D) * Sx' * x; 
y = Sx' * x + Sc' * v;

%% 显示
figure;
subplot(3,1,1);plot(s,'.');title('真实信号');
subplot(3,1,2);plot(x,'.');title('观察信号');
subplot(3,1,3);plot(y,'.');title('插值信号');
