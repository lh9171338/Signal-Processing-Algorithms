%% myconncomp_demo.m
%% 连通域处理示例
%%
clc,clear;
close all;

%% 读取图片
filename = '../src/image/cc.jpg';
f = imread(filename);
figure;
imshow(f,[]);

%% 二值化
f2 = rgb2gray(f);
thresh = graythresh(f2);
f2 = imbinarize(f2,thresh);
figure;
imshow(f2,[]);

%% 连通域检测
label = mybwlabel(f2,4);
f3 = label * 255 / max(label(:));
figure;
imshow(f3,[]);

%% 填充随机颜色
f4 = f;
[rows,cols,c] = size(f);
for i=0:max(label(:))
    rgb = round(rand(1,3)*255);
    index = label==i;
    indexr = false(rows,cols,c);
    indexg = false(rows,cols,c);
    indexb = false(rows,cols,c);
    indexr(:,:,1) = index;
    indexg(:,:,2) = index;
    indexb(:,:,3) = index;
    f4(indexr) = rgb(1);
    f4(indexg) = rgb(2);
    f4(indexb) = rgb(3);
end
figure;
imshow(f4,[]);

%% 连通域处理
cc = myconncomp(f2,4);
f5 = f;
for i=1:numel(cc)
    f5 = insertShape(f5, 'rectangle', cc(i).BoundingBox, 'Color', [255,0,0],'LineWidth', 4); 
    f5 = insertMarker(f5,cc(i).Centroid,'color','g','size',10);
end
figure;
imshow(f5,[]);

%% 移除小物体
f6 = mybwareaopen(f2,500);
figure;
imshow(f6,[]);
