%audio2coe.m
%%
%读取音频信号
filename='beyond.wav';
[y,Fs]=audioread(filename); 
Total_time=16;
y=y(Fs*100:(Fs*Total_time+Fs*100-1),1);                   %取一个声道
y=(y+1)/2;
sound(y,Fs);
plot(y);
y=round(y*125);
%%
filename='rom.coe';
fid = fopen(filename,'wt');
fprintf(fid,'memory_initialization_radix = 16;\nmemory_initialization_vector = \n');
N=131072;
for i=1:N
    if(i<=128000)
        fprintf(fid,'%x,\n',y(i));
    else
        fprintf(fid,'%x,\n',0);
    end
end
fclose(fid);%关闭文件