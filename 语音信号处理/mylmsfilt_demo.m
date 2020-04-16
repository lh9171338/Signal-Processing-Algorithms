%% mylmsfilt_demo.m
%% LMS回声抵消
%%
clc,clear;
close all;

%%
addpath('../数字信号处理');

%% 读取语音信号
[s, ~] = audioread('../src/sound/handel.wav');
[x,fs] = audioread('../src/sound/handel_echo.wav');
s = s';
x = x';
nx = length(x);
t = (1:nx) / fs;

%% 播放语音信号
% pause;
% soundsc(s,fs);
% pause;
% soundsc(x,fs);

%% LMS自适应滤波
p = 3000;
[y,e,w] = mylmsfilt(x(1:nx-p),x(p+1:nx),1,0.01);
y = [zeros(1,p), y];
e = [x(1:p), e];

%% 绘制时域波形
figure;
subplot(4,1,1)
plot(t,s);
xlabel('时间(s)');ylabel('幅度');title('原始语音');ylim([-1,1]);
subplot(4,1,2)
plot(t,x);
xlabel('时间(s)');ylabel('幅度');title('带回声的语音');ylim([-1,1]);
subplot(4,1,3)
plot(t,y);
xlabel('时间(s)');ylabel('幅度');title('预测的回声语音');ylim([-1,1]);
subplot(4,1,4)
plot(t,e);
xlabel('时间(s)');ylabel('幅度');title('滤波后的语音');ylim([-1,1]);
% pause;
% soundsc(e,fs);

%% 绘制语谱图
figure;
spectrogram(s,256,128,256,1000,'yaxis');
title('原始语音');
figure;
spectrogram(x,256,128,256,1000,'yaxis');
title('带回声的语音');
figure;
spectrogram(e,256,128,256,1000,'yaxis');
title('滤波后的语音');
