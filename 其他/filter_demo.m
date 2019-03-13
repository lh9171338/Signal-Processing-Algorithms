%****************************************************************************************
%  
%                      创建两个信号Mix_Signal_1 和信号 Mix_Signal_2 
%
%***************************************************************************************
clc,clear;
close all;

Fs = 1000;                                                                        %采样率
N  = 1000;                                                                        %采样点数
n  = 0:N-1;
t   = 0:1/Fs:1-1/Fs;                                                            %时间序列 
Signal_Original_1 =sin(2*pi*10*t)+sin(2*pi*20*t)+sin(2*pi*30*t); 
Noise_White_1    = [0.3*randn(1,500), rand(1,500)];           %前500点高斯分部白噪声，后500点均匀分布白噪声
Mix_Signal_1   = Signal_Original_1 + Noise_White_1;        %构造的混合信号

Signal_Original_2  =  [zeros(1,100), 20*ones(1,20), -2*ones(1,30), 5*ones(1,80), -5*ones(1,30), 9*ones(1,140), -4*ones(1,40), 3*ones(1,220), 12*ones(1,100), 5*ones(1,20), 25*ones(1,30), 7 *ones(1,190)]; 
Noise_White_2     =  0.5*randn(1,1000);                                 %高斯白噪声
Mix_Signal_2        =  Signal_Original_2 + Noise_White_2;      %构造的混合信号

% %****************************************************************************************
% %  
% %                信号Mix_Signal_1 和 Mix_Signal_2  分别作巴特沃斯低通滤波。
% %
% %***************************************************************************************
% 
% %混合信号 Mix_Signal_1  巴特沃斯低通滤波
% figure(1);
% Wc=2*50/Fs;                                          %截止频率 50Hz
% [b,a]=butter(4,Wc);
% Signal_Filter=filter(b,a,Mix_Signal_1);
% 
% subplot(4,1,1);                                        %Mix_Signal_1 原始信号                 
% plot(Mix_Signal_1);
% axis([0,1000,-4,4]);
% title('原始信号 ');
% 
% subplot(4,1,2);                                        %Mix_Signal_1 低通滤波滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-4,4]);
% title('巴特沃斯低通滤波后信号');
% 
% %混合信号 Mix_Signal_2  巴特沃斯低通滤波
% Wc=2*100/Fs;                                          %截止频率 100Hz
% [b,a]=butter(4,Wc);
% Signal_Filter=filter(b,a,Mix_Signal_2);
% 
% subplot(4,1,3);                                        %Mix_Signal_2 原始信号                 
% plot(Mix_Signal_2);
% axis([0,1000,-10,30]);
% title('原始信号 ');
% 
% subplot(4,1,4);                                       %Mix_Signal_2 低通滤波滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-10,30]);
% title('巴特沃斯低通滤波后信号');
% 
% %****************************************************************************************
% %  
% %                信号Mix_Signal_1 和 Mix_Signal_2  分别作FIR低通滤波。
% %
% %***************************************************************************************
% 
% %混合信号 Mix_Signal_1  FIR低通滤波
% figure(2);
% F   =  0:0.05:0.95; 
% A  =  [1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] ;
% b  =  firls(20,F,A);
% Signal_Filter = filter(b,1,Mix_Signal_1);
% 
% subplot(4,1,1);                                          %Mix_Signal_1 原始信号                 
% plot(Mix_Signal_1);
% axis([0,1000,-4,4]);
% title('原始信号 ');
% 
% subplot(4,1,2);                                          %Mix_Signal_1 FIR低通滤波滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-5,5]);
% title('FIR低通滤波后的信号');
% 
% %混合信号 Mix_Signal_2  FIR低通滤波
% F   = 0:0.05:0.95; 
% A  =  [1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] ;
% b  =  firls(20,F,A);
% Signal_Filter = filter(b,1,Mix_Signal_2);
% subplot(4,1,3);                                          %Mix_Signal_2 原始信号                 
% plot(Mix_Signal_2);
% axis([0,1000,-10,30]);
% title('原始信号 ');
% 
% subplot(4,1,4);                                          %Mix_Signal_2 FIR低通滤波滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-10,30]);
% title('FIR低通滤波后的信号');
% 
% %****************************************************************************************
% %  
% %                信号Mix_Signal_1 和 Mix_Signal_2  分别作移动平均滤波
% %
% %***************************************************************************************
% 
% %混合信号 Mix_Signal_1  移动平均滤波
% figure(3);
% b  =  [1 1 1 1 1 1]/6;
% Signal_Filter = filter(b,1,Mix_Signal_1);
% 
% subplot(4,1,1);                                          %Mix_Signal_1 原始信号                 
% plot(Mix_Signal_1);
% axis([0,1000,-4,4]);
% title('原始信号 ');
% 
% subplot(4,1,2);                                          %Mix_Signal_1 移动平均滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-4,4]);
% title('移动平均滤波后的信号');
% 
% %混合信号 Mix_Signal_2  移动平均滤波
% b  =  [1 1 1 1 1 1]/6;
% Signal_Filter = filter(b,1,Mix_Signal_2);
% subplot(4,1,3);                                          %Mix_Signal_2 原始信号                 
% plot(Mix_Signal_2);
% axis([0,1000,-10,30]);
% title('原始信号 ');
% 
% subplot(4,1,4);                                          %Mix_Signal_2 移动平均滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-10,30]);
% title('移动平均滤波后的信号');
% 
% %****************************************************************************************
% %  
% %                信号Mix_Signal_1 和 Mix_Signal_2  分别作中值滤波
% %
% %***************************************************************************************
% 
% %混合信号 Mix_Signal_1  中值滤波
% figure(4);
% Signal_Filter=medfilt1(Mix_Signal_1,10);
% 
% subplot(4,1,1);                                          %Mix_Signal_1 原始信号                 
% plot(Mix_Signal_1);
% axis([0,1000,-5,5]);
% title('原始信号 ');
% 
% subplot(4,1,2);                                          %Mix_Signal_1 中值滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-5,5]);
% title('中值滤波后的信号');
% 
% %混合信号 Mix_Signal_2  中值滤波
% Signal_Filter=medfilt1(Mix_Signal_2,10);
% subplot(4,1,3);                                          %Mix_Signal_2 原始信号                 
% plot(Mix_Signal_2);
% axis([0,1000,-10,30]);
% title('原始信号 ');
% 
% subplot(4,1,4);                                          %Mix_Signal_2 中值滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-10,30]);
% title('中值滤波后的信号');

