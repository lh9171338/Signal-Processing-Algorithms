% myclustering_demo.m
% 聚类示例
%%
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
tic;
threshold = 1;
distanceMap = calcDistanceMap(points);
logicalMap = distanceMap <= threshold;
clusters = myclustering(logicalMap);
toc

%% 绘制结果
nModels = length(clusters);
for i=1:nModels
    color = rand(1,3);
    indexes = clusters{i};
    plot(points(indexes,1),points(indexes,2),'o','Color',color,'MarkerSize',10);
end
legend('inliers','outliers','clustering');

%% 构造函数
function distanceMap = calcDistanceMap(data)
    dim = size(data,1);
    data1 = repmat(data,[1,1,dim]);
    data1 = permute(data1,[3,2,1]);
    diff = data1 - data;
    distanceMap = vecnorm(diff,2,2);
    distanceMap = permute(distanceMap,[1,3,2]);
end
