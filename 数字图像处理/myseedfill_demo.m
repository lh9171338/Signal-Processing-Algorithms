%myseedfill_demo.m
%种子填充示例
clc,clear;
close all;

%% 读取图片
filename = 'text.png';
f = imread(filename);
figure;
imshow(f,[]);

%% 种子填充
seed = false(size(f));
seed(13,94) = 1;
g = myseedfill(f,seed);
figure;
imshow(g,[]);

