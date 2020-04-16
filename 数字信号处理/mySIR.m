function x = mySIR(sys, x0, P0, u, z, Q, R, N)
%MYSIR - Sampling Importance Resampling Filter
%
%   x = mySIR(sys, x0, P0, u, z, Q, R, N)
%   x = mySIR(sys, x0, P0, [], z, Q, R, N)

%预测方程：x(n+1) = Ax(n)+Bu[n]+w[n]
%测量方程：z(n) = Hx(n)+v[n]
%状态方程的矩阵：sys = {A,B,H}

%% 检查参数数目
narginchk(8,8);
nargoutchk(0,1);

%% 参数获取
A = sys{1};
B = sys{2};
H = sys{3};
if isempty(u)
    u = zeros(size(z));
end
dx = size(x0, 1);
nx = size(z, 2);

%% SIR算法
x_P = x0 + sqrt(P0) * randn(dx, N);   % 初始化N个粒子
x = zeros(dx, nx);                    % 滤波结果
x(:,1) = x0;
for i=2:nx
    % 从先验p(x(k)|x(k-1))中采样得到粒子  
    x_P_update = A * x_P + B * u(:,i) + sqrt(Q) * randn(dx, N);% 更新后的粒子
    % 利用p(y(k)|x(k))计算粒子权重
    z_update = H * x_P_update;                          % 粒子对应的观察值
    P_w = normpdf(z_update, z(:,i), sqrt(R));           % 粒子的权重
    % 归一化P_w
    P_w = P_w ./ sum(P_w);
    P_w = cumsum(P_w);
    % 重采样
    for j=1:N    
        idx = find(rand <= P_w, 1);
        x_P(:, j) = x_P_update(:, idx);
    end 
    % 状态估计
    x(:,i) = mean(x_P, 2);
end
