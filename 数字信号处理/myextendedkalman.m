function [x,x_e,K] = myextendedkalman(sys,x0,P0,u,z,Q,R)
%MYEXTENDEDKALMAN - Extended Kalman filtering
%
%   [x,x_e,K] = myextendedkalman(sys,x0,P0,u,z,Q,R)
%   [x,x_e,K] = myextendedkalman(sys,x0,P0,[],z,Q,R)

%预测方程：x(n+1) = f(x(n)) + g(u[n]) + w[n]
%测量方程：z(n) = h(x(n)) + v[n]
%状态方程的矩阵：sys = {f,g,h}

%% 检查参数数目
narginchk(7,7);
nargoutchk(0,3);

%% 参数获取
if isempty(u)
    u = zeros(size(z));
end
nx = size(z,2);
symf = sys{1};
symg = sys{2};
symh = sys{3};
symx = symvar(symf)';
symu = symvar(symg)';

%% 计算雅可比矩阵
dimx = size(x0,1);
dimz = size(z,1);
symF = sym('df',[dimx,dimx]);
symH = sym('dh',[dimz,dimx]);
for i=1:dimx
    symF(:,i) = diff(symf,symx(i));
    symH(:,i) = diff(symh,symx(i));
end

%% 卡尔曼滤波算法
x_e = zeros(dimx,nx);       % 均值估计值
P_e = zeros(dimx,dimx,nx);  % 协方差估计值
x = zeros(dimx,nx);         % 修正（最优）均值估计值
P = zeros(dimx,dimx,nx);    % 修正（最优）协方差估计值
x_e(:,1) = x0;
P_e(:,:,1) = P0;
x(:,1) = x0;
P(:,:,1) = P0;
for i=2:nx
    % 由n-1时刻状态估计n时刻的状态
    x_e(:,i) = subs(symf,symx,x(:,i-1)) + subs(symg,symu,u(:,i));
    F = subs(symF,symx,x(:,i-1));
    P_e(:,:,i) = F * P(:,:,i-1) * F' + Q;
    % 计算卡尔曼增益
    H = subs(symH,symx,x_e(:,i));
    K = P_e(:,:,i) * H'/ (H * P_e(:,:,i) * H' + R);
    % 修正估计值
    x(:,i) = x_e(:,i) + K * (z(:,i) - subs(symh,symx,x_e(:,i)));
    P(:,:,i) = (eye(dimx) - K * H) * P_e(:,:,i);
end







