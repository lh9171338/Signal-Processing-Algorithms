function g = mykmeanssegment(f,k)
%MYKMEANSSEGMENT - Picture segment by K-menas
%
%   g = mykmeanssegment(f)
%   g = mykmeanssegment(f,k)

%% 参数处理
if nargin<2
    k = 2;
end

%% 输入图像f处理
[rows,cols] = size(f);  %获取图像尺寸
f = double(f); %转为有符号数double类型
f = f(:);   %转为列向量

%% K-mean聚类
indf = mykmeans(f,k,struct('MaxIter',100,'Delta',1));

%% k值化
grayrank = round(linspace(0,255,k));  %灰度等级
for i=1:k
    f(indf==i) = grayrank(i);
end

%% 向量转为矩阵
g = reshape(f,[rows,cols]);
g = uint8(g);
