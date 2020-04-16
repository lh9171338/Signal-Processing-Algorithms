%% mysvd_demo.m
%% SVD分解降维
%%
clc,clear;
close all;

%% 产生测试数据
N = 100;
x = rand(N,1)*10; % x：0~10
y = x+10; % y=k*x+b
y = y+rand(N,1); % 加噪声
X = [x,y]; % 构成2维空间的点

%% 显示测试数据
figure;
plot(X(:,1),X(:,2),'or');
axis('equal');
title('原始数据');
hold on;

%% SVD降维
means = mean(X); 
X1 = X-means; % 去均值
[Y,U,S,V] = mysvd(X1,[]);
dim = size(Y,2);

%% 绘制特征向量
nv = size(V,2); % V的列数为特征向量的个数
for i=1:nv
    v = V(:,i)*10; % 放大特征向量的长度，便于显示
    quiver(0,0,v(1),v(2),'b','linewidth',2);
end
hold off;

%% 绘制经特征向量旋转的数据
Z = X1*V;
figure;
plot(Z(:,1),Z(:,2),'or',Y,zeros(N,1),'ob');
axis('equal');
legend('旋转后的数据','降维后的数据');

%% 绘制降维数据还原的数据
Z = Y*V(:,1:dim)'+means;
figure;
plot(X(:,1),X(:,2),'or',Z(:,1),Z(:,2),'ob');
axis('equal');
legend('原始数据','还原的数据');

