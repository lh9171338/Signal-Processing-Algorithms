function snr = mysnrcalc(x,mix)
%MYSNRCALC - Calculate SNR
%
%   snr = mysnrcalc(x,mix)

%% 检查参数数目
narginchk(2,2);
nargoutchk(0,1);

%% 计算信噪比
noise = mix-x; %噪声
x = x-mean(x); %去直流
noise = noise-mean(noise); %去直流
Ex = sum(x.^2); %信号的能量
En = sum(noise.^2); %噪声的能量
snr = 10*log10(Ex/En); %信号的能量与噪声的能量之比，再求分贝值


