function varargout = mydtw(x,y)
%MYDTW - Dynamic Time Warping
%
%   dist = mydtw(x,y)
%   [dist,indices] = mydtw(x,y)

%% 参数检查
narginchk(2,2);
nargoutchk(1,2);

%% 输入参数处理
if isvector(x)
    x = x(:);
end
if isvector(y)
    y = y(:);
end

%% 计算距离矩阵
m = size(x,1);
n = size(y,1);
distMatrix = ones(m+1,n+1)*realmax;
distMatrix(1,1) = 0;
diff = reshape(x',[],m,1)-reshape(y',[],1,n);
distMatrix(2:end,2:end) = vecnorm(diff,2,1);
parentMatrix = zeros(m+1,n+1,2);

%% 动态规划
for i = 1:m
    for j = 1:n
        d1 = distMatrix(i,j+1); %下方
        d2 = distMatrix(i+1,j); %左方
        d3 = distMatrix(i,j); %左下方
        if d1 <= d2 && d1 <= d3
            distMatrix(i+1,j+1) = d1;
            parentMatrix(i+1,j+1,:) = [i,j+1];
        elseif d2 < d1 && d2 < d2
            distMatrix(i+1,j+1) = d2;
            parentMatrix(i+1,j+1,:) = [i+1,j];
        else
            distMatrix(i+1,j+1) = d3;
            parentMatrix(i+1,j+1,:) = [i,j];
        end
    end
end
dist = distMatrix(n+1,m+1);

%% 回溯
indices = [];
i = m+1;
j = n+1;
while i > 1 && i > 1
    indices = vertcat(indices,[i-1,j-1]);
    index = parentMatrix(i,j,:);
    i = index(1,1,1);
    j = index(1,1,2);
end
indices = indices(end:-1:1,:);

%% 输出
if nargout == 1
    varargout = {dist};
else
    varargout = {dist,indices};
end
