function [y,e,w] = mywiener(x,d,n)
%MYWIENER - 1-D wiener filtering
%
%   This MATLAB function applies an order-n one-dimensional wiener filter to the
%   input vector, x.
%   
%   y = mywiener(x,d,n)
%   [y,e] = mywiener(x,d,n)
%   [y,e,w] = mywiener(x,d,n)

%% 参数检查
if isvector(x)
    if n>length(x)
        error('维纳滤波器阶数n必须小于等于信号x的长度');
    end
else
    error('输入变量x必须是一维向量');
end

%% 基于自相关、互相关的算法
rx = ifftshift(xcorr(x));   %计算输入信号x的自相关函数
rx = rx(1:n+1);             %取前n+1个自相关系数
Rxx = toeplitz(rx);         %获得n+1阶自相关矩阵
Rdx = ifftshift(xcorr(d,x));%得到参考信号d和输入信号x的互相关函数
Rdx = Rdx(1:n+1);           %取前n+1个互相关系数
w = Rxx\Rdx';               %计算维纳滤波器系数
y = filter(w,1,x); 
e = d-y; 

%% 基于网络的算法
% % 输入信号延时
% nx = length(x);
% x_in = zeros(n+1,nx); %输入信号延时后的矩阵
% x_in(1,:) = x;
% if n>0
%     for i=2:n+1
%         x_in(i,:) = filter([0,1],1,x_in(i-1,:)); %延时一个单位
%     end
% end
% R_xx = x_in*x_in';     %计算n阶自相关矩阵
% R_xx = toeplitz(R_xx(1,:));
% R_dx = d*x_in';        %计算n阶互相关向量
% w = R_xx\(R_dx');      %计算维纳滤波器系数
% y = w'*x_in;           %进行维纳滤波
% e = d-y;               %误差
