function [IDX,Y] = mykmeans(X,k,option)
%MYKMEANS - K-means clustering
%
%    This MATLAB function partitions the points in the n-by-p data matrix X into k
%    clusters.
%
%   IDX = mykeams(X,k)
%   IDX = mykeams(X,k,option)
%   [IDX,Y] = mykeams(...)

%% 参数检查
narginchk(2,3);
nargoutchk(1,2);

%% 输入参数值检查
% 参数X
if ismatrix(X)
    [num,~] = size(X);
    X = double(X);
else
    error('输入参数X必须是矩阵');
end
% 参数k
if k>num
    error('输入参数k值超过X的向量个数');
end
% 参数option
if nargin<3
    option = struct('MaxIter',100,'Delta',1e-4,'Display','off');
end
% 获取maxiter
if isfield(option,'MaxIter')
    maxiter = option.MaxIter;
else
    maxiter = 100;
end
% 获取delta
if isfield(option,'Delta')
    delta = option.Delta;
else
    delta = 1e-4;
end
% 获取dispaly
if isfield(option,'Display')
    display = option.Display;
else
    display = 'off';
end

%% 获得初始种子点（聚类中心）
[~, index] = crossvalind('LeaveMOut', num, k);  %X中的num个向量随机选取k个作为初始种子
Y = X(index,:);

%% 迭代
IDX = zeros(num,1); % X中向量Vj所属的类
d = zeros(1,k); % X中向量Vj到k个聚类中心的欧式距离
D = zeros(1,maxiter); % 第i次迭代时的总距离
deltai = zeros(1,maxiter); % 第i次迭代时总距离的相对改变量
for i=1:maxiter %迭代一次更新一次聚类中心
    for j=1:num %遍历X中每个向量
        % 计算X中向量Vj到k个聚类中心的欧式距离d
        Vj = X(j,:);
        for n=1:k
            Yn = Y(n,:);
            d(n) = sqrt(sum((Vj-Yn).^2)); %d(n) = ((x1-y1)^2+...+(xm-ym)^2)^0.5
        end
         % 将Vj归为距离最近的类
        [dmin,pos] = min(d);
        D(i) = D(i)+dmin;
        IDX(j) = pos;
    end
    % 更新k个聚类中心
    for j=1:k
        % 选出X中属于第j类的向量
        Class = X(IDX==j,:); 
        % 计算新的聚类中心
        if ~isempty(Class)
            if size(Class,1)==1
                Y(j,:) = Class;
            else
                Y(j,:) = mean(Class);
            end
        end
    end
    % 计算D(i)的改变量（减小量）
    if i==1
        deltai(i) = 1;
    else
        deltai(i) = abs(D(i)-D(i-1))/(D(i-1)+eps);
        if deltai(i)<=delta % 该变量小于阈值delta则退出迭代
            break;
        end
    end
end

%% 绘制deltai波形
if strcmp(display,'on')
    plot(deltai);
    xlabel('迭代次数');
    ylabel('总距离相对改变量');
end
