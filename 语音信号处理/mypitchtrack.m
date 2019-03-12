function varargout = mypitchtrack(varargin)
%MYPITCHTRACK - Pitch track by cepstrum analysis
%
%   This MATLAB function finds the pitch of the signal frames by 
%   cepstrum analysis.
%
%   [period,T] = mypitchtrack(frame,fs)
%   [period,T] = mypitchtrack(x,fs,nwin)

%% 参数处理
% 检查参数数目
narginchk(2,3);
nargoutchk(0,2);

% 获取输入参数值
% 获取第一个输入参数值
arg1 = varargin{1};
if isvector(arg1)   % arg1是向量x
    [x,fs,nwin] = varargin{:};
    frame = framing(x,nwin,0,'truncation');
else                % arg1是矩阵frame
    [frame,fs] = varargin{:};
end
[nframe,nwin] = size(frame);

%% 计算能量阈值
magnitude = sum(abs(frame),2);
threshmedian = median(magnitude);
threshmean = mean(magnitude);
if threshmean>1.5*threshmedian %% 如果均值和中值非常接近，则认为大部分均为语音信号，阈值设为0
    threshe = threshmedian;
else
    threshe = 0;
end

%% 计算基音周期
%利用人的基音周期范围2~20ms(50~500Hz)
tstart = round(0.002*fs+1);
tend = min(round(0.02*fs+1),round(nwin/2));
period = zeros(nframe,1);
for i=1:nframe
    if magnitude(i)>=threshe
        c = myrceps(frame(i,:));
        [maximum,maxpos] = max(c(tstart:tend));
        threshold = 4*mean(abs(c(tstart:tend)));
        if maximum>=threshold       %浊音
            period(i) = (maxpos+tstart-2)/fs;
        else                        %清音或静音
            period(i) = 0;
        end
    else                            %清音或静音
        period(i) = 0;
    end 
end

%% 计算每一帧的中间点时间(T)
T = zeros(nframe,1);
for i=1:nframe
    start_time = (i-1)*nwin;
    T(i) = start_time+nwin/2;
end
T = T/fs;

%% 返回输出结果
if nargout==1
    varargout = {period};
else
    varargout = {period,T};
end
