function g = myseedfill(f,seed,conn)
%MYSEEDFILL - Seed filling
%
%   g = myseedfill(f,seed)
%   g = myseedfill(f,seed,conn)

%% 参数检查
narginchk(2,3);
nargoutchk(0,1);

%% 缺省参数处理
if nargin<3
    conn = 8;   %默认8邻域
end

%% 参数值检测
%参数f
[rows,cols,ch] = size(f);
if ch~=1
    error('输入图像f必须为二值图');
end

%% 邻域
if conn==4  %4邻域
    dxy = [-1,0;0,-1;1,0;0,1];
elseif conn==8 %8邻域
    dxy = [-1,-1;0,-1;1,-1;-1,0;1,0;-1,1;0,1;1,1];
else
    error('参数conn必须为4或8');
end

%% 算法
g = false(rows,cols);
[seedy,seedx] = find(seed);
nseed = length(seedy);
%遍历种子
for n=1:nseed
    stack = [];
    stack = cat(1,stack,[seedx(n),seedy(n)]); %种子压栈
    g(seedy(n),seedx(n)) = 1; %标记为已处理
    while(~isempty(stack))
        point = stack(end,:); %弹出栈顶元素
        stack(end,:) = [];
        %遍历4邻域或8邻域
        for i=1:conn
            x2 = point(1) + dxy(i,1);
            y2 = point(2) + dxy(i,2);
            if (y2>0 && y2<=rows) && (x2>0 && x2<=cols)
                if f(y2,x2)==1>0 && g(y2,x2)==0
                    stack = cat(1,stack,[x2,y2]); %种子压栈
                    g(y2,x2) = 1; %标记为已处理
                end                        
            end
        end
    end    
end
