% myransacmatched_demo.m
% 直线拟合示例
%%
clc,clear;
close all;

%% 生成数据
% 直线方程：y = k * x + b
nModels = 4;
model0 = [1,-1;1,1;-1,1;-1,-1];
nInliers = [20;20;20;20];
nOutliers = 80;
inliers = [];
for i=1:nModels
    k0 = model0(i,1);
    b0 = model0(i,2);
    x0 = 2 * (rand(nInliers(i),1) - 0.5);
    y0 = k0 * x0 + b0 + 0.01 * (randn(nInliers(i),1) - 0.5);
    inliers = cat(1,inliers,[x0,y0]); 
end
outliers = 2 * (rand(nOutliers,2) - 0.5);
points = [inliers;outliers];
nPoints = size(points,1);
points = points(randperm(nPoints),:);

%% 绘制数据
figure;hold on;
plot(inliers(:,1),inliers(:,2),'r.');
plot(outliers(:,1),outliers(:,2),'b.');

%% 执行RANSAC算法
tic;
callbacks.calcModel = @calcModel;
callbacks.calcDistance = @calcDistance;
modelPoints = 2;
minNumInliers = 5;
threshold = 0.02;
confidence = 0.99;
maxIters = 1000;
[models,clusters] = myransacmatched(callbacks,points,modelPoints,nModels,...
    minNumInliers,threshold,confidence,maxIters);
if isempty(models)
    disp('Failed to find the model');
end
toc

%% 绘制结果
nModels = size(models,1);
for i=1:nModels
    indexes = clusters{i};
    k = models(i,1);
    b = models(i,2);
    x = -1:1;
    y = k * x + b;  
    plot(x,y,'g');
    plot(points(indexes,1),points(indexes,2),'go');
end
axis equal;
legend('inliers','outliers','line');

%% 构造回调函数
% model: y = k * x + b = [x, 1] * [k, b]'
% model: Y = H * theta'
function model = calcModel(data)
    n = size(data,1);
    X = data(:,1);
    Y = data(:,2);
    H = [X,ones(n,1)];
    theta = H \ Y;
    model = theta';
end

function distances = calcDistance(model,data)
    n = size(data,1);
    X = data(:,1);
    Y = data(:,2);
    H = [X,ones(n,1)];
    theta = model';
    Y_hat = H * theta;
    distances = abs(Y_hat - Y);
end
