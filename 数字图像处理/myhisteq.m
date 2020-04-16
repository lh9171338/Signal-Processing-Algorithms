function [J,Sk] = myhisteq(I)
%MYHISTEQ - Histogram plot
%
%   J = myhisteq(I)
%   [J,Sk] = myhisteq(I)

%%
%获取图像大小
[row,col,c] = size(I);
J = uint8(zeros(row,col)); %初始化J
%若图像是彩色图，则转为灰度图
if c == 3
    I = rgb2gray(I);
end

%计算归一化直方图
Pk = myimhist(I) / numel(I);

%计算灰度映射关系
Sk = cumsum(Pk);
Sk = round(Sk * 255);

%%
%根据映射关系，进行灰度转换
for i=1:row
    for j=1:col
        J(i,j) = Sk(I(i,j)+1);
    end
end
