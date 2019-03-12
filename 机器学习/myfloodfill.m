function g = myfloodfill(f,point,newval,range,neighbor,fixedrange)
%MYFLOODFILL - Flood filling
%
%   g = myfloodfill(f)
%   g = myfloodfill(f,neighbor)
%   g = myfloodfill(f,neighbor,fixedrange)

%% myfloodfill:漫水填充算法
% f：灰度图或彩色图
% point：种子点
% newval：填充的颜色
% neighbor：4邻域或8邻域
% fixedrange：固定范围或浮动范围

%% 参数检查
narginchk(3,6);
nargoutchk(1,1);

%% 缺省参数处理
if nargin<4
    range = [0,0];
    neighbor = 4;   %默认4邻域
    fixedrange = true;
elseif nargin<5
    neighbor = 4;   %默认4邻域
    fixedrange = true;
elseif nargin<6
    fixedrange = true;
end

%% 参数值检测
%参数f
[rows,cols,ch] = size(f);
f = double(f);
%参数point
x = point(1);
y = point(2);
if (x<1 || x>cols) || (y<1 || y>rows)
    error('point坐标超出了图像f的范围');
end
%参数range
if ch==3 && size(range,2)==1
    range = repmat(range,1,3); %复制成3维（RGB）
end

%% 颜色阈值
val = reshape(f(point(2),point(1),:),1,ch);
lowthresh = val + range(1,:);
highthresh = val + range(2,:);

%% 邻域
if neighbor==4  %4邻域
    dxy = [-1,0;0,-1;1,0;0,1];
elseif neighbor==8 %8邻域
    dxy = [-1,-1;0,-1;1,-1;-1,0;1,0;-1,1;0,1;1,1];
else
    error('参数neighbor必须为4或8');
end

%% 算法
g = f;
label = zeros(rows,cols);
stack = []; %存种子的栈
stack = cat(1,stack,point);
%遍历种子邻域
while(~isempty(stack))
    point = stack(end,:);
    stack(end,:) = [];
    x = point(1);
    y = point(2);
    label(y,x) = 1;
    g(y,x,:) = newval;
    if fixedrange==false
        val = reshape(f(y,x,:),1,ch);
        lowthresh = val + range(1,:);
        highthresh = val + range(2,:);
    end
    %遍历4邻域或8邻域
    for i=1:neighbor
        x2 = x + dxy(i,1);
        y2 = y + dxy(i,2);
        if (y2>0 && y2<=rows) && (x2>0 && x2<=cols)
            val = reshape(f(y2,x2,:),1,ch);
            if( all(val >= lowthresh)...
                && all(val <= highthresh)...
                && label(y2,x2)==0 )
                stack = cat(1,stack,[x2,y2]);
                label(y2,x2) = 1;
            end            
        end
    end
end

%% 输出图像g转为uint8类型
g = uint8(g);
    