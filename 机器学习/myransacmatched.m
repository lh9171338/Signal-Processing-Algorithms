function [models,clusters] = myransacmatched(callbacks,data,modelPoints,nModels,minNumInliers,threshold,confidence,maxIters)
%MYRANSACMATCHED - RANdom SAmple Consensus algorithm of matched data
%
%   models = myransacmatched(callbacks,data,modelPoints,nModels,minNumInliers,threshold)
%   models = myransacmatched(callbacks,data,modelPoints,nModels,minNumInliers,threshold,confidence)
%   models = myransacmatched(callbacks,data,modelPoints,nModels,minNumInliers,threshold,confidence,maxIters)
%   [models,clusters] = myransacmatched(__)


%% 参数检查
narginchk(6,8);
nargoutchk(1,2);

%% 缺省参数处理
if nargin < 7
    confidence = 0.99;   
    maxIters = 1000;    
elseif nargin < 8
    maxIters = 1000;
end

%% 获取回调函数
calcModel = callbacks.calcModel;
calcDistance = callbacks.calcDistance;

%% RANSAC算法
models = [];
clusters = [];
dataLen = size(data,1);
leftIndexes = 1:dataLen;
for i=1:nModels
    leftDataLen = length(leftIndexes);
    if leftDataLen < minNumInliers
        break;
    end
    maxNumInliers = minNumInliers;
    niters = maxIters;
    bestModel = [];
    bestIndexes = [];
    for iter=1:maxIters
        if iter > niters
            break;
        end
        %% 随机选择modelPoints个数据作为内点
        idx = randperm(leftDataLen,modelPoints);
        idx = leftIndexes(idx);
        subData = data(idx,:);
        %% 计算模型
        model = calcModel(subData);
        %% 估计符合模型的内点
        distance = calcDistance(model,data(leftIndexes,:));
        indexes = leftIndexes(distance <= threshold);
        numInliers = length(indexes);
        %% 更新
        if numInliers >= maxNumInliers
            maxNumInliers = numInliers;
            bestModel = model;
            bestIndexes = indexes;
            newniters = ceil(log(1 - confidence) / log(1 - (numInliers / leftDataLen) ^ modelPoints));
            if newniters < niters
                niters = newniters;
            end
        end
    end
    if ~isempty(bestModel)
        bestModel = calcModel(data(bestIndexes,:));
        leftIndexes = setdiff(leftIndexes,bestIndexes);
    end
    models = cat(1,models,bestModel);
    clusters = cat(1,clusters,{bestIndexes});
end
