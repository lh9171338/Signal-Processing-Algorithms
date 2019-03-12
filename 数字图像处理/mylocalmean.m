function m = mylocalmean(f,nhood)
%MYLOCALMEAN - Local means
%
%   m = mylocalmean(f)
%   m = mylocalmean(f,nhood)

%% 参数检查
narginchk(1,2);
nargoutchk(0,1);

%% 缺省参数处理
if nargin<2
    nhood = ones(3)/9;   %默认3*3
else
    nhood = nhood/sum(nhood(:));
end

%% 计算局部均值
m = imfilter(f,nhood,'replicate');


