function class = myknn(test,data,label,k)
%MYKNN - K-Nearest Neighbor clustering
%
%   class = myknn(test,data,label,k)

rows = size(data,1); %计算训练样本(data)个数
test = repmat(test,rows,1); %将测试样本(test)扩展为rows行
diffMat = test-data; %将测试样本(test)与所有训练样本(data)作差
distanceMat = sqrt(sum(diffMat.^2,2)); %计算测试样本(test)与所有训练样本(data)的欧式距离
[~,index] = sort(distanceMat,'ascend'); %将distanceMat按升序排序
len = min(k,rows); %取k和样本个数rows中的最小值
class = mode(label(index(1:len))); %取前len个label的众数