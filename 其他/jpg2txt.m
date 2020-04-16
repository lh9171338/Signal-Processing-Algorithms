% jpg2txt.m
% 图像转文本文件
%%
clc,clear;
close all;

%% 参数
textFilename = '../src/image/cc.txt';
imageFilename = '../src/image/cc.jpg';
rows = [];
cols = [];
dataWidth = 24;

%% 读取图片
image = imread(imageFilename);
if isempty(rows)
    [rows,cols,~] = size(image);
else
    image = imresize(image,[rows,cols]);
end
figure;imshow(image);
title('原始图像');

%% 图像处理
% image = rgb2gray(image);
% figure;imshow(image);
% title('灰度图');

%% 数据
switch(dataWidth)
    case 1 % 二值图
        data = logical(image);
    case 8 % 灰度图
        data = uint8(image);
    case 16 % 16位彩色图
        image = double(image);
        R = fix(image(:,:,1) / 8);
        G = fix(image(:,:,2) / 4);
        B = fix(image(:,:,3) / 8);
        data = uint16(R * 32 * 64 + G * 32 + B);
    case 24  % 24位彩色图
        image = double(image);
        R = image(:,:,1);
        G = image(:,:,2);
        B = image(:,:,3);
        data = uint32(R * 256 * 256 + G * 256 + B);      
    otherwise
        error('dataWidth数值有误');
end

%% 写文件
fid = fopen(textFilename,'w');
fprintf(fid,'%u\n',data');
fclose(fid); % 关闭文件
