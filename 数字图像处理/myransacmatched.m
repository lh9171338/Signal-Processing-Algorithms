function [models,masks] = myransacmatched(callbacks,data,modelPoints,nModels,minNumInlier,threshold,confidence,maxIters)
%MYRANSACMATCHED - RANdom SAmple Consensus algorithm of matched data
%
%   models = myransacmatched(callbacks,data,modelPoints,nModels,minNumInlier,threshold)
%   models = myransacmatched(callbacks,data,modelPoints,nModels,minNumInlier,threshold,confidence)
%   models = myransacmatched(callbacks,data,modelPoints,nModels,minNumInlier,threshold,confidence,maxIters)
%   [models,masks] = myransacmatched(_)


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
findInliers = callbacks.findInliers;

%% RANSAC算法
models = [];
masks = logical([]);
dataLen = size(data,1);
totalMask = false(1,dataLen);
for i=1:nModels
    leftIndex = find(totalMask==0);
    leftDataLen = length(leftIndex);
    if leftDataLen < minNumInlier
        break;
    end
    
    maxNumInlier = minNumInlier;
    niters = maxIters;
    bestModel = [];
    bestMask = logical([]);
    for iter=1:maxIters
        if iter > niters
            break;
        end
        %% 随机选择modelPoints个数据作为内点
        idx = randperm(leftDataLen,modelPoints);
        idx = leftIndex(idx);
        subData = data(idx,:);
        %% 计算模型
        model = calcModel(subData);
        if isempty(model)
            continue;
        end
        %% 估计符合模型的内点
        idx = findInliers(model,data(leftIndex,:),threshold);
        mask = false(1,dataLen);
        mask(leftIndex(idx)) = true;
        numInlier = sum(mask);
        %% 更新
        if numInlier >= maxNumInlier
            maxNumInlier = numInlier;
            bestModel = model;
            bestMask = mask;
            newniters = ceil(log(1 - confidence) / log(1 - (numInlier / leftDataLen) ^ modelPoints));
            if newniters < niters
                niters = newniters;
            end
        end
    end
    if ~isempty(bestModel)
        bestModel = calcModel(data(bestMask,:));
        totalMask(bestMask) = true;
    end
    models = cat(1,models,bestModel);
    masks = cat(1,masks,bestMask);
end

    