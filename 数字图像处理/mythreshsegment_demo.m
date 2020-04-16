%% mythreshsegment_demo.m
%% 图像阈值分割示例
%% 
clc,clear;
close all;

%%
addpath('../机器学习');

%% 读取图片
filename = '../src/image/Fig1019(a).tif';
f = imread(filename);
if size(f,3)==3
    f = rgb2gray(f);
end
figure;
imshow(f,[]);
title('原始图像');

%% 全局阈值法检测
f1 = myglobalthresh(f);
figure;imshow(f1,[]);
title('全局阈值法');

%% K-means2聚类检测
f2 = mykmeanssegment(f,3);
figure;imshow(f2,[]);
title('K-means');

%% 大津法
T = myostuthresh(f);
f3 = imbinarize(f,T);
figure;imshow(f3,[]);
title('大津法');

%% 局部阈值法
f4 = mylocalthresh(f,ones(3),30,1);
figure;imshow(f4,[]);
title('局部阈值法');

%% 移动平均法
f5 = mymovingthresh(f,20,0.5);
figure;imshow(f5,[]);
title('移动平均法');
