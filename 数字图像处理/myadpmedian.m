function g = myadpmedian(f,maxw)
%MYADPMEDIAN - Adptive median filter
%
%   g = myadpmedian(f)
%   g = myadpmedian(f,maxw)

%% 参数检查
narginchk(1,2);
nargoutchk(0,1);

%% 缺省参数处理
if nargin<2
    maxw = 7;   %默认最大邻域范围
end

%% 算法
[rows,cols] = size(f);
g = f;
flag = false(rows,cols);
%i纵坐标,j横坐标
for i=1:rows       
    for j=1:cols    
        w = 1;
        %%%%%%%%确定窗口
        while flag(i,j)==0
            left = j-w;
            right = j+w;
            top = i-w;
            bottom = i+w;
            left = max(left,1);
            right = min(right,cols);
            top = max(top,1);
            bottom = min(bottom,rows);        
            %邻域确定完毕
            region = f(top:bottom,left:right);
            region = region(:);     %转为列向量
            smin = min(region);
            smax = max(region);
            smed = median(region);
            sij = f(i,j);
            %确定最大最小值结束
            if (smed>smin) && (smed<smax)
                if (sij>smin) && (sij<smax)
                    g(i,j) = sij; 
                else
                    g(i,j) = smed;
                end
                flag(i,j) = 1; %处理完成标记
            else
                if w <= maxw %扩大邻域范围
                    w = w+1; 
                else
                    g(i,j) = smed;
                    flag(i,j) = 1; %处理完成标记
                end
            end
        end    
    end       
end            
    