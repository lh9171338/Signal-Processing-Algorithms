function [labelMap,centroids] = mymeanshift(data,radius,distanceThresh,convergeThresh,sigma)
%MYMEANSHIFT - Mean shift clustering algorithm 
%
%   labelMap = mymeanshift(data,radius,distanceThresh)
%   labelMap = mymeanshift(data,radius,distanceThresh,convergeThresh)
%   labelMap = mymeanshift(data,radius,distanceThresh,convergeThresh,sigma)
%   [labelMap,centroids] = mymeanshift(__)


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
    [~,labelMap] = max(frequencys,[],1);
    labelMap = labelMap';
    
    %% 更新聚类中心
    centroids = vertcat(clusters.Centroid);
    for j=1:length(clusters)
        clusterData = data(labelMap==j,:);
        centroids(j,:) = mean(clusterData,1);
    end
end
       
