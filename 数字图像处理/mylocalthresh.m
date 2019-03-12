function g = mylocalthresh(f,nhood,a,b,meantype)
%MYLOCALTHREESH - Local thresholding
%
%   g = mylocalthresh(f,nhood,a,b)
%   g = mylocalthresh(f,nhood,a,b,meantype)

%% 参数检查
narginchk(4,5);
nargoutchk(0,1);

%% 缺省参数处理
if nargin<5
    meantype = 'global';   %默认全局阈值
end

%% 计算标准差
sigma = stdfilt(f,nhood);

%% 计算均值
if strcmpi(meantype,'global')
    m = mean2(f);
else
    m = mylocalmean(f,nhood);
end

%% 二值化
g = (f > a*sigma) & (f > b*m);


