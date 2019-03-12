function resbboxes = mynms(bboxes,threshold,neighbornum,type)
%MYNMS - Non maximum suppression
%
%   resbboxes = mynms(bboxes,threshold,neighbornum,type)

% bboxes：m x 5矩阵,表示有m个框，5列分别是[x y w h score]
% threshold：重叠度阈值
% type：重叠度阈值类型

%% 参数检查
narginchk(3,4);
nargoutchk(0,1);

%% 输入参数值检查
% 参数bboxes
if isempty(bboxes)
  resbboxes = [];
  return;
end
% 参数type
if nargin < 4
    type = 1;
end

%% 提取bboxes各列的值
x1 = bboxes(:,1);
y1 = bboxes(:,2);
w = bboxes(:,3);
h = bboxes(:,4);    
score = bboxes(:,5);
x2 = x1+w-1;
y2 = y1+h-1;
% 计算每一个框的面积
area = w.*h;
% 将得分按升序排列
[~, I] = sort(score);

%% 算法
% 参数初始化
pick = score*0;
counter = 1;
% 循环直至所有框处理完成
while ~isempty(I)
    last = length(I); %当前剩余框的数量
    i = I(last); %选中最后一个，即得分最高的框
    %计算相交面积
    xx1 = max(x1(i),x1(I(1:last-1)));
    yy1 = max(y1(i),y1(I(1:last-1)));
    xx2 = min(x2(i),x2(I(1:last-1)));
    yy2 = min(y2(i),y2(I(1:last-1)));  
    w = max(0,xx2-xx1+1);
    h = max(0,yy2-yy1+1); 
    inter = w.*h;
    %不同定义下的重叠度
    if type==1
        %重叠面积与最小框面积的比值
        o = inter./min(area(i),area(I(1:last-1)));
    else
        %交集/并集
        o = inter./(area(i)+area(I(1:last-1))-inter);
    end
    %计算重叠面积大于等于阈值的框
    index = find(o>=threshold);
    if length(index)>=neighbornum
        pick(counter) = i;
        counter = counter+1;            
    end
    %保留所有重叠面积小于阈值的框，留作下次处理
    I = I(o<threshold);
end
pick = pick(1:(counter-1));
resbboxes = bboxes(pick,:);

