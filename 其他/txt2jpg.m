%txt2jpg.m
%文本文件转图像
%%
clc,clear;
close all;

%% 参数
TextFile = 'src.txt';
ImageFile = 'dst.jpg';
rows = 300;
cols = 300;
data_width = 24;

%% 读文件
fid = fopen(TextFile,'r');
data = fscanf(fid,'%u\n');
fclose(fid);%关闭文件
data = reshape(data,cols,rows)';

%% 数据
switch(data_width)
    case 1 %二值图
        f = logical(data);
    case 8 %灰度图
        f = uint8(data);
    case 16 %16位彩色图
        R = fix(data/2048);
        G = fix(rem(data,2048)/32);
        B = rem(data,32);
        f = uint8(cat(3,R,G,B));
    case 24  %24位彩色图
        R = rem(fix(data/65536),256);
        G = fix(rem(data,65536)/256);
        B = rem(data,256);
        f = uint8(cat(3,R,G,B));
    otherwise
        error('data_width数值有误');
end

%% 保存图片并显示
figure;
imshow(f);
imwrite(f,ImageFile); 