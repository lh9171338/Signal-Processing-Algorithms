% filter2coe.m
% 滤波器系数转.coe文件
%%
clear,clc;
close all;

%% 参数
coeFilename = '../src/sound/filter.coe';

%% 获取滤波器系数
b = fir1(63,0.25,'low');
freqz(b,1);

%% 保存为coe文件 
fid = fopen(coeFilename,'w');
fprintf(fid,'# banks: 1\n');
fprintf(fid,'# coeffs: %d\n',length(b));
fprintf(fid,'%f,\n',b);
fclose(fid); % 关闭文件