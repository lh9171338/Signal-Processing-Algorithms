function g = myglobalthresh(f,delta)
%MYGLOBALTHRESH - Basic Global Threshold
%
%   g = myglobalthresh(f)
%   g = myglobalthresh(f,delta)


T = mean2(f);   %初始阈值
done = false;   %迭代完成标记
if nargin<2
    delta = 0.5;
end
while(~done)
    g = f>T;
    Tnext = 0.5*(mean2(f(g))+mean2(f(~g)));
    if abs(Tnext-T)<delta
        done = true;
    end
    T = Tnext;
end