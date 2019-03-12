function dist = mydist(test,data)
%MYDIST - Compute the distance
%   
%   dist = mydist(test,data)

rows = size(data,1); %计算data行数
test = repmat(test,rows,1); %将test扩展为rows行
diffmat = test-data; %将test与所有data作差
dist = sqrt(sum(diffmat.^2,2)); %计算test与所有data的欧式距离