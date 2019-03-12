function mydispwaveform(varargin)
%MYDISPWAVEFORM - Display waveform
%
%   This MATLAB function plots the waveform of the input vector x.
%
%   mydispwaveform(t,x,fs)
%   mydispwaveform(t,x,fs,Property)
%   mydispwaveform(...,option)
%
%   Property = struct('linespec',[],'xlabel',[],'ylabel',[],'title',[],'xlim',[],'ylim',[])
%   option:{'time'(default),'freq'}

%% 参数处理
% 检查参数数目
narginchk(3,10);

% 初始化输入参数
Propertyin = struct();
Property.linespec = '';
Property.xlabel = '时间(s)';
Property.ylabel = '幅度';
Property.title = '时域波形';
Property.xlim = [];
Property.ylim = [];
domain = 'time';

% 获取输入参数option
if (nargin > 2 && ischar(varargin{end})) && any(strcmpi(varargin{end},{'time','freq'})),
    domain = varargin{end};
    varargin(end) = [];
end

% 获取剩余输入参数值
narg = numel(varargin); % 获取剩余输入参数数量
switch narg
    case 3
        [t,x,fs] = varargin{:};
    case 4
        [t,x,fs,Propertyin] = varargin{:};
end

% 检查输入参数值
% 检查参数x
if isvector(x)==1
    x = x(:);   % 将x转为列向量
else
    error('输入参数x必须为1维数组');
end
% 检查参数domain
f = [];
if strcmpi(domain,'freq')
    Property.xlabel = '频率(Hz)';
    Property.title = '幅度谱';
    f = t;
end

% 检查参数Property
fieldname = fieldnames(Propertyin);
for i=1:numel(fieldname)
    field = fieldname{i};
    if isfield(Property,field)
        value = getfield(Propertyin,field);
        if ~isempty(value)
            Property = setfield(Property,field,value);
        end
    else
        error(['字符串参数',field,'为无效选项']);
    end
end

%% 绘制波形
% 判断时域还是频域
nx = length(x);
if isempty(Property.linespec)
    Property.linespec = '';
end
if strcmpi(domain,'time')
    if isempty(t)
        t = (0:(nx-1))/fs;
    end
    plot(t,x,Property.linespec);
else
    if isempty(f)
        f = 0:fs/nx:fs/2;
        x = x(1:length(f));
    end
    plot(f,x,Property.linespec);   
end
xlabel(Property.xlabel);
ylabel(Property.ylabel);
title(Property.title);
if ~isempty(Property.xlim)
    xlim(Property.xlim);
end
if ~isempty(Property.ylim)
    ylim(Property.ylim);
end
