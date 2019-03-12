function [rects,objectMap] = mysaliencydetect(img,areathresh)
%MYSALIENCYDETECT - Saliency detect
%
%   rects = mysaliencydetect(img)
%   rects = mysaliencydetect(img,areathresh)
%   [rects,objectMap] = mysaliencydetect(...)

%% 参数检查
narginchk(1,2);
nargoutchk(1,2);

%% 缺省参数处理
if nargin < 2
    areathresh = 0;
end

%% 图像预处理
img = im2double(img);
if size(img,3) == 3
    img = rgb2gray(img);
end
scaledimg = imresize(img,64/size(img,2));

%% 计算谱残差
myFFT = fft2(scaledimg);
myLogAmplitude = log(abs(myFFT));
myPhase = angle(myFFT);
mySpectralResidual = myLogAmplitude-imfilter(myLogAmplitude,fspecial('average',3),'replicate');
saliencyMap = abs(ifft2(exp(mySpectralResidual+1i*myPhase))).^2;

%% 空域平滑滤波
saliencyMap = mat2gray(imfilter(saliencyMap,fspecial('gaussian',[10, 10],2.5)));
threshold = 2*mean(saliencyMap(:));
objectMap = mat2gray(saliencyMap>threshold);
objectMap = imresize(objectMap,[size(img,1),size(img,2)]);

%% 连通域处理
objectMap = bwareaopen(objectMap,areathresh);
CC = regionprops(objectMap,'boundingbox');
rects = zeros(length(CC),4);
for i=1:length(CC)
    rects(i,1) = ceil(CC(i).BoundingBox(1));
    rects(i,2) = ceil(CC(i).BoundingBox(2));
    rects(i,3) = ceil(CC(i).BoundingBox(3));
    rects(i,4) = ceil(CC(i).BoundingBox(4));
end


