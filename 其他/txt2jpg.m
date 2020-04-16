% txt2jpg.m
% 文本文件转图像
%%
clc,clear;
close all;

%% 参数
textFilename = '../src/image/cc.txt';
imageFilename = '../src/image/cc.jpg';
rows = 300;
cols = 300;
dataWidth = 24;

%% 读文件
fid = fopen(textFilename,'r');
data = fscanf(fid,'%u\n');
fclose(fid); % 关闭文件
data = reshape(data,cols,rows)';

%% 数据
switch(dataWidth)
    case 1 %二值图
        image = logical(data);
    case 8 %灰度图
        image = uint8(data);
    case 16 %16位彩色图
        R = fix(data/2048);
        G = fix(rem(data,2048)/32);
        B = rem(data,32);
        image = uint8(cat(3,R,G,B));
    case 24  %24位彩色图
        R = rem(fix(data/65536),256);
        G = fix(rem(data,65536)/256);
        B = rem(data,256);
        image = uint8(cat(3,R,G,B));
    otherwise
        error('dataWidth数值有误');
end

%% 保存图片并显示
figure;imshow(image);
imwrite(image,imageFilename); 
