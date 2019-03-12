function [label,num] = mybwlabel(bw,conn)
%MYBWLABEL - Label connected components in 2-D binary image
%
%   L = mybwlabel(BW)
%   L = mybwlabel(BW,conn)
%   [L,num] = mybwlabel(...)

%% 基于种子填充算法

%% 参数检查
narginchk(1,2);
nargoutchk(0,2);

%% 缺省参数处理
if nargin<2
    conn = 8;   %默认8邻域
end

%% 参数值检测
%参数f
[rows,cols,ch] = size(bw);
if ch~=1
    error('输入图像BW必须为二值图');
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
label = zeros(rows,cols);
num = 0;
%遍历图片
for y=1:rows
    for x=1:cols
        if bw(y,x)==1 && label(y,x)==0 %寻找种子
            num = num+1;
            stack = [];
            stack = cat(1,stack,[x,y]); %种子压栈
            label(y,x) = num;
            while(~isempty(stack))
                seed = stack(end,:);
                stack(end,:) = [];
                %遍历4邻域或8邻域
                for i=1:conn
                    x2 = seed(1) + dxy(i,1);
                    y2 = seed(2) + dxy(i,2);
                    if (y2>0 && y2<=rows) && (x2>0 && x2<=cols)
                        if bw(y2,x2)==1 && label(y2,x2)==0
                            stack = cat(1,stack,[x2,y2]); %种子压栈
                            label(y2,x2) = num;
                        end                        
                    end
                end
            end
        end
    end
end
    