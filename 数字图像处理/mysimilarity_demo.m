%mysimilarity_demo.m
%图片相似度计算示例
%%
clc,clear all;
close all;

%% 读取图片
filename1 = 'E:\MATLAB\function\src\square1.jpg';
filename2 = 'E:\MATLAB\function\src\rectangle1.jpg';
filename3 = 'E:\MATLAB\function\src\triangle1.jpg';
filename4 = 'E:\MATLAB\function\src\ellipse1.jpg';
filename5 = 'E:\MATLAB\function\src\ellipse2.jpg'; 
f1 = imread(filename1);
f2 = imread(filename2);
f3 = imread(filename3);
f4 = imread(filename4);
f5 = imread(filename5);
f5 = imrotate(f5,45);
figure;
imshow(f1,[]);
figure;
imshow(f2,[]);
figure;
imshow(f3,[]);
figure;
imshow(f4,[]);
figure;
imshow(f5,[]);

%% 计算相似度
% score1 = mysimilarity(f1,f5);
% score2 = mysimilarity(f2,f5);
% score3 = mysimilarity(f3,f5);
% score4 = mysimilarity(f4,f5);
score1 = mysimilarity2(f1,f5);
score2 = mysimilarity2(f2,f5);
score3 = mysimilarity2(f3,f5);
score4 = mysimilarity2(f4,f5);

