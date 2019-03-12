function [y,e,w] = mylmsfilt(x,d,n,u)
%MYLMSFILT - lms filtering
%
%   This MATLAB function applies an order-n adaptive filter to the
%   input vector, x, basing on LMS.
%   
%   y = mylmsfilt(x,d,n,u)

%% 参数检查
if isvector(x)
    if n>length(x)
        error('自适应滤波器阶数n必须小于等于信号x的长度');
    end
else
    error('输入变量x必须是一维向量');
end

%% 基于网络的算法
% 输入信号延时
nx = length(x);
X = zeros(n+1,nx); 
X(1,:) = x;
if n>0
    for i=2:n+1
        X(i,:) = filter([0,1],1,X(i-1,:)); %延时一个单位
    end
end
% 初始化参数
w = zeros(1,n+1); %滤波器系数
y = zeros(1,nx);  %滤波输出
e = zeros(1,nx);  %误差
% 滤波
for i=1:nx
    y(i) = w*X(:,i);        %计算滤波输出
    e(i) = d(i)-y(i);       %计算误差
    w = w+2*u*e(i)*X(:,i)';   %更新滤波器系数 
end    


