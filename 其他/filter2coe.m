% audio2coe.m
%%
clear,clc;
close all;

%%
b=fir1(63,0.25,'low');
freqz(b,1);
filename='coe.txt';
fid=fopen(filename,'w');
fprintf(fid,'# banks: 1\n');
fprintf(fid,'# coeffs: %d\n',length(b));
N=length(b);
for i=1:N
fprintf(fid,'%f,',b(i));
end
fclose(fid);%╧ь╠унд╪Ч