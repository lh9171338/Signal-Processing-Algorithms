function y = myspeechkalman(x,Q,maxiter)
%MYSPEECHKALMAN - Speech enhancement by kalman filter
%
%   y = myspeechkalman(x)
%   y = myspeechkalman(x,Q)
%   y = myspeechkalman(x,Q,maxiter)

%% 检查参数数目
narginchk(1,3);
nargoutchk(0,1);

%% 缺省参数处理
if nargin < 2
    Q = [];
end
Q_isempty = isempty(Q);
if nargin < 3
    maxiter = 1;
end

%% 参数
p = 10;
nwin = 160; %帧长：20ms for fs=8000Hz
noverlap = round(nwin/2); %帧重叠度
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
label = myendpointdetect(frame,8000,M,Z,[median(M),max(Z)],noverlap);

%% 谱减估计Px和Pn
Px = zeros(nframe,nfft);
Py = abs(fft(frame,nfft,2)).^2; %混合信号功率谱
Pn = mean(Py(~label,:));  
for i=1:nframe
    % 谱减
    Ps = Py(i,:)-4*Pn;
    Ps(Ps<0) = 0.001*Pn(Ps<0);
    Px(i,:) = Ps;
end

%% 卡尔曼滤波
yframe = zeros(nframe,nwin);
x0 = zeros(p,1); %初始均值  
P0 = zeros(p);   %初始协方差  
R = mean(Pn)/nwin; %观测噪声协方差
for i=1:nframe
    %lpc分析
    [a,e,~] = mylpc(Px(i,:),p,'P'); %利用语音帧的功率谱计算自相关函数，再计算lpc系数a
    %卡尔曼滤波
    A = zeros(p);
    A(1:p-1,2:p) = eye(p-1);
    A(p,:) = flipud(-a(2:end));
    H = [zeros(1,p-1),1];
    if Q_isempty
        Q = e.^2; %过程噪声协方差
    end
    G = H';
    for iter=1:maxiter %迭代卡尔曼滤波
        temp = mykalman({A,0,H},x0,P0,[],frame(i,:),Q*(G*G'),R);
        frame(i,:) = temp(p,:);
        [a,e,~] = mylpc(frame(i,:),p); %直接利用语音帧的计算自相关函数，再计算lpc系数a  
        A(p,:) = flipud(-a(2:end));
        if Q_isempty
            Q = e.^2; %过程噪声协方差
        end
    end
    yframe(i,:) = frame(i,:);
end

%% 帧合并
y = mydeframing(yframe);
y = mymovefilt(y,5); %滑动平均

%% 归一化
ny = length(y);
if ny >= nx
    y = y(1:nx);
else
    y = [y;zeros(nx-ny,1)];
end
y = y./max(abs(y));


