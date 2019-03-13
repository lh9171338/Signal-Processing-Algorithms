%filerename.m
clear,clc;
%%
src = uigetdir(pwd,'源目录');
folder_list = dir(src);
folder_list(1:2) = []; %前2个为无效文件
folder_num = length(folder_list);
dst = 'E:\大三下\语音信号处理\exercise\exercise_9(hmmtb)\sample\指令';
%%
for i = 1:folder_num
    file_list = dir(strcat(src,'\',folder_list(i).name,'\*.wav'));
    file_num = length(file_list);
    for j=1:file_num
        img_src_name = [src,'\',folder_list(i).name,'\',file_list(j).name];
        img_dst_name = [dst,'\',folder_list(i).name,'\',file_list(j).name];
        copyfile(img_src_name,img_dst_name);        
    end
    fprintf('已处理文件夹数量：%d\n',i);
end