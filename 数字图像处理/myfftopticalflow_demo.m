%% myfftopticalflow_demo.m
clc,clear;
close all;

% %% read image
% fixing = imread('../src/opticalflow-1.jpg'); 
% if size(fixing, 3) == 3
%     fixing = rgb2gray(fixing);
% end
% 
% %% transform
% moving = imtranslate(fixing, [100, 0], 'FillValues', 255); 

%% read image
fixing = imread('../src/opticalflow-2.jpg'); 
moving = imread('../src/opticalflow-3.jpg'); 
if size(fixing, 3) == 3
    fixing = rgb2gray(fixing);
end
if size(moving, 3) == 3
    moving = rgb2gray(moving);
end

%% display
figure;imshow(fixing);
figure;imshow(moving);
figure;imshowpair(fixing, moving);

%% Calculate optical flow
tic;
k = myfftopticalflow(fixing, moving);
toc
theta = angle(k) * 180 / pi;
disp(['optical flow vector: ', num2str(k)]);
disp(['orientation: ', num2str(theta), 'degree']);