% %****************************************************************************************
% %  
% %                信号Mix_Signal_1 和 Mix_Signal_2  分别作维纳滤波
% %
% %***************************************************************************************
% 
% %混合信号 Mix_Signal_1  维纳滤波
% figure(5);
% M = 2;  
% rx = ifftshift(xcorr(Noise_White_1));   %得到参考噪声的自相关函数
% rx = rx(1:M);
% Rxx = toeplitz(rx);                                   %维纳滤波器阶数
% Rxy = ifftshift(xcorr(Mix_Signal_1,Noise_White_1));   %得到混合信号和原信号的互相关函数
% Rxy = Rxy(1:M);                                       %得到混合信号和原信号的互相关向量
% h = Rxx\Rxy';                                         %得到所要涉及的wiener滤波器系数
% Signal_Filter = Mix_Signal_1-filter(h,1, Noise_White_1);              %将输入信号通过维纳滤波器
% 
% subplot(4,1,1);                                                   %Mix_Signal_1 原始信号                 
% plot(Mix_Signal_1);
% axis([0,1000,-5,5]);
% title('原始信号 ');
% 
% subplot(4,1,2);                                                   %Mix_Signal_1 维纳滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-5,5]);
% title('维纳滤波后的信号');
% 
% rx = ifftshift(xcorr(Noise_White_2));   %得到参考噪声的自相关函数
% rx = rx(1:M);
% Rxx = toeplitz(rx);                                   %维纳滤波器阶数
% Rxy = ifftshift(xcorr(Mix_Signal_2,Noise_White_2));   %得到混合信号和原信号的互相关函数
% Rxy = Rxy(1:M);                                       %得到混合信号和原信号的互相关向量
% h = Rxx\Rxy';                                         %得到所要涉及的wiener滤波器系数
% Signal_Filter = Mix_Signal_2-filter(h,1, Noise_White_2);             %将输入信号通过维纳滤波器
% 
% subplot(4,1,3);                                                  %Mix_Signal_2 原始信号                 
% plot(Mix_Signal_2);
% axis([0,1000,-10,30]);
% title('原始信号 ');
% 
% subplot(4,1,4);                                                  %Mix_Signal_2 维纳滤波后信号  
% plot(Signal_Filter);
% axis([0,1000,-10,30]);
% title('维纳滤波后的信号');

