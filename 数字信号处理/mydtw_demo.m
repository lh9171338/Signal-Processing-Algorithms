%% mydtw_demo.m
%% 动态时间调整
%%
clc,clear;
close all;

%% 产生测试数据
N = 100;
T1 = 2;
T2 = 1;
t1 = (1:N)*T1/N;
t2 = (1:N)*T2/N;
t1 = t1(:);
t2 = t2(:);
x = sin(2*pi/T1*t1);
y = sin(2*pi/T2*t2);

%% 显示测试数据
figure;
plot(t1,x,'r');
hold on;
plot(t2,y,'g');
title('原始数据');

%% DTW匹配
[~,indices] = mydtw(x,y);

%% 绘制匹配结果
figure;
plot(t1,x,'r');
hold on;
plot(t1(indices(:,1)),y(indices(:,2)),'.g');
title('匹配结果');
