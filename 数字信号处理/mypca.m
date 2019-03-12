function varargout = mypca(X,dim)
%MYPCA - Principal Component Analysis.
%
%   [V,D] = mypca(X)
%   Y = mypca(X,dim)
%   [Y,V,D] = mypca(X,dim)
%   [Y,V,D] = mypca(X,[])

% X：输入数据，m*n矩阵，即m个n维向量
% Y：降维后的数据，m*dim矩阵(dim<n)
% V：特征向量矩阵，n*n矩阵
% D：特征值矩阵，n*n矩阵
% 协方差矩阵：A = Cov(X)
% 协方差矩阵的特征值分解：A = V*D*V'

%% 检查参数数目
narginchk(1,2);
nargoutchk(1,3);

%% 获取参数
[~,n] = size(X); % 数据维度

%% 协方差矩阵的特征值分解
A = cov(X); % 计算X的协方差矩阵A
[V,D] = eig(A); % 对协方差矩阵A进行特征值分解
lamda = diag(D); % 将特征值对~角矩阵转为列向量
[lamda,idx] = sort(lamda,'descend'); % 对特征值进行降序排序
V = V(:,idx); % 按特征值大小顺序改变特征向量的顺序
D = diag(lamda);

%% 降维输出
if nargin == 2
    if isempty(dim) % dim = [] 则选取占特征值能量90%的特征值
        en = sum(lamda.^2);
        thresh = en*0.9;
        acc_en = cumsum(lamda.^2);
        pos = find(acc_en > thresh);
        dim = pos(1);
    elseif dim <=0 || dim >= n
        error('参数dim范围为1~n-1');
    end
    Y = X*V(:,1:dim);
end
    
%% 输出
if nargin < 2
    varargout = {V,D};
else
    if nargout == 1
        varargout = {Y};
    else
        varargout = {Y,V,D};
    end
end







