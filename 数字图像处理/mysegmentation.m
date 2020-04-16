function [g,num_ccs] = mysegmentation(f,sigma,c,min_size)
%MYSEGMENTATION - Graph-Based Image Segmentation.
%
%   This MATLAB function segments the image basing on graph
%
%   [g,num_ccs] = mysegmentation(f,sigma,c,min_size)

tic;
%% 预处理
% 获取图像宽度和高度
[rows,cols,ch] = size(f);
g = uint8(zeros(rows,cols,ch));
num_vertices = rows*cols;
% 图像转double类型，提高后面高斯滤波的精度
f = double(f);
% 高斯滤波
sigma = max(sigma,0.1);
kSize = 2*ceil(2*sigma)+1;
H = fspecial('gaussian',kSize);
f = imfilter(f,H,'replicate');

%% 构建图
edges(rows*cols*4) = struct('a',[],'b',[],'w',[]);
edge = struct('a',[],'b',[],'w',[]);
num_edges = 0;
for y=1:rows
    for x=1:cols
        if x < cols % right
            edge.a = (y-1)*cols+x;
            edge.b = (y-1)*cols+x+1;
            diff = f(y,x,:)-f(y,x+1,:);
            edge.w = sqrt(sum(diff.^2));
            num_edges = num_edges+1;
            edges(num_edges) = edge;
        end
        if y < rows % bottom
            edge.a = (y-1)*cols+x;
            edge.b = y*cols+x;
            diff = f(y,x,:)-f(y+1,x,:);
            edge.w = sqrt(sum(diff.^2));
            num_edges = num_edges+1;   
            edges(num_edges) = edge;
        end
        if y < rows && x < cols % bottom right
            edge.a = (y-1)*cols+x;
            edge.b = y*cols+x+1;
            diff = f(y,x,:)-f(y+1,x+1,:);
            edge.w = sqrt(sum(diff.^2));
            num_edges = num_edges+1;  
            edges(num_edges) = edge;
        end          
        if y > 1 && x < cols % up right
            edge.a = (y-1)*cols+x;
            edge.b = (y-2)*cols+x+1;
            diff = f(y,x,:)-f(y-1,x+1,:);
            edge.w = sqrt(sum(diff.^2));
            num_edges = num_edges+1;    
            edges(num_edges) = edge;
        end 
    end
end
edges = edges(1:num_edges);

%% 对edges按权重由小到大排序
weights = zeros(num_edges,1);
for i=1:num_edges
    weights(i) = edges(i).w;
end
[~,idx] = sort(weights);
edges = edges(idx);

%% 合并图
set = segment_graph(edges,num_vertices,num_edges,c,min_size);

%% 生成返回结果
num_ccs = set.num;
% 生成随机颜色
colors = uint8(rand(rows*cols,ch)*255);
for y=1:rows
    for x=1:cols
        a = (y-1)*cols+x;
        p = set.elts(a).p;
        g(y,x,:) = colors(p,:);
    end
end

end

%% 合并图
function set = segment_graph(edges,num_vertices,num_edges,c,min_size)

%% 初始化disjoint set
set = struct('num',[],'elts',[]);
set.num = num_vertices;
elts(num_vertices) = struct('rank',[],'size',[],'p',[]);
elt = struct('rank',[],'size',[],'p',[]);
set.elts = elts;
for i=1:num_vertices
    elt.rank = 0;
    elt.size = 1;
    elt.p = i;
    set.elts(i) = elt;
end
%% 初始化阈值
threshold = zeros(num_vertices,1);
threshold(:) = c;
%% 遍历所有边
for i=1:num_edges
    edge = edges(i);
    a = edge.a;
    b = edge.b;
    w = edge.w; 
    %% find a
    p = a;
    while p ~= set.elts(p).p
        p = set.elts(p).p;
    end
    set.elts(a).p = p;
    a = p;
    %% find b
    p = b;
    while p ~= set.elts(p).p
        p = set.elts(p).p;
    end
    set.elts(b).p = p;
    b = p;
    %% 阈值判断
    if a ~= b && (w <= threshold(a) && w <= threshold(b))
        %% 合并a和b
        if set.elts(a).rank > set.elts(b).rank
            set.elts(b).p = a;
            set.elts(a).size = set.elts(a).size+set.elts(b).size;
        else
            set.elts(a).p = b;
            set.elts(b).size = set.elts(a).size+set.elts(b).size;    
            if set.elts(a).rank == set.elts(b).rank
                set.elts(b).rank = set.elts(b).rank+1;
            end
            a = b;
        end
        set.num = set.num-1;
        %% 更新阈值
        threshold(a) = w+c/set.elts(a).size;
    end
end

%% 处理小区域
for i=1:num_edges
    edge = edges(i);
    a = edge.a;
    b = edge.b;
    %% find a
    p = a;
    while p ~= set.elts(p).p
        p = set.elts(p).p;
    end
    set.elts(a).p = p;
    a = set.elts(a).p;
    %% find b
    p = b;
    while p ~= set.elts(p).p
        p = set.elts(p).p;
    end
    set.elts(b).p = p;
    b = p;
    % 阈值判断
    if (a ~= b) && (set.elts(a).size < min_size || set.elts(b).size < min_size)
        %% 合并a和b
        if set.elts(a).rank > set.elts(b).rank
            set.elts(b).p = a;
            set.elts(a).size = set.elts(a).size+set.elts(b).size;
        else
            set.elts(a).p = b;
            set.elts(b).size = set.elts(a).size+set.elts(b).size;    
            if set.elts(a).rank == set.elts(b).rank
                set.elts(b).rank = set.elts(b).rank+1;
            end
        end
        set.num = set.num-1;
    end
end

end
