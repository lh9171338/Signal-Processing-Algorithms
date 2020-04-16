%% myspeechenhance_demo.m
%% 语言增强示例
%%
clc,clear;
close all;

%% 
addpath('../数字信号处理');

%% 读取语音信号
[s,~] = audioread('../src/sound/speech_clean.wav'); % 原始语音信号
[x,fs] = audioread('../src/sound/noisy.wav');       % 带有噪声的语音信号
s = s(:,1);
x = x(:,1);
nx = length(x);
t = (1:nx) / fs;

%% 预处理
s = s - mean(s);      % 去直流
s = s / max(abs(s));  % 归一化
x = x - mean(x);      % 去直流
x = x / max(abs(x));  % 归一化

%% 播放语音信号
% pause;
% soundsc(s,fs);
% pause;
% soundsc(x,fs);

%% 语音增强
y1 = myspecsub(x,[4,0.001]);            % 谱减法
y2 = myspeechwiener(x,[4,0.001,1,1]);   % 维纳滤波
y3 = myspeechwavelet(x,4);              % 小波滤波
y4 = myspeechkalman(x,[],2);            % 卡尔曼滤波

%% 计算信噪比
snr = mysnrcalc(s,x);
snr1 = mysnrcalc(s,y1);
snr2 = mysnrcalc(s,y2);
snr3 = mysnrcalc(s,y3);
snr4 = mysnrcalc(s,y4);
fprintf('snr=%f,snr1=%f,snr2=%f,snr3=%f,snr4=%f\n',snr,snr1,snr2,snr3,snr4);

%% 绘制时域波形
figure;
subplot(3,2,1);
plot(t,s);
xlabel('时间(s)');ylabel('幅度');title('原始语音');ylim([-1,1]);
subplot(3,2,2);
plot(t,x);
xlabel('时间(s)');ylabel('幅度');title('带噪语音');ylim([-1,1]);
subplot(3,2,3);
plot(t,y1);
xlabel('时间(s)');ylabel('幅度');title('谱减法滤波语音');ylim([-1,1]);
subplot(3,2,4);
plot(t,y2);
xlabel('时间(s)');ylabel('幅度');title('维纳滤波语音');ylim([-1,1]);
subplot(3,2,5);
plot(t,y3);
xlabel('时间(s)');ylabel('幅度');title('小波滤波语音');ylim([-1,1]);
subplot(3,2,6);
plot(t,y4);
xlabel('时间(s)');ylabel('幅度');title('卡尔曼滤波语音');ylim([-1,1]);

%% 绘制语谱图
figure;
subplot(3,2,1);
spectrogram(s,256,128,256,1000,'yaxis');
title('原始语音');
subplot(3,2,2);
spectrogram(x,256,128,256,1000,'yaxis');
title('带噪语音');
subplot(3,2,3);
spectrogram(y1,256,128,256,1000,'yaxis');
title('谱减法滤波语音');
subplot(3,2,4);
spectrogram(y2,256,128,256,1000,'yaxis');
title('维纳滤波语音');
subplot(3,2,5);
spectrogram(y3,256,128,256,1000,'yaxis');
title('小波滤波语音');
subplot(3,2,6);
spectrogram(y4,256,128,256,1000,'yaxis');
title('卡尔曼滤波语音');

%% 播放
% pause;
% soundsc(y1,fs);
% pause;
% soundsc(y2,fs);
% pause;
% soundsc(y3,fs);
% pause;
% soundsc(y4,fs);
