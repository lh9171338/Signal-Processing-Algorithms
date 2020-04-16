function varargout = mysvd(X,dim)
%MYSVD - Data Dimension Reduction by SVD.
%
%   [U,S,V] = mysvd(X)
%   Y = mysvd(X,dim)
%   [Y,U,S,V] = mysvd(X,dim)
%   [Y,U,S,V] = mysvd(X,[])

% X：输入数据，m*n矩阵，即m个n维向量
% Y：降维后的数据，m*dim矩阵(dim<n)
% U：左奇异向量矩阵，m*m矩阵
% S：奇异值矩阵，m*n矩阵
% V：右奇异向量矩阵，n*n矩阵
% 奇异值分解：X = U*S*V'

%% 检查参数数目
narginchk(1,2);
nargoutchk(1,4);

%% 获取参数
[~,n] = size(X); % 数据维度

%% 奇异值分解
[U,S,V] = svd(X); % 对X进行奇异值分解，奇异值已经按降序排序
lamda = diag(S);

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
    varargout = {U,S,V};
else
    if nargout == 1
        varargout = {Y};
    else
        varargout = {Y,U,S,V};
    end
end
