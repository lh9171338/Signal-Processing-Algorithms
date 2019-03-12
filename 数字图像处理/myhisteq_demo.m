%myhisteq_demo.m
%直方图均衡化示例
%%
clc,clear;
close all;

%% 读取图像
img_src = imread('F:\MATLAB\function\src\histeq.jpg');
%获取图片宽度和高度
[H,W,C] = size(img_src);
%若原图为彩色图，则转灰度图
if C==3
    img_src = rgb2gray(img_src); 
end
%显示图像
figure;
imshow(img_src);
%计算并绘制直方图
figure;
myimhist(img_src);

%% 直方图均衡化
img_eq1 = myhisteq(img_src);
figure;
imshow(img_eq1);
%计算并绘制均衡化后的直方图
figure;
myimhist(img_eq1);

%% 使用改进方法进行直方图均衡化
img_eq2 = myimprovedhisteq(img_src);
figure;
imshow(img_eq2);
%计算并绘制均衡化后的直方图
figure;
myimhist(img_eq2);
