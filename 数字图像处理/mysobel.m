function [g,gx,gy] = mysobel(f,T)
%MYSOBEL - Edge detectation by Sobel operater
%
%   g = mysobel(f)
%   g = mysobel(f,T)
%   [g,gx,gy] = mysobel(...)


%% 检查参数数目
narginchk(1,2);
nargoutchk(0,3);

%% 缺省参数处理
if nargin<2
    T = [];
end

%% 转灰度图
if size(f,3)==3
    f = rgb2gray(f);
end
f = double(f); %转double类型

%% 边缘检测
Hx = [-1,-2,-1;0,0,0;1,2,1]; %水平方向sobel算子
Hy = Hx'; %垂直方向sobel算子
gx = imfilter(f,Hx,'replicate');    %水平边缘
gy = imfilter(f,Hy,'replicate');    %竖直边缘
gx = abs(gx); %取绝对值
gy = abs(gy); %取绝对值
g = sqrt(gx.^2+gy.^2);              %边缘

%% 归一化
g = g./max(g(:));
gx = gx./max(gx(:));
gy = gy./max(gy(:));

%% 二值化
if ~isempty(T)
    g = g>=T;
end
