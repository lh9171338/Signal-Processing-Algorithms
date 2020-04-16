function [models,clusters] = myjlinkagefitting(callbacks,data,modelPoints,nModels,numHypotheses,threshold)
%MYJLINKAGEFITTING - Model fitting based on J-Linkage clustering algorithm.
%
%   models = myjlinkagefitting(callbacks,data,modelPoints,nModels,numHypotheses,threshold)
%   [models,clusters] = myransacmatched(__)

%% 参数检查
narginchk(6,6);
nargoutchk(1,2);

%% 获取回调函数
calcModel = callbacks.calcModel;
calcDistance = callbacks.calcDistance;

%% 计算偏好集矩阵
numData = size(data,1);
P = zeros(numData,numHypotheses);
for i=1:numHypotheses
    indexes = randperm(numData,modelPoints);
    subData = data(indexes,:);
    model = calcModel(subData);
    distances = calcDistance(model,data);
    mask = distances <= threshold;
    P(:,i) = 1;
    P(~mask,i) = 0;
end

%% J-Linkage聚类
clusters = mytlinkage(P);

%% 计算模型
nClusters = length(clusters);
nModels = min(nModels,nClusters);
clusters = clusters(1:nModels);
models = [];
for i=1:nModels
    indexes = clusters{i};
    subData = data(indexes,:);
    model = calcModel(subData);
    models = cat(1,models,model);
end
