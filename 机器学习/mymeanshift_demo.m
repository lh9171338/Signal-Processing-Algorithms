% mymeanshift_demo.m
%% 均值漂移聚类示例
clc,clear;
close all;

%% 生成数据
nModels = 2;
models = [-2,0;2,0];
nInliers = [30;20];
nOutliers = 5;
inliers = [];
for i=1:nModels
    model = models(i,:);
    inlier = 0.5 * randn(nInliers(i),2) + model;
    inliers = cat(1,inliers,inlier); 
end
outliers = (rand(nOutliers,2) - 0.5) * 10;
points = [inliers;outliers];
nPoints = size(points,1);
points = points(randperm(nPoints),:);

%% 绘制数据
figure;hold on;
plot(inliers(:,1),inliers(:,2),'r.');
plot(outliers(:,1),outliers(:,2),'b.');

%% 执行聚类算法
radius = 2;
distanceThresh = 2;
convergeThresh = 1e-2;
sigma = [];
[labelMap,centroids] = mymeanshift(points,radius,distanceThresh,convergeThresh,sigma);

%% 绘制结果
nModels = max(labelMap);
for i=1:nModels
    color = rand(1,3);
    indexes = labelMap == i;
    plot(points(indexes,1),points(indexes,2),'o','Color',color,'MarkerSize',10);
    plot(centroids(i,1),centroids(i,2),'x','Color',color,...
        'MarkerSize',20,'MarkerFaceColor',color);
    rectangle('Position',[centroids(i,1)-radius,centroids(i,2)-radius,2*radius,2*radius],...
        'Curvature',[1,1],'edgecolor',color);
    axis equal;
end
legend('inliers','outliers','clustering');
