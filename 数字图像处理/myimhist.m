function h = myimhist(I)
%MYIMHIST - Display histogram of image data.
%
%   This MATLAB function calculates the histogram for the intensity image I and
%   displays a plot of the histogram
%
%   h = myimhist(I)

h = zeros(256,1);
%获取图像大小
[row,col,c] = size(I);
%若图像是彩色图，则转为灰度图
if c==3
    I = rgb2gray(I);
end

%统计每个灰度级的点数
for i=1:row
    for j=1:col
        h(I(i,j)+1) = h(I(i,j)+1)+1;
    end
end

%如果没有输出参数，则绘制直方图
if nargout<1
    bar((0:255),h,0.1);
    xlim([0 255]);
end