%****************************************************************************************
%  
%                信号Mix_Signal_1 和 Mix_Signal_2  分别作自适应滤波
%
%***************************************************************************************

%混合信号 Mix_Signal_1 自适应滤波
figure(6);
N=1000;                                             %输入信号抽样点数N
k=50;                                                  %时域抽头LMS算法滤波器阶数
u=0.01;                                             %步长因子

%设置初值
yn_1=zeros(1,N);                                  %output signal
w=zeros(1,k);                                        %设置抽头加权初值
e=zeros(1,N);                                        %误差信号

%用LMS算法迭代滤波
for i=(k+1):N
        XN=Noise_White_1((i-k+1):(i));
        yn_1(i)=w*XN';
        e(i)=Mix_Signal_1(i)-yn_1(i);
        w=w+2*u*e(i)*XN;
end

subplot(4,1,1);
plot(Mix_Signal_1);                               %Mix_Signal_1 原始信号
axis([k+1,1000,-4,4]);
title('原始信号');

subplot(4,1,2);
plot(e);                                            %Mix_Signal_1 自适应滤波后信号
axis([k+1,1000,-4,4]);
title('自适应滤波后信号');b

%混合信号 Mix_Signal_2 自适应滤波
N=1000;                                             %输入信号抽样点数N
k=50;                                              %时域抽头LMS算法滤波器阶数
u=0.000011;                                        %步长因子

%设置初值
yn_1=zeros(1,N);                                   %output signal
w=zeros(1,k);                                        %设置抽头加权初值
e=zeros(1,N);                                        %误差信号

%用LMS算法迭代滤波
for i=(k+1):N
        XN=Noise_White_2((i-k+1):(i));
        yn_1(i)=w*XN';
        e(i)=Mix_Signal_2(i)-yn_1(i);
        w=w+2*u*e(i)*XN;
end

subplot(4,1,3);
plot(Mix_Signal_2);                               %Mix_Signal_1 原始信号
axis([k+1,1000,-10,30]);
title('原始信号');

subplot(4,1,4);
plot(e);                                            %Mix_Signal_1 自适应滤波后信号
axis([k+1,1000,-10,30]);
title('自适应滤波后信号');

% %****************************************************************************************
% %  
% %                信号Mix_Signal_1 和 Mix_Signal_2  分别作小波滤波
% %
% %***************************************************************************************
% 
% %混合信号 Mix_Signal_1  小波滤波
% figure(7);
% subplot(4,1,1);
% plot(Mix_Signal_1);                                 %Mix_Signal_1 原始信号
% axis([0,1000,-5,5]);
% title('原始信号 ');
% 
% subplot(4,1,2);
% [xd,cxd,lxd] = wden(Mix_Signal_1,'sqtwolog','s','one',2,'db3');
% plot(xd);                                                 %Mix_Signal_1 小波滤波后信号
% axis([0,1000,-5,5]);
% title('小波滤波后信号 ');
% 
% %混合信号 Mix_Signal_2  小波滤波
% subplot(4,1,3);
% plot(Mix_Signal_2);                                 %Mix_Signal_2 原始信号
% axis([0,1000,-10,30]);
% title('原始信号 ');
% 
% subplot(4,1,4);
% [xd,cxd,lxd] = wden(Mix_Signal_2,'sqtwolog','h','sln',3,'db3');
% plot(xd);                                                %Mix_Signal_2 小波滤波后信号
% axis([0,1000,-10,30]);
% title('小波滤波后信号 ');