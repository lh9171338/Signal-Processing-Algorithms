function model = mybayesinit(traindata)
%MYBAYESINIT - Initial bayes classifier
%
%   model = mybayesinit(traindata)

%% 参数检查
narginchk(1,1);
nargoutchk(0,1);

%% 获取参数
if isempty(traindata)
    model = [];
    return;
end
data = traindata(1);
nfeature = numel(data.feature); %特征数量

%% 初始化引索表
table.classset = [];
table.featureset = cell(1,nfeature);

%% 构建引索表

%遍历训练样本
nsample = numel(traindata); %样本数量
for i=1:nsample
    data = traindata(i);
    class = data.class;
    classset = table.classset;
    if ~any(strcmp(class,classset)) %classset中不存在class
        classset = cat(1,classset,{class}); %将class添加到classset
        table.classset = classset;
    end
    %遍历特征
    for j=1:nfeature
        value = data.feature{j};
        valueset = table.featureset{j};
        if ischar(value) %字符串
            if ~any(strcmp(value,valueset)) %valueset中不存在value
                valueset = cat(1,valueset,{value}); %将value添加到valueset
                table.featureset{j} = valueset;
            end        
        else %数字
            if ~any(value == cell2mat(valueset)) %valueset中不存在value
                valueset = cat(1,valueset,{value}); %将value添加到valueset
                table.featureset{j} = valueset;
            end                
        end
    end
end

%% 保存引索表
model.table = table;
