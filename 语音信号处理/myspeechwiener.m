function y = myspeechwiener(x,param)
%MYSPEECHWIENER - Speech enhancement by wiener filter
%
%   y = myspeechwiener(x)
%   y = myspeechwiener(x,[a,b,alpha,beta])

%% 检查参数数目
narginchk(1,2);
nargoutchk(0,1);

%% 缺省参数处理
if nargin < 2
    param = [1,0,1,1];
end
a = param(1);
b = param(2);
alpha = param(3);
beta = param(4);

%% 参数
nwin = 160; %帧长：20ms for fs=8000Hz
noverlap = 80; %帧重叠度
nx = length(x);
nfft = 512;

%% 分帧加窗
frame = myframing(x,nwin,noverlap);
nframe = size(frame,1);
win = repmat(hamming(nwin)',nframe,1);
frame = frame.*win;

%% 噪声帧估计
%端点检测
[~,M,Z,~] = mytimefeature(x,8000,nwin,noverlap);
label = myendpointdetect(frame,8000,M,Z,[median(M),max(Z)+eps],noverlap);

%% 维纳滤波(频域)
yframe = zeros(nframe,nwin); %降噪后的帧
amp = abs(fft(frame,nfft,2)); %混合信号幅度谱
phase = angle(fft(frame,nfft,2)); %混合信号相位谱
Py = amp.^2; %混合信号功率谱
Pn = mean(Py(~label,:));    
for i=1:nframe
    % 谱减
    Px = Py(i,:)-a*Pn;
    Px(Px<0) = b*Pn(Px<0);
    % 计算H(w)
    H = (Px./(Px+alpha*Pn)).^beta;
    Y = H.*amp(i,:); %频域滤波
    temp = real(ifft(Y.*exp(1i*phase(i,:)),nfft));
    yframe(i,:) = temp(1:nwin);
end

%% 帧合并
y = mydeframing(yframe,noverlap);

%% 归一化
ny = length(y);
if ny >= nx
    y = y(1:nx);
else
    y = [y;zeros(nx-ny,1)];
end
y = y./max(abs(y));
