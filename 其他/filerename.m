% filerename.m
% 文件批量重命名
%%
clear,clc;
close all;

%% 路径
srcPath = uigetdir(pwd,'源目录');
dstPath = uigetdir(pwd,'目标目录');
fileList = dir(strcat(src,'\*.jpg'));
numFiles = length(fileList);

%% 批量处理文件
for i=1:numFiles
    srcFilename = [srcPath,'\',fileList(i).name];
    dstFilename = [dstPath,'\',num2str(i,'%06d'),'.jpg'];
    movefile(srcFilename, dstFilename);
    fprintf('进度：%d/%d\n',i,numFiles);
end