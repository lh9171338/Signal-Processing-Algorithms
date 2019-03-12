function [x,x_e,G] = mykalman(sys,x0,P0,u,z,Q,R)
%MYKALMAN - Kalman filtering
%
%   [x,x_e,G] = mykalman(sys,x0,P0,u,z,Q,R)
%   [x,x_e,G] = mykalman(sys,x0,P0,[],z,Q,R)

%预测方程：x(n+1) = Ax(n)+Bu[n]+w[n]
%测量方程：z(n) = Hx(n)+v[n]
%状态方程的矩阵：sys = {A,B,H}

%% 检查参数数目
narginchk(7,7);
nargoutchk(0,3);

%% 参数获取
A = sys{1};
B = sys{2};
H = sys{3};
if isempty(u)
    u = zeros(size(z));
end
nx = size(z,2);

%% 卡尔曼滤波算法
x_e = zeros(size(A,2),nx); %均值估计值
P_e = zeros(size(P0,1),size(P0,2),nx); %协方差估计值
x = zeros(size(A,2),nx); %修正（最优）均值估计值
P = zeros(size(P0,1),size(P0,2),nx); %修正（最优）协方差估计值
x_e(:,1) = x0;
P_e(:,:,1) = P0;
x(:,1) = x0;
P(:,:,1) = P0;
for i=2:nx
    %由n时刻状态估计n+1时刻的状态
    x_e(:,i) = A*x(:,i-1)+B*u(:,i);
    P_e(:,:,i) = A*P(:,:,i-1)*A'+Q;
    %计算卡尔曼增益
    G = P_e(:,:,i)*H'/(H*P_e(:,:,i)*H'+R);
    %修正估计值
    x(:,i) = x_e(:,i)+G*(z(:,i)-H*x_e(:,i));
    P(:,:,i) = (eye(size(P0,1),size(P0,2))-G*H)*P_e(:,:,i);
end







