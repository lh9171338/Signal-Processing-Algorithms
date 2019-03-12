function g = mybwareaopen(f,area,conn)
%MYBWAREAOPEN - Remove small objects from binary image
%
%   g = mybwareaopen(f,area)
%   g = mybwareaopen(f,area,conn)

%% 参数检查
narginchk(2,3);
nargoutchk(0,1);

%% 缺省参数处理
if nargin<3
    conn = 8;   %默认8邻域
end

%% 连通域检测
label = mybwlabel(f,conn);

%% 去除小物体
g = f;
numcc = max(label(:)); %连通域数量
for i=1:numcc
    index = label==i;
    Area = sum(index(:));
    if(Area < area)
        g(index) = 0; %灰度置0
    end
end

