%% mylmsfilt_demo.m
%% LMS自适应滤波
%%
clc,clear;
close all;

%% 参数
fs = 8000;
T = 1;
t = 0:1/fs:T;
f1 = 10;
f2 = 40;

%% 产生信号
signal_1 = sin(2*pi*f1*t);      %正弦波
signal_2 = 0.5*sin(2*pi*f2*t);    %正弦波
% signal_2 = 0.5*square(2*pi*f2*t);   %方波
% signal_2 = 0.5*sawtooth(2*pi*f2*t); %三角波
% signal_2 = 0.5*randn(1,length(t));   %高斯白噪声
mix_signal = signal_1+signal_2;
b = [zeros(1,25),1];
noise_signal = filter(b,1,signal_2);

%% 绘制时域波形
figure;
subplot(4,1,1);
plot(t,signal_1);
subplot(4,1,2);
plot(t,signal_2);
subplot(4,1,3);
plot(t,mix_signal);
subplot(4,1,4);
plot(t,noise_signal);

%% 自适应滤波
[~,e,w] = mylmsfilt(noise_signal,mix_signal,200,0.0005);
figure;
subplot(2,1,1)
plot(t,signal_1,'r',t,e,'g');

%% 低通滤波
Wc = 2*100/fs;   
[b,a] = butter(4,Wc);
y = filter(b,a,e);
subplot(2,1,2)
plot(t,signal_1,'r',t,y,'g');
