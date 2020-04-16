%% mysaliencydetect_demo.m
%% ÏÔÖøĞÔ¼ì²âÊ¾Àı
%% 
clc,clear;
close all;

%% ÔØÈëÍ¼Æ¬
img = imread('../src/image/cc.jpg');
figure;
imshow(img);

%% ÏÔÖøĞÔ¼ì²â
[rects,objectMap] = mysaliencydetect(img);
for i=1:size(rects,1)
    img = insertShape(img,'rectangle',rects,'Color',[255,0,0],'LineWidth',4); 
end
figure;imshow(objectMap);
figure;imshow(img);
