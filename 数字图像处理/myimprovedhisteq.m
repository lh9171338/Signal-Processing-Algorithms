function [J,Sk] = myimprovedhisteq(I)
%MYIMPROVEDHISTEQ - Enhance contrast using improved histogram equalization
%
%   J = myimprovedhisteq(I)

%% 图像预处理
%获取图像大小
[row,col,C] = size(I);
%若图像是彩色图，则转为灰度图
if C == 3
    I = rgb2gray(I);
end

J = uint8(zeros(row,col));   %处理结果图像
img_grad = zeros(row,col);   %4个方向梯度

%% 计算梯度
img_expanded = zeros(row+2,col+2);%用于计算梯度的图像，图像4侧插入全零行(或列)
img_expanded(2:(row+1),2:(col+1)) = I;
p = [0,1,0;1,-1,1;0,1,0];         %梯度算子
for i=1:row
    for j=1:col
        block = img_expanded(i:i+2,j:j+2);
        tamp = p .* block;
        grad_y1 = tamp(2,2) + tamp(3,2);    %y轴正向梯度
        grad_y2 = tamp(2,2) + tamp(1,2);    %y轴负向梯度
        grad_x1 = tamp(2,2) + tamp(2,3);    %x轴正向梯度
        grad_x2 = tamp(2,2) + tamp(2,1);    %x轴负向梯度
        %正梯度有效
        grad_y1 = max(grad_y1,0);
        grad_y2 = max(grad_y2,0);
        grad_x1 = max(grad_x1,0);
        grad_x2 = max(grad_x2,0);
        %梯度相加
        img_grad(i,j) = grad_y1 + grad_y2 + grad_x1 + grad_x2;
    end
end

%% 计算加权归一化直方图
Pk = zeros(256,1);
N = sum(sum(img_grad));   %分母
for k=1:256
    pix = I == (k - 1);    %寻找灰度值为k的像素点
    Nk = sum(sum(img_grad .* pix));%分子
    Pk(k) = Nk / N;
end

%% 计算灰度映射关系
Sk = cumsum(Pk);
Sk = round(Sk * 255);

%% 根据映射关系，进行灰度转换
for i=1:row
    for j=1:col
        J(i,j) = Sk(I(i,j)+1);
    end
end
