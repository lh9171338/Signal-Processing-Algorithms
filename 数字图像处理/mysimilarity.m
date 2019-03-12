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
    f1 = im2bw(f1,graythresh(f1));
end
% 图像2
if ~islogical(f2)
    f2 = im2bw(f2,graythresh(f2));
end

%% 连通域处理：找出图像中最大的物体
% 图像1
CC = regionprops(f1);
Area = zeros(1,numel(CC));
for i=1:numel(CC)
    Area(i) = CC(:).Area;
end
[area1,index] = max(Area);
rect = ceil(CC(index).BoundingBox);
xstart = rect(1);
ystart = rect(2);
xend = xstart+rect(3)-1;
yend = ystart+rect(4)-1;
obj1 = f1(ystart:yend,xstart:xend); %物体1所在矩形区域
% 图像2
CC = regionprops(f2);
Area = zeros(1,numel(CC));
for i=1:numel(CC)
    Area(i) = CC(:).Area;
end
[~,index] = max(Area);
rect = ceil(CC(index).BoundingBox);
xstart = rect(1);
ystart = rect(2);
xend = xstart+rect(3)-1;
yend = ystart+rect(4)-1;
obj2 = f2(ystart:yend,xstart:xend); %物体2所在矩形区域

%% 计算缩放因子
[rows1,cols1] = size(obj1);
[rows2,cols2] = size(obj2);
rowscale = rows1/rows2;
colscale = cols1/cols2;

%% 缩放并计算相似度
%取rowscale和colscale小的作为缩放因子
scale = min(rowscale,colscale);
%缩放物体2
scaledrows = round(rows2*scale); 
scaledcols = round(cols2*scale);
scaledobj2 = imresize(obj2,[scaledrows,scaledcols]); %scaledobj2：obj2缩放后图像
%求scaledobj2的面积
area2 = sum(sum(scaledobj2==1));
%求obj1与scaledobj2中的最大面积
maxarea = max(area1,area2);
%缩放后的物体2相对于物体1可滑动的尺寸
striderows = rows1-scaledrows+1;
stridecols = cols1-scaledcols+1;
scores = zeros(striderows,stridecols);
%滑动遍历
for i=1:striderows
    for j=1:stridecols
        % 从obj1中抠出和scaledobj2大小相同的区域
        xstart = j;
        ystart = i;
        xend = xstart+scaledcols-1;
        yend = ystart+scaledrows-1;
        region = obj1(ystart:yend,xstart:xend);
        %求region与scaledobj2的重叠面积
        overlap = region & scaledobj2;
        areaoverlap = sum(sum(overlap==1));  
        %计算重叠度（相似度）
        scores(i,j) = areaoverlap/maxarea;        
    end
end
%求最大相似度
score = max(scores(:));


