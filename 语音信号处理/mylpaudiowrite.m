function mylpaudiowrite(varargin)
%MYLPAUDIOWRITE - Write audio file compressed by linear predition analysis
%
%   This MATLAB function writes a matrix of audio data, x, with sample rate fs to a
%   file called filename.
%
%   mylpaudiowrite(filename,lpcparam)
%   mylpaudiowrite(filename,x,fs)
%   mylpaudiowrite(filename,x,fs,nwin)
%   mylpaudiowrite(filename,x,fs,nwin,p)

%% 参数处理
% 检查参数数目
narginchk(2,5);
nargoutchk(0,0);

% 获取输入参数值
if nargin==2
    [filename,lpcparam] = varargin{:};
else
    nwin = [];
    p = [];
    switch nargin
        case 3
            [filename,x,fs] = varargin{:};
            nwin = 160;
        case 4
            [filename,x,fs,nwin] = varargin{:};
        case 5
            [filename,x,fs,nwin,p] = varargin{:};
    end
    if isempty(nwin)
        nwin = 160;
    end
    if isempty(p)
        p = 10;
    end
    lpcparam = lpanalysis(x,fs,nwin,p);
end

%% 写文件
fid = fopen(filename,'w');
if fid>0
    % 判断文件类型
    pos = strfind(filename,'.');
    extension = filename(pos(end):end);
    if strcmp(extension,'.txt')
        fprintf(fid,'%d\n',lpcparam.fs);
        fprintf(fid,'%d\n',lpcparam.nwin);
        fprintf(fid,'%d\n',lpcparam.nframe);
        fprintf(fid,'%d\n',lpcparam.p);
        fprintf(fid,'%f\n',lpcparam.a);
        fprintf(fid,'%f\n',lpcparam.period);
        fprintf(fid,'%f\n',lpcparam.amp);
    else
        fwrite(fid,lpcparam.fs,'uint16');
        fwrite(fid,lpcparam.nwin,'uint16');
        fwrite(fid,lpcparam.nframe,'uint16');
        fwrite(fid,lpcparam.p,'uint8');
        fwrite(fid,lpcparam.a,'float');
        fwrite(fid,lpcparam.period,'float');
        fwrite(fid,lpcparam.amp,'float');        
    end
end
fclose(fid);
