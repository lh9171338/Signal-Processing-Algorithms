%mywiener_demo.m

%%
clc,clear all;
close all;

%% 参数
fs = 8000;
T = 1;
t = 0:1/fs:T;
f1 = 10;
f2 = 50;

%% 产生信号
signal_1 = sin(2*pi*f1*t);      %正弦波
% signal_2 = sin(2*pi*f2*t);    %正弦波
signal_2 = square(2*pi*f2*t);   %方波
% signal_2 = sawtooth(2*pi*f2*t); %三角波
% signal_2 = 0.5*randn(1,length(t)); %高斯白噪声
mix_signal = signal_1+0.5*signal_2;
b = [zeros(1,20),2];
noise_signal = filter(b,1,signal_2);

figure;
subplot(4,1,1);
plot(t,signal_1);
subplot(4,1,2);
plot(t,signal_2);
subplot(4,1,3);
plot(t,mix_signal);
subplot(4,1,4);
plot(t,noise_signal);

%% 维纳滤波
[~,y,w] = mywiener(noise_signal,mix_signal,100);
figure;
subplot(2,1,1)
plot(t,signal_1,'r',t,y,'g');

%% 低通滤波
Wc = 2*100/fs;   
[b,a] = butter(4,Wc);
y = filter(b,a,y);
subplot(2,1,2)
plot(t,signal_1,'r',t,y,'g');