% myransacunmatched_demo.m
%% 直线拟合示例
clc,clear;
close all;

%% 生成数据
% 直线方程：y = k * x + b
model0 = [3,-1];
k0 = model0(1);
b0 = model0(2);
nInliers = 20;
nOutliers = [5,8];
% 内点
x0 = rand(nInliers,1);
y0 = k0 * x0 + b0 + 0.001 * randn(nInliers,1);
inliers = [x0,y0];
% 外点
outliers = {rand(nOutliers(1),1),rand(nOutliers(2),1)};
data1 = [inliers(:,1);outliers{1}];
data2 = [inliers(:,2);outliers{2}];
data1Len = size(data1,1);
data2Len = size(data2,1);
data1 = data1(randperm(data1Len),:);
data2 = data2(randperm(data2Len),:);

%% 绘制数据
figure;hold on;
plot(data1,zeros(data1Len,1),'r.');
plot(zeros(data2Len,1),data2,'b.');

%% 执行RANSAC算法
cb.calcModel = @calcModel;
cb.findInliers = @findInliers;
modelPoints = 1;
minNumInlier = 5;
threshold = 0.01;
maxIters = 1000;
[model,matches] = myransacunmatched(cb,[k0,[]],data1,data2,modelPoints,...
    minNumInlier,threshold,maxIters);
if isempty(model)
    disp('Failed to find the model');
end

%% 绘制结果
k = model(1);
b = model(2);
x = 0:1;
y = k * x + b;  
plot(x,y,'g');
nMatches = size(matches,1);
plot(data1(matches(:,1)),zeros(nMatches,1),'go');
plot(zeros(nMatches,1),data2(matches(:,2)),'go');
legend('inliers','outliers','line');

%% 构造回调函数
% model: y = k * x + b = [x, 1] * [k, b]'
% model: Y = H * theta'
function model = calcModel(model,data1,data2)
    X = data1;
    Y = data2;
    k0 = model(1);
    b = mean(Y - k0 * X);
    model = [k0,b];
end

function matches = findInliers(model,data1,data2,threshold)
    data1Len = size(data1,1);
    data2Len = size(data2,1);
    X = data1;
    Y = data2;
    k0 = model(1);
    b = model(2);
    Y_hat = k0 * X + b;
    Y_hat = repmat(Y_hat,1,data2Len);
    Y = repmat(Y',data1Len,1);
    errors = abs(Y_hat - Y);
    [minErrors,indexes] = min(errors,[],2);
    matches = [(1:data1Len)',indexes];
    mask = minErrors <= threshold;
    matches(~mask,:) = [];
end
