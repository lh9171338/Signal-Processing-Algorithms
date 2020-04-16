%% myhisteq_demo.m
%% 直方图均衡化示例
%%
clc,clear;
close all;

%% 读取图像
srcImage = imread('../src/image/histeq.jpg');
if size(srcImage,3) == 3
    srcImage = rgb2gray(srcImage); 
end
%显示图像
figure;imshow(srcImage);
%计算并绘制直方图
myimhist(srcImage);

%% 直方图均衡化
eqImage1 = myhisteq(srcImage);
figure;imshow(eqImage1);
%计算并绘制均衡化后的直方图
myimhist(eqImage1);

%% 使用改进方法进行直方图均衡化
eqImage2 = myimprovedhisteq(srcImage);
figure;imshow(eqImage2);
%计算并绘制均衡化后的直方图
myimhist(eqImage2);
