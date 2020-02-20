function [model,matches] = myransacunmatched(cb,model,data1,data2,modelPoints,minNumInlier,threshold,maxIters)
%MYRANSACUNMATCHED - RANdom SAmple Consensus algorithm of unmatched data
%
%   model = myransacunmatched(cb,model,data1,data2,modelPoints,minNumInlier,threshold)
%   model = myransacunmatched(cb,model,data1,data2,modelPoints,minNumInlier,threshold,maxIters)
%   [model,matches] = myransacunmatched(_)


%% 参数检查
narginchk(7,8);
nargoutchk(1,2);

%% 缺省参数处理  
if nargin < 8
    maxIters = 1000;
end

%% 获取回调函数
calcModel = cb.calcModel;
findInliers = cb.findInliers;

%% RANSAC算法
matches = [];
data1Len = size(data1,1);
data2Len = size(data2,1);
minDataLen = min(data1Len,data2Len);
maxNumInlier = minNumInlier;

if minDataLen < modelPoints
    return;
else
    bestModel = [];
    bestMatches = [];
    for iter=1:maxIters
        %% 随机选择modelPoints个数据作为内点
        idx1 = randperm(data1Len,modelPoints);
        idx2 = randperm(data2Len,modelPoints);
        
        %% 计算模型
        model = calcModel(model,data1(idx1,:),data2(idx2,:));

        %% 估计符合模型的内点
        matches = findInliers(model,data1,data2,threshold);
        numInlier = size(matches,1);
        
        %% 更新
        if numInlier >= maxNumInlier
            maxNumInlier = numInlier;
            bestModel = model;
            bestMatches = matches;
        end
    end
    if ~isempty(bestModel)
        model = calcModel(bestModel,data1(bestMatches(:,1)),data2(bestMatches(:,2)));
        matches = bestMatches;
    end
end
