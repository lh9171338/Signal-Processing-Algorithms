%test.m
clear,clc;
%%
src = uigetdir(pwd,'源目录');
%dst = uigetdir(pwd,'目标目录');
dvs_file_list = dir(strcat(src,'\dvs\*.jpg'));
infrared_file_list = dir(strcat(src,'\infrared\*.jpg'));
rgb_file_list = dir(strcat(src,'\rgb\*.jpg'));

%%
dvs_filename_list = [];
file_num = length(dvs_file_list);
for i = 1:file_num
    dvs_filename_list = cat(1, dvs_filename_list, dvs_file_list(i).name);
end
infrared_filename_list = [];
file_num = length(infrared_file_list);
for i = 1:file_num
    infrared_filename_list = cat(1, infrared_filename_list, infrared_file_list(i).name);
end
rgb_filename_list = [];
file_num = length(rgb_file_list);
for i = 1:file_num
    rgb_filename_list = cat(1, rgb_filename_list, rgb_file_list(i).name);
end
common_filename_list = intersect(dvs_filename_list, ...
    infrared_filename_list, rgb_filename_list);
