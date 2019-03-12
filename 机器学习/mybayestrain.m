function model = mybayestrain(model,traindata)
%MYBAYESTRAIN - Train bayes classifier
%
%   model = mybayestrain(traindata)

%% 参数检查
narginchk(2,2);
nargoutchk(0,1);

%% 初始化模型
if isempty(model)
    return;
end

%% 获取参数
table = model.table; %样本结构体的引索表
nclass = numel(table.classset); %类别数量
nfeature = numel(table.featureset); %特征数量

%% 初始化概率
probability = cell(nclass,nfeature+1); %先验概率和条件概率
for i=1:nclass
    %先验概率
    probability{i,1} = 0; 
    %条件概率
    for j=1:nfeature
        nvalue = numel(table.featureset{j}); %第j个特征的取值个数
        probability{i,j+1} = zeros(1,nvalue);
    end
end

%% 统计次数
%遍历训练样本
nsample = numel(traindata); %样本数量 
for i=1:nsample
    data = traindata(i);
    class = data.class;
    classset = table.classset;
    indexclass = find(strcmp(class,classset));
    %类别次数加1
    probability{indexclass,1} = probability{indexclass,1}+1; 
    %遍历特征
    for j=1:nfeature
        value = data.feature{j};
        valueset = table.featureset{j};
        if ischar(value) %字符串
            index = find(strcmp(value,valueset));
        else %数字
            index = find(value == cell2mat(valueset));
        end
        probability{indexclass,j+1}(index) = probability{indexclass,j+1}(index)+1; %第j个特征取第index个值的次数加1
    end
end

%% 计算概率
for i=1:nclass
    num = probability{i,1}; %第i类出现次数
    %先验概率
    probability{i,1} = probability{i,1}/nsample; %用nsample归一化
    %条件概率
    for j=2:nfeature+1
        probability{i,j} = probability{i,j}/num; %用num归一化
    end
end

%% 保存概率
model.probability = probability;
