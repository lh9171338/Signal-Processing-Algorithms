%jpg2mif.m
%图像转.mif文件
%%
clc,clear;
close all;

%% 参数
MifFile = 'src.mif';
ImageFile = '../src/cc.jpg';
rows = [];
cols = [];
% rows = 256;
% cols = 256;
data_width = 24;

%% 读取图片
f = imread(ImageFile);
if isempty(rows)
    [rows,cols,~] = size(f);
else
    f = imresize(f,[rows,cols]);
end
figure;
imshow(f);
title('原始图像');

%% 图像处理
% f = rgb2gray(f);
% figure;
% imshow(f);
% title('灰度图');

%% 数据
switch(data_width)
    case 1 %二值图
        data = logical(f);
    case 8 %灰度图
        data = uint8(f);
    case 16 %16位彩色图
        f = double(f);
        R = fix(f(:,:,1)/8);
        G = fix(f(:,:,2)/4);
        B = fix(f(:,:,3)/8);
        data = uint16(R*32*64+G*32+B);
    case 24  %24位彩色图
        f = double(f);
        R = f(:,:,1);
        G = f(:,:,2);
        B = f(:,:,3);
        data = uint32(R*256*256+G*256+B);      
    otherwise
        error('data_width数值有误');
end

%% 写文件
data_depth = rows * cols;
fid = fopen(MifFile,'w');
fprintf(fid,'width=%d;\n',data_width);
fprintf(fid,'depth=%d;\n',data_depth);
fprintf(fid,'address_radix=uns;\n');
fprintf(fid,'data_radix=hex;\n');
fprintf(fid,'Content Begin\n');
for y=0:rows-1
    for x=0:cols-1        fprintf(fid,'%d:%x;\n',y*cols+x,data(y+1,x+1));
    end
end
fprintf(fid,'end;');
fclose(fid);%关闭文件


