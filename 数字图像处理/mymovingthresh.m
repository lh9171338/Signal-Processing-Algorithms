function g = mymovingthresh(f,n,K)
%MYMOVINGTHRESH - Moving average threshold
%
%   g = mymovingthresh(f,n,K)

[M,N] = size(f);
f = double(f);

%% Zigzag扫描
f(2:2:end,:) = fliplr(f(2:2:end,:));
f = f';
f = f(:);

%% 计算移动均值
b = ones(1,n)/n;
ma = filter(b,1,f);

%% 阈值处理
g = f > K*ma;

%% 反Zigzag扫描
g = reshape(g,N,M)';
g(2:2:end,:) = fliplr(g(2:2:end,:));

