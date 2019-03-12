%myregiongrow_demo.m
%区域生长示例
clc,clear all;
close all;

%% 读取图片
filename = 'F:\MATLAB\function\src\Fig1020(a).tif';
f = imread(filename);
figure;
imshow(f,[]);

%% 区域生长
seed = f == 255;
g = myregiongrow(f,seed,50);
figure;
imshow(g,[]);

