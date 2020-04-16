function y = mymovefilt(x,n)
%MYMOVEFILT - Moving average filter
%
%   y = mymovefilt(x,n)

%% 检查参数数目
narginchk(2,2);
nargoutchk(0,1);

%% 参数处理
nx = length(x);
if n>nx
    error('阶数n必须小于等于x的长度');
end
if rem(n,2)==1
    p = (n-1)/2;
else
    error('阶数n必须为奇数');
end

%% 滑动平均滤波
y = x;
for i=p+1:nx-p
    y(i) = sum(x(i-p:i+p))/n;
end

