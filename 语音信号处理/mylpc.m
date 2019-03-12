function [a,e,k] = mylpc(x,p,option)
%MYLPC - Linear prediction filter coefficients
%
%   This MATLAB function finds the coefficients of a pth-order linear predictor (FIR
%   filter) that predicts the current value of the real-valued time series x based
%   on past samples.
%
%   a = mylpc(x,p)
%   a = mylpc(P,p,option)
%   [a,e] = mylpc(...)
%   [a,e,k] = mylpc(...)

%% 检查参数数目
narginchk(2,3);
nargoutchk(0,3);

%% 缺省参数处理
if nargin<3
    option = 'x';
end

%% 参数处理
if p>=length(x)
    error('参数p值必须小于x（或P）的长度');
end

%% 计算LPC
% 计算自相关函数
if strcmpi(option,'x')
    r = ifftshift(xcorr(x)); %输入时域信号
elseif strcmpi(option,'P')
    r = ifft(x); %输入功率谱
else
    error('option必须为''x''或''p''');
end
r = r(1:p+1);
r = r(:);
a = 1;
epsilon = r(1);
for i=2:p+1
    if epsilon==0
        epsilon = eps;
    end
    gamma = -r(2:i)'*flipud(a)/epsilon;
    a = [a;0]+gamma*[0;conj(flipud(a))];
    epsilon = epsilon*(1-abs(gamma)^2);
end
e = epsilon;
k = gamma;


