%% mysimilarity_demo.m
%% 图片相似度计算
%%
clc,clear;
close all;

%% 读取图片
filename1 = '../src/image/leaf_training_1.jpg';
filename2 = '../src/image/leaf_training_2.jpg';
filename3 = '../src/image/leaf_training_3.jpg';
filename4 = '../src/image/leaf_training_4.jpg';
filename5 = '../src/image/leaf_test.jpg'; 
% filename1 = '../src/image/square1.jpg';
% filename2 = '../src/image/rectangle1.jpg';
% filename3 = '../src/image/triangle1.jpg';
% filename4 = '../src/image/ellipse1.jpg';
% filename5 = '../src/image/ellipse2.jpg'; 
f1 = imread(filename1);
f2 = imread(filename2);
f3 = imread(filename3);
f4 = imread(filename4);
f5 = imread(filename5);
f5 = imrotate(f5,45);

figure;imshow(f1,[]);
figure;imshow(f2,[]);
figure;imshow(f3,[]);
figure;imshow(f4,[]);
figure;imshow(f5,[]);

%% 计算相似度
score1 = mysimilarity(f1,f5);
score2 = mysimilarity(f2,f5);
score3 = mysimilarity(f3,f5);
score4 = mysimilarity(f4,f5);
