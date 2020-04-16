function dist = mydtw(x,y)
%MYDTW - Dynamic Time Warping
%
%   dist = mydtw(t,r)

%% 参数检查
narginchk(2,2);
nargoutchk(0,1);

%% 输入参数值检查
if isvector(x)
    x = x(:);
    y = y(:);
end

n = size(x,1);
m = size(y,1);
% 帧匹配距离矩阵
d = zeros(n,m);
for i = 1:n
    for j = 1:m
        d(i,j) = sum((x(i,:)-y(j,:)).^2);
    end
end
% 累积距离矩阵
D = ones(n+1,m+1)*realmax;
D(1,1) = 0;
% 动态规划
for i = 1:n
    for j = 1:m
        D1 = D(i,j+1); %下方
        D2 = D(i+1,j); %左方
        D3 = D(i,j); %左下方
        D(i+1,j+1) = d(i,j) + min([D1,D2,D3]);
    end
end
dist = D(n+1,m+1);
