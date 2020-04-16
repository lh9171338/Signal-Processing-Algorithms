function varargout = mylpsynthesis(varargin)
%MYLPSYNTHESIS - Signal synthesis by linear prediction
%
%   This MATLAB function syntheses the speech signal with the parameters
%   of the system and the excitation by linear predition.
%
%   x = mylpsynthesis(lpcparam)

%% 参数处理
% 检查参数数目
narginchk(1,1);
nargoutchk(0,1);

% 获取输入参数值
lpcparam = varargin{:};
fs = lpcparam.fs;
nwin = lpcparam.nwin;
nframe = lpcparam.nframe;
a = lpcparam.a;
period = lpcparam.period;
amp = lpcparam.amp;

%% LP合成
synframe = zeros(nframe,nwin);
for i=1:nframe
    if period(i)>0     %浊音
        t = 1:nwin;
        d = 1:period(i)*fs:nwin;
        % 由浊音基音周期产生激励信号
        e = pulstran(t,d,'rectpuls');
    else               %清音或静音
        % 用白噪声作为激励信号
        e = randn(nwin,1);
    end
    e = amp(i)*(e/max(abs(e)));
    synframe(i,:) = filter(1,a(i,:),e);
end
synx = mydeframing(synframe,0);

%% 去加重
% R=1/(1-b*Z^-1)
synx = filter(1,[1,-0.95],synx);

%% 归一化
amp = max(abs(synx));
if amp>1
    synx = synx/amp;
end

%% 返回输出结果
varargout = {synx};
