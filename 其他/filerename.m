%filerename.m
clear,clc;
%%
src = uigetdir(pwd,'源目录');
dst = src;
file_list = dir(strcat(src,'\*.jpg'));
file_num = length(file_list);
%%
for i = 1:file_num
    img_src_name = [src,'\',file_list(i).name];
    img_dst_name = [dst,'\',file_list(i).name];
    img = imread(img_src_name);
    img = imresize(img, [900, 1200]);
    imwrite(img, img_dst_name);
    fprintf('已处理文件数量：%d\n',i);
end