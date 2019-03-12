function [T,SM] = myostuthresh(f)
%MYOSTUTHRESH - Ostu's threshold
%
%   [T,SM] = myostuthresh(f)

%% 求归一化灰度直方图
h = imhist(f);
h = h./sum(h);
h = h(:);

%% 求累计概率分布
P = cumsum(h);

%% 求累计均值
i = (1:length(h))';
m = cumsum(i.*h);
mG = m(end);

%% 计算类间方差
sigSquared = ((mG*P-m).^2)./(P.*(1-P)+eps);

%% 求最佳阈值
maxSigsq = max(sigSquared);
T = mean(find(sigSquared == maxSigsq));
T = (T-1)/(length(h)-1);

%% 计算可分性测度
SM = maxSigsq/(sum(((i-mG).^2).*h)+eps);



