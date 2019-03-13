%video_demo.m
%读取视频文件并处理
%%
clc,clear;
close all;

%% 参数
tic;
SrcFile = 'test.mp4';
DstFile = 'test_video.mp4';
Fs = 22050;
StartTime = 200;
% EndTime = [];
EndTime = 200+60;

%% 读取视频文件
vidObj = VideoReader(SrcFile);
vidObj.CurrentTime = StartTime;
if ismpty(EndTime)
    EndTime = vidObj.Duration - StartTime;
end
currAxes = axes;
v = VideoWriter(DstFile,'MPEG-4');
v.FrameRate = 25;
open(v);
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
    %%
%     vidFrame = im2double(vidFrame);
%     R = vidFrame(:, :, 1);
%     G = vidFrame(:, :, 2);
%     B = vidFrame(:, :, 3);
%     % ---------------对RGB分量进行边缘检测并合并
%     fLap = [0 1 0;1 -4 1; 0 1 0];
%     Edge_R = imfilter(R,fLap,'replicate');
%     Edge_G = imfilter(G,fLap,'replicate');
%     Edge_B = imfilter(B,fLap,'replicate');
%     Edge_R = max(Edge_R,0);
%     Edge_G = max(Edge_G,0);
%     Edge_B = max(Edge_B,0);
%     Edge_R = Edge_R/max(Edge_R(:));
%     Edge_G = Edge_G/max(Edge_G(:));
%     Edge_B = Edge_B/max(Edge_B(:));
%     rgb = cat(3, Edge_R, Edge_G, Edge_B);
%     rgb = log(1+9.0*rgb)/log(10);
%     rgb = im2uint8(rgb);
%     rgb = 255-rgb;
%     vidFrame = rgb;
    %%
%     R = vidFrame(:, :, 1);
%     G = vidFrame(:, :, 2);
%     B = vidFrame(:, :, 3);
%     % ---------------对RGB分量进行边缘检测并合并
%     Edge_R = mysobel(R);
%     Edge_G = mysobel(G);
%     Edge_B = mysobel(B);
%     rgb = cat(3, Edge_R, Edge_G, Edge_B);
%     rgb = log(1+9.0*rgb)/log(10);
%     rgb = im2uint8(rgb);
%     rgb = 255-rgb;
%     vidFrame = rgb;
    %%
    gray = rgb2gray(vidFrame);
%     Edge = mysobel(gray);
%     Edge = log(1+9.0*Edge)/log(10);
%     bw = im2bw(Edge,graythresh(Edge));
%     gray = im2uint8(bw);
%     gray = 255-gray;
    vidFrame = repmat(gray,1,1,3);    
    %%
    writeVideo(v,vidFrame);
    image(vidFrame, 'Parent', currAxes);
    currAxes.Visible = 'off';
    pause(1/vidObj.FrameRate);
    if vidObj.CurrentTime > endtime
        break;
    end
end
close(v);
toc

