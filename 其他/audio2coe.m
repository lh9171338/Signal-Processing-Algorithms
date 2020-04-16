% audio2coe.m
% 音频转.coe文件
%%
clear,clc;
close all;

%% 读取音频信号
soundFilename = '../src/sound/beyond - 光辉岁月.wav';
coeFilename = '../src/sound/rom.coe';
[y,fs] = audioread(soundFilename); 
totalTime = 16;
y = y(1:(fs*totalTime-1),1); % 取一个声道
y = (y + 1) / 2; % 转为正值
sound(y,fs);
figure;plot(y);

%% 保存为coe文件
y = round(y * 225);
fid = fopen(coeFilename,'wt');
fprintf(fid,'memory_initialization_radix = 16;\nmemory_initialization_vector = \n');
ny = length(y);
fprintf(fid,'%x,\n',y);
fclose(fid); % 关闭文件
