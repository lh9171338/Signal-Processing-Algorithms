function [clusters,centroids] = mymeanshift(data,radius,distanceThresh,convergeThresh,sigma)
%MYMEANSHIFT - Mean shift clustering algorithm 
%
%   clusters = mymeanshift(data,radius,distanceThresh)
%   clusters = mymeanshift(data,radius,distanceThresh,convergeThresh)
%   clusters = mymeanshift(data,radius,distanceThresh,convergeThresh,sigma)
%   [clusters,centroids] = mymeanshift(__)


%% 参数检查
narginchk(3,5);
nargoutchk(2,2);

%% 缺省参数处理
if nargin < 4
    convergeThresh = 1e-4;
    sigma = [];
elseif nargin < 5
    sigma = [];
end
useKernel = ~isempty(sigma);

%% 聚类
clusters([],1) = struct('Centroid',[],'Frequency',[]);
nData = size(data,1);
indexes = randperm(nData);
for i=1:nData
    %% 随机选取初始聚类中心
    idx = indexes(i);
    clusterCentroid = data(idx,:);
    clusterFrequency = zeros(1,nData);
    
    %% 迭代更新聚类中心
    while true
        vectors = data - clusterCentroid;
        lens = vecnorm(vectors,2,2);
        clusterIndexes = lens <= radius;
        clusterFrequency(clusterIndexes) = clusterFrequency(clusterIndexes) + 1;
        clusterData = data(clusterIndexes,:);
        if useKernel
            lens = lens(clusterIndexes);
            weights = mvnpdf(lens,0,sigma);
            weights = weights / sum(weights);
            newCentroid = sum(weights .* clusterData,1);
        else
            newCentroid = mean(clusterData,1);
        end
        if norm(newCentroid - clusterCentroid) <= convergeThresh
            break;
        end
        clusterCentroid = newCentroid;
    end
    
    %% 合并相同的类
    mergeFlag = false;
    if ~isempty(clusters)
        clusterCentroids = vertcat(clusters.Centroid);
        clusterDistances = vecnorm(clusterCentroids - clusterCentroid,2,2);
        [minDistance,minIndex] = min(clusterDistances);
        if minDistance <= distanceThresh
            mergeFlag = true;
            clusters(minIndex).Frequency = clusters(minIndex).Frequency + clusterFrequency;
        end
    end
    if ~mergeFlag
        cluster = struct('Centroid',clusterCentroid,'Frequency',clusterFrequency);
        clusters = cat(1,clusters,cluster);
    end
    
    %% 为所有点分配类别
    frequencys = vertcat(clusters.Frequency);
    [~,labels] = max(frequencys,[],1);
    labels = labels';
    
    %% 更新聚类中心
    centroids = vertcat(clusters.Centroid);
    for j=1:length(clusters)
        clusterData = data(labels==j,:);
        centroids(j,:) = mean(clusterData,1);
    end
end

%% 保存为clusters
clusters = [];
nClusters = max(labels);
numInliers = zeros(nClusters,1);
for i=1:nClusters
    indexes = find(labels == i);
    clusters = cat(1,clusters,{indexes});
    numInliers(i) = length(indexes);
end

%% 排序
[~,indexes] = sort(numInliers,'descend');
clusters = clusters(indexes);
centroids = centroids(indexes,:);
