function g = myregiongrow(f,seed,thresh,conn)
%MYREGIONGROW - Perform segmeation by region graowing
%
%   g = myregiongrow(f,seed,thresh)
%   g = myregiongrow(f,seed,thresh,conn)

%% 参数检查
narginchk(3,4);
nargoutchk(0,1);

%% 缺省参数处理
if nargin<4
    conn = 8;   %默认8邻域
end

%% 参数值检测
%参数f
f = double(f);
%参数seed
if numel(seed)==1 %seed为标量
    seedvalue = seed;
    seed = f==seed;
else
    seed = bwmorph(seed,'shrink',inf);
    seedvalue = f(seed);
end

%% 阈值处理
bw = false(size(f));
nseed = length(seedvalue);
for n=1:nseed
    temp = abs(f-seedvalue(n)) <= thresh;
    bw = bw | temp;
end

%% 种子填充
g = myseedfill(bw,seed,conn);
% g = imreconstruct(seed,bw);

