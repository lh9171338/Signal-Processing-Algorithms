% myransacmatched_demo.m
%% 直线拟合示例
clc,clear;
close all;

%% 生成数据
% 直线方程：y = k * x + b
nModels = 2;
model0 = [3,-1;-1,1];
nInliers = [20;20];
nOutliers = 40;
inliers = [];
for i=1:nModels
    k0 = model0(i,1);
    b0 = model0(i,2);
    x0 = rand(nInliers(i),1);
    y0 = k0 * x0 + b0 + 0.01 * randn(nInliers(i),1);
    inliers = cat(1,inliers,[x0,y0]); 
end
outliers = rand(nOutliers,2);
points = [inliers;outliers];
nPoints = size(points,1);
points = points(randperm(nPoints),:);

%% 绘制数据
figure;hold on;
plot(inliers(:,1),inliers(:,2),'r.');
plot(outliers(:,1),outliers(:,2),'b.');

%% 执行RANSAC算法
cb.calcModel = @calcModel;
cb.findInliers = @findInliers;
modelPoints = 2;
minNumInlier = 5;
threshold = 0.02;
confidence = 0.99;
maxIters = 1000;
[models,masks] = myransacmatched(cb,points,modelPoints,nModels,...
    minNumInlier,threshold,confidence,maxIters);
if isempty(models)
    disp('Failed to find the model');
end

%% 降序排序
nums = sum(masks,2);
[~,idx] = sort(nums,'descend');
models = models(idx,:);
masks = masks(idx,:);

%% 绘制结果
nModels = size(models,1);
for i=1:nModels
    mask = masks(i,:)';
    k = models(i,1);
    b = models(i,2);
    x = 0:1;
    y = k * x + b;  
    plot(x,y,'g');
    plot(points(mask,1),points(mask,2),'go');
end
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

function mask = findInliers(model,data,threshold)
    n = size(data,1);
    X = data(:,1);
    Y = data(:,2);
    H = [X,ones(n,1)];
    theta = model';
    Y_hat = H * theta;
    errors = abs(Y_hat - Y);
    mask = errors <= threshold;
    mask = mask';
end

