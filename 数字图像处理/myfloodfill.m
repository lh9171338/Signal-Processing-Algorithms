function g = myfloodfill(f,seed,newval,thresh,conn)
%MYFLOODFILL - Flood filling
%
%   g = myfloodfill(f,seed,newval)
%   g = myfloodfill(f,seed,newval,thresh)
%   g = myfloodfill(f,seed,newval,thresh,conn)

%% myfloodfill:漫水填充算法
% f：灰度图或彩色图
% seed：种子点
% newval：填充的颜色
% thresh：判断相似点的阈值
% conn：4邻域或8邻域

%% 参数检查
narginchk(3,5);
nargoutchk(0,1);

%% 缺省参数处理
if nargin<4
    thresh = 0;     %默认阈值为0
    conn = 8;   %默认8邻域
elseif nargin<5
    conn = 8;   %默认8邻域
end

%% 参数值检测
ch = size(f,3);
if ch == 3 %彩色图
    if length(thresh) == 1
        thresh = repmat(thresh,1,3);
    end 
end

%% 漫水填充
g = f;

if ch == 3  
    for i=1:3 %3个通道分别处理
        index = false(size(f));
        index(:,:,i) = myregiongrow(f(:,:,i),seed,thresh(i),conn);
        g(index) = newval(i);       
    end
else 
    index = myregiongrow(f,seed,thresh,conn);
    g(index) = newval;
end


    