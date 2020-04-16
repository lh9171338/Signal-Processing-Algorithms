function y = myspecsub(x,param)
%MYSPETSUB - Spectral Subtraction
%
%   y = myspecsub(x)
%   y = myspecsub(x,[a,b])

%% 检查参数数目
narginchk(1,2);
nargoutchk(0,1);

%% 缺省参数处理
if nargin < 2
    param = [1,0];
end
a = param(1);
b = param(2);

%% 参数
nwin = 160; %帧长：20ms for fs=8000Hz
noverlap = round(nwin/2); %帧重叠度
nx = length(x);
nfft = 512;

% %% 预加重 R=1-Z^-1
% w = [1,-0.95];
% x = filter(w,1,x);

%% 分帧加窗
frame = myframing(x,nwin,noverlap);
nframe = size(frame,1);
win = repmat(hamming(nwin)',nframe,1);
frame = frame.*win;

%% 噪声帧估计
%端点检测
[~,M,Z,~] = mytimefeature(x,8000,nwin,noverlap);
label = myendpointdetect(frame,8000,M,Z,[median(M),max(Z)+eps],noverlap);

%% 谱减
yframe = zeros(nframe,nwin); %降噪后的帧
Py = abs(fft(frame,nfft,2)).^2; %混合信号功率谱
phase = angle(fft(frame,nfft,2)); %混合信号相位谱
Pn = mean(Py(~label,:));    
for i=1:nframe
    % 谱减
    Px = Py(i,:)-a*Pn;
    Px(Px<0) = b*Pn(Px<0);
    Ax = sqrt(Px);
    % 加上相位
    temp = real(ifft(Ax.*exp(1i*phase(i,:)),nfft));
    yframe(i,:) = temp(1:nwin);
end

%% 帧合并
y = mydeframing(yframe);

% %% 去加重 R=1/(1-Z^-1)
% w = [1,-0.95];
% y = filter(1,w,y);

%% 归一化
ny = length(y);
if ny >= nx
    y = y(1:nx);
else
    y = [y;zeros(nx-ny,1)];
end
y = y./max(abs(y));
