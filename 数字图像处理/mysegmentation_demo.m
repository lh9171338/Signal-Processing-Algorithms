%% mysegmentation_demo.m
%% 基于图的图像分割
%%
clc,clear;
close all;

%% 读取图片
tic;
filename = '../src/image/segment.jpg';
f = imread(filename);
figure;imshow(f,[]);

%% 转灰度图
gray = rgb2gray(f);
gray = repmat(gray,1,1,3);

%% 图像分割
sigma = 0.5;
k = 500;
min_size = 100;
[g,num_ccs] = mysegmentation(f,sigma,k,min_size);
toc

%% 显示结果
figure;imshow(g,[]);
figure;imshow(gray*0.25+g*0.75,[]);
