%% mysobel_demo.m
%% Sobel算子边缘检测
%%
clc,clear;
close all;

%% 读取图片
f = imread('../src/image/lena.jpg');
figure;imshow(f);
title('原始图像');

%% 边缘检测
[g,gx,gy] = mysobel(f);
bw = mysobel(f,0.2); %使用阈值二值化
figure;imshow(gx,[]);
title('x方向边缘');
figure;imshow(gy,[]);
title('y方向边缘');
figure;imshow(g);
title('总边缘');
