%% mylp_demo.m
%% 语音线性预测示例
%%
clc,clear;
close all;

%% 参数
srcFilename = '../src/sound/six.wav';
dstFilename = '../src/sound/six.txt';
fs = 8000;
nwin = 160;
p = 10;

%% 读取语音信号
[x,Fs] = audioread(srcFilename); % 原始语音信号
x = x(:,1);
if Fs ~= fs
    x = resample(x,fs,Fs);
end

%% 线性预测分析
lpcparam = mylpanalysis(x,fs,nwin,p);
mylpaudiowrite(dstFilename,lpcparam);

%% 线性预测合成
y = mylpsynthesis(lpcparam);

%% 绘制时域波形
figure;
subplot(2,1,1);
t = (0:length(x)-1) / fs;
plot(t,x);xlabel('时间(s)');ylabel('幅度');title('原始语音');ylim([-1,1]);
subplot(2,1,2);
t = (0:length(y)-1) / fs;
plot(t,y);xlabel('时间(s)');ylabel('幅度');title('合成语音');ylim([-1,1]);

%% 播放
pause;
soundsc(x,fs);
pause;
soundsc(y,fs);
