function S = myfastica(X,maxiter)
%MYFASTICA - Fast Independent Component Analysis.
%
%   S = myfastica(X)

% X：输入数据，m*n矩阵，即m个样本
% S：分解出来的独立成分，，m*n矩阵，即m个独立成分

%% 检查参数数目
narginchk(1,2);
nargoutchk(1,1);

%% 获取参数
if nargin < 2
    maxiter = 100;
end
[m,~] = size(X);
alpha = 1;
thresh = 0.0001; % 判断收敛的阈值

%% 样本预处理
% 中心化
means = mean(X,2);
X = X-means; 
% 白化
[U,D] = eig(X*X'); % 对X的协方差矩阵进行特征值分解
V = sqrt(D)\U'; % 白化矩阵
X = V*X;

%% 迭代优化W
% 随机初始化W
W = rand(m);
% 迭代
converge = false;
for i=1:maxiter
    % 计算输出值
    S = W*X; 
    % 计算输出值的tanh函数值及其导数值
    GX = tanh(alpha*S);
    G_X = alpha*(1-GX.^2); % tanh的导数
    % 更新W
    EG_X = mean(G_X,2);
    W1 = GX*X'-EG_X.*W;
    % 正交归一化（去相关，和白化操作一样）
    [U,D] = eig(W1*W1'); 
    W1 = sqrt(D)\U'*W1;
    % 判断是否收敛
    A = W1*W';
    W = W1;
    delta = max(abs(abs(diag(A))-1));
    if delta < thresh
        converge = true;
        break;
    end
end
if ~converge
    disp('未收敛，请增大迭代次数!!!');
end

%% 计算独立成分
S = W*X;
