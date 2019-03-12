%% myfloodfill_demo.m
%漫水填充示例
clc,clear all;
close all;

%% 读取图片
filename = 'E:\MATLAB\function\src\floodfill.jpg';
f = imread(filename);
% if size(f,3)==3
%     f = rgb2gray(f);
% end
figure;
imshow(f,[]);

%% 漫水填充
seed = false(size(f,1),size(f,2));
seed(100,100) = 1;
g = myfloodfill(f,seed,[0,255,0],10);
figure;
imshow(g,[]);

%% 二值化
f2 = rgb2gray(f);
f2 = f2>mean2(f2);
figure;
imshow(f2,[]);

%% 连通域检测
label = mybwlabel(f2);
% label = bwlabel(f2);
f3 = label*255/max(label(:));
figure;
imshow(f3,[]);

%% 填充随机颜色
f4 = f;
[rows,cols,c] = size(f);
for i=0:max(label(:))
    rgb = round(rand(1,3)*255);
    index = label==i;
    indexr = false(rows,cols,c);
    indexg = false(rows,cols,c);
    indexb = false(rows,cols,c);
    indexr(:,:,1) = index;
    indexg(:,:,2) = index;
    indexb(:,:,3) = index;
    f4(indexr) = rgb(1);
    f4(indexg) = rgb(2);
    f4(indexb) = rgb(3);
end
figure;
imshow(f4,[]);
