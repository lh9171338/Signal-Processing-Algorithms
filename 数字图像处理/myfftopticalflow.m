function k = myfftopticalflow(fixing, moving, kSize)
%MYFFTOPTICALFLOW - Calculate optical flow by FFT
%
%   k = myfftopticalflow(fixing, moving)
%   k = myfftopticalflow(fixing, moving, [M, N])

%% 参数检查
narginchk(2,3);
nargoutchk(0,1);

%% 缺省参数处理
if nargin < 3
    kSize = [5, 5];
end
M = kSize(1);
N = kSize(2);

%% FFT
% fixing image
F1 = fftshift(fft2(im2double(fixing))); 
Phase1 = angle(F1);
% moving image
F2 = fftshift(fft2(im2double(moving))); 
Phase2 = angle(F2);

%% 相位相减
deltaPhase = Phase1 - Phase2;
deltaPhase = mod(deltaPhase, 2 * pi);

%% 求相位差梯度
[Fx,Fy] = gradient(deltaPhase);
Fx = medfilt2(Fx, [1, N]); % 中值滤波，滤去间断点影响
Fy = medfilt2(Fy, [M, 1]);
[rows, cols] = size(deltaPhase);
Fx = Fx * cols / (2 * pi); % 求解移动量x0
Fy = Fy * rows / (2 * pi); % 求解移动量y0
H = Fx + Fy * 1i;

%% 利用平均梯度作为光流
k = mean(H(:)); % x0 + j y0

    