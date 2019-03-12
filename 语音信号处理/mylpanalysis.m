function varargout = mylpanalysis(varargin)
%MYLPANALYSIS - Signal analysis by linear prediction
%
%   This MATLAB function finds the parameters of the system and 
%   excitation by linear predition.
%
%   lpcparam = mylpanalysis(x,fs,nwin,p)

%% 参数处理
% 检查参数数目
narginchk(4,4);
nargoutchk(0,1);

% 获取输入参数值
[x,fs,nwin,p] = varargin{:};

% 检查输入参数值
% 检查参数x
if isvector(x)==1
    x = x(:);   % 将x转为列向量
else
    error('输入参数x必须为1维数组');
end
% 检查参数p
if p>=nwin
    error('输入参数p必须小于nwin');
end

%% 预加重
% R=1-b*Z^-1
x = filter([1,-0.95],1,x);

%% 分帧
frame = myframing(x,nwin,0,'truncation');
% 帧数
nframe = size(frame,1);

%% LP分析
a = zeros(nframe,p+1);      %线性预测系数
amp = zeros(nframe,1);      %激励最大幅度
e = zeros(nframe,nwin);
for i=1:nframe
    % lpc分析
    a(i,:) = mylpc(frame(i,:),p);
    predx = filter([0;-a(i,2:end)],1,frame(i,:));
    e(i,:) = frame(i,:)-predx;
    amp(i) = max(abs(e(i,:)));
end
[period,T] = mypitchtrack(frame,fs);  %浊音基音周期

%% 返回输出结果
lpcparam = struct('fs',[],'nwin',[],'nframe',[],...
    'p',[],'a',[],'period',[],'amp',[]);
lpcparam.fs = fs;
lpcparam.nwin = nwin;
lpcparam.nframe = nframe;
lpcparam.p = p;
lpcparam.a = a;
lpcparam.T = T;
lpcparam.period = period;
lpcparam.amp = amp;
varargout = {lpcparam};
