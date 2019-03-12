%mysimilarity2_demo.m
%图片相似度计算示例
%%
clc,clear;
close all;

%% 读取图片
filename1 = 'E:\MATLAB\function\src\leaf_training_1.jpg';
filename2 = 'E:\MATLAB\function\src\leaf_training_2.jpg';
filename3 = 'E:\MATLAB\function\src\leaf_training_3.jpg';
filename4 = 'E:\MATLAB\function\src\leaf_training_4.jpg';
filename5 = 'E:\MATLAB\function\src\leaf_test.jpg'; 
f1 = imread(filename1);
f2 = imread(filename2);
f3 = imread(filename3);
f4 = imread(filename4);
f5 = imread(filename5);
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

%% 负片变换
f1 = imcomplement(f1);
f2 = imcomplement(f2);
f3 = imcomplement(f3);
f4 = imcomplement(f4);
f5 = imcomplement(f5);

%% 计算相似度
score1 = mysimilarity2(f1,f5);
score2 = mysimilarity2(f2,f5);
score3 = mysimilarity2(f3,f5);
score4 = mysimilarity2(f4,f5);
