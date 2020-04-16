function score = mysimilarity(f1,f2)
%MYSIMILARITY - Compute the similarity of two figures
%
%   score = mysimilarity(f1,f2)

%% 转灰度图
% 图像1
if size(f1,3) == 3
    f1 = rgb2gray(f1);
end
% 图像2
if size(f2,3) == 3
    f2 = rgb2gray(f2);
end

%% 二值化
% 图像1
if ~islogical(f1)
    f1 = imbinarize(f1,graythresh(f1));
end
% 图像2
if ~islogical(f2)
    f2 = imbinarize(f2,graythresh(f2));
end

%% 连通域处理：找出图像中最大的物体
% 图像1
CC = regionprops(f1);
Area = zeros(1,numel(CC));
for i=1:numel(CC)
    Area(i) = CC(:).Area;
end
[area,index] = max(Area);
centroid1 = CC(index).Centroid;
f1 = bwareaopen(f1,area); %移除小物体

% 图像2
CC = regionprops(f2);
Area = zeros(1,numel(CC));
for i=1:numel(CC)
    Area(i) = CC(:).Area;
end
[area,index] = max(Area);
centroid2 = CC(index).Centroid;
f2 = bwareaopen(f2,area); %移除小物体

%% 计算边缘到质心距离
% 图像1
B = bwboundaries(f1,'noholes'); %获取边缘点 
B = B{1};
dist1 = sqrt((B(:,2)-centroid1(1)).^2+(B(:,1)-centroid1(2)).^2); %计算距离

% 图像2
B = bwboundaries(f2,'noholes'); %获取边缘点 
B = B{1};
dist2 = sqrt((B(:,2)-centroid2(1)).^2+(B(:,1)-centroid2(2)).^2); %计算距离

%% 解决伸缩问题和旋转问题
% 插值，使点数相等
nd1 = length(dist1);
nd2 = length(dist2);
if nd1 > nd2
    x = linspace(0,1,nd2);
    xq = linspace(0,1,nd1);
    dist2 = interp1(x,dist2,xq,'spline')';
else
    x = linspace(0,1,nd1);
    xq = linspace(0,1,nd2);
    dist1 = interp1(x,dist1,xq,'spline')';   
end
np = length(dist1);
% 对齐，解决旋转问题
temp1 = repmat(dist1,1,np);
temp2 = zeros(np,np);
temp2(:,1) = dist2;
for i=2:np
    temp2(:,i) = [temp2(2:end,i-1);temp2(1,i-1)]; %移位
end
Rxyn = sum(temp1.*temp2); %图像1和图像2的互相关函数
[~,index] = max(Rxyn);
dist2 = temp2(:,index);

%% 计算相似度
R = corrcoef(dist1,dist2); %计算相似度，取值范围0-1
score = R(1,2);

%% 绘图
% 使距离均值相等
dist2 = dist2*mean(dist1)/mean(dist2);
figure;
plot(dist1,'r');
hold on;
plot(dist2,'g');
hold off;
