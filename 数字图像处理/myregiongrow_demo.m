%% myregiongrow_demo.m
%% 区域生长示例
%%
clc,clear;
close all;

%% 读取图片
filename = '../src/image/Fig1020(a).tif';
f = imread(filename);
figure;imshow(f,[]);

%% 区域生长
seed = f == 255;
g = myregiongrow(f,seed,50);
figure;imshow(g,[]);